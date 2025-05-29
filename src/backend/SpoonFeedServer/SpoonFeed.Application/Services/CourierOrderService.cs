using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SpoonFeed.Application.DTOs.Order;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Persistence;

namespace SpoonFeed.Application.Services;

public class CourierOrderService : ICourierOrderService
{
    private readonly IMapper _mapper;
    private readonly SpoonFeedDbContext _db;
    private readonly ILogger<CourierOrderService> _logger;

    public CourierOrderService(IMapper mapper, SpoonFeedDbContext db, ILogger<CourierOrderService> logger)
    {
        _mapper = mapper;
        _db = db;
        _logger = logger;
    }

    public async Task<Result<OrderPickupStatusResponse>> GetOrderPickupStatusAsync(CancellationToken ct, Guid orderId)
    {
        _logger.LogInformation("Getting pickup status for order {OrderId}", orderId);

        var order = await _db.Orders.FirstOrDefaultAsync(o => o.Id == orderId, ct);
        if (order == null)
        {
            _logger.LogWarning("Order with ID {OrderId} not found", orderId);
            return Result<OrderPickupStatusResponse>.FailureResult("Couldn't find an order with such id");
        }

        var remainingFacilities = await _db.OrderPositions
            .Where(op => op.OrderId == orderId && op.PickupStatus != OrderPositionPickupStatus.PickedUp)
            .GroupBy(op => new { op.MenuItem.FoodFacilityId, op.MenuItem.FoodFacility.Name })
            .Select(g => new FacilityDto
            {
                Id = g.Key.FoodFacilityId,
                FacilityName = g.Key.Name,
                PositionsRemaining = g.Count()
            })
            .ToListAsync(ct);

        var response = new OrderPickupStatusResponse
        {
            AllPickedUp = remainingFacilities.Count == 0,
            RemainingFacilities = remainingFacilities
        };

        if (response.AllPickedUp)
        {
            order.Status = OrderStatus.Delivering;
            _logger.LogInformation("All items picked up for order {OrderId}. Status changed to Delivering", orderId);

            try
            {
                await _db.SaveChangesAsync(ct);
            }
            catch (Exception e)
            {
                _logger.LogError(e, "Error saving updated status for order {OrderId}", orderId);
                return Result<OrderPickupStatusResponse>.FailureResult("An internal error occurred", ErrorType.ServerError);
            }
        }

        _logger.LogInformation("Pickup status checked for order {OrderId}. AllPickedUp: {AllPickedUp}", orderId, response.AllPickedUp);
        return Result<OrderPickupStatusResponse>.SuccessResult(response);
    }

    public async Task<Result<bool>> RespondToOrderAsync(Guid courierId, Guid orderId, OrderResponseAction responseAction, CancellationToken ct)
    {
        _logger.LogInformation("Courier {CourierId} is responding to order {OrderId} with action {Action}", courierId, orderId, responseAction);

        var courier = await _db.Couriers.FirstOrDefaultAsync(c => c.UserIdentityId == courierId, ct);
        if (courier == null)
        {
            _logger.LogWarning("Courier {CourierId} not found", courierId);
            return Result<bool>.FailureResult("Courier with such id was not found", ErrorType.NotFound);
        }

        var order = await _db.Orders.FirstOrDefaultAsync(o => o.Id == orderId, ct);
        if (order == null)
        {
            _logger.LogWarning("Order {OrderId} not found", orderId);
            return Result<bool>.FailureResult("Order with such id was not found", ErrorType.NotFound);
        }

        bool waitingForAction = order.Status == OrderStatus.WaitingForCourier &&
                                order.CourierId == courierId &&
                                courier.CourierStatus == CourierStatus.Assigned;

        if (!waitingForAction)
        {
            _logger.LogWarning("Courier {CourierId} not eligible to respond to order {OrderId}", courierId, orderId);
            return Result<bool>.FailureResult("Order's status is not WaitingForCourier or an order is not assigned to courier.", ErrorType.Forbidden);
        }

        switch (responseAction)
        {
            case OrderResponseAction.Accept:
                order.Status = OrderStatus.WaitingOrderItem;
                // todo: create Pending Customer -> Courier Transaction
                _logger.LogInformation("Courier {CourierId} accepted order {OrderId}", courierId, orderId);
                break;
            case OrderResponseAction.Reject:
                order.Status = OrderStatus.WaitingForCourier;
                order.CourierId = null;
                courier.CourierStatus = CourierStatus.WaitingForOrder;
                _logger.LogInformation("Courier {CourierId} rejected order {OrderId}. Unassigning courier.", courierId, orderId);
                break;
            default:
                _logger.LogWarning("Unknown response action {Action} for order {OrderId}", responseAction, orderId);
                return Result<bool>.FailureResult("Unknown action", ErrorType.NotFound);
        }

        try
        {
            _db.Orders.Update(order);
            _db.Couriers.Update(courier);
            await _db.SaveChangesAsync(ct);
            _logger.LogInformation("Order {OrderId} and courier {CourierId} updated successfully", orderId, courierId);
            return Result<bool>.SuccessResult(true);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error updating response for order {OrderId}", orderId);
            return Result<bool>.FailureResult("An internal error occurred", ErrorType.ServerError);
        }
    }

    public async Task<Result<bool>> CompleteDeliveryWithCodeAsync(
        Guid courierId,
        Guid orderId,
        DeliveryCodeRequest code,
        CancellationToken ct)
    {
        _logger.LogInformation("Courier {CourierId} attempting to complete delivery for order {OrderId}", courierId, orderId);

        var order = await _db.Orders
            .Where(o => o.Id == orderId && o.CourierId == courierId)
            .FirstOrDefaultAsync(ct);

        if (order == null)
        {
            _logger.LogWarning("Order {OrderId} not found or not assigned to courier {CourierId}", orderId, courierId);
            return Result<bool>.FailureResult("Order not found or not assigned to this courier", ErrorType.NotFound);
        }

        if (order.Status == OrderStatus.Delivered)
        {
            _logger.LogWarning("Order {OrderId} has already been delivered", orderId);
            return Result<bool>.FailureResult("Order is already delivered", ErrorType.Validation);
        }

        if (order.Status != OrderStatus.Delivering)
        {
            _logger.LogWarning("Order {OrderId} is not in delivery phase", orderId);
            return Result<bool>.FailureResult("Order is not in delivery phase.", ErrorType.Validation);
        }

        if (order.DeliveryConfirmationCode != code.Code)
        {
            _logger.LogWarning("Invalid confirmation code for order {OrderId} by courier {CourierId}", orderId, courierId);
            return Result<bool>.FailureResult("Invalid confirmation code.", ErrorType.Forbidden);
        }

        order.Status = OrderStatus.Delivered;
        order.DeliveredAt = DateTime.UtcNow;

        try
        {
            _db.Orders.Update(order);
            await _db.SaveChangesAsync(ct);
            _logger.LogInformation("Order {OrderId} successfully marked as delivered by courier {CourierId}", orderId, courierId);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Failed to save delivered status for order {OrderId}", orderId);
            return Result<bool>.FailureResult("An internal error occurred", ErrorType.ServerError);
        }

        return Result<bool>.SuccessResult(true);
    }
}

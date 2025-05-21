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
        var order = await _db.Orders.FindAsync(orderId, ct);

        if (order == null)
        {
            return Result<OrderPickupStatusResponse>.FailureResult("Couldn't find an order with such id");
        }

        var remainingFacilities = await _db.OrderPositions
            .Where(op => op.OrderId == orderId
                         && op.PickupStatus != OrderPositionPickupStatus.PickedUp)
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
            
        }

        return Result<OrderPickupStatusResponse>.SuccessResult(response);
    }

    public async Task<Result<bool>> RespondToOrderAsync(Guid courierId, Guid orderId, OrderResponseAction responseAction, CancellationToken ct)
    {
        var courier = await _db.Couriers.FindAsync(courierId, ct);
        
        if (courier == null)
        {
            return Result<bool>.FailureResult("Courier with such id was not found", ErrorType.NotFound);
        }
        
        var order = await _db.Orders.FindAsync(orderId, ct);
        
        if (order == null)
        {
            return Result<bool>.FailureResult("Order with such id was not found", ErrorType.NotFound);
        }

        bool waitingForAction = order.Status == OrderStatus.WaitingForCourier
                                && order.CourierId == courierId
                                && courier.CourierStatus == CourierStatus.Assigned;
        
        if (!waitingForAction)
        {
            return Result<bool>.FailureResult(
                "Order`s status is not WaitingForCourier or an order is not assigned to courier.", ErrorType.Forbidden);
        }

        switch (responseAction)
        {
            case OrderResponseAction.Accept:
                order.Status = OrderStatus.WaitingOrderItem;
                break;
            case OrderResponseAction.Reject:
                order.Status = OrderStatus.WaitingForCourier;
                order.CourierId = null;
                courier.CourierStatus = CourierStatus.WaitingForOrder;
                break;
            default:
                return Result<bool>.FailureResult("Unknown action", ErrorType.NotFound);
        }

        try
        {
            _db.Orders.Update(order);
            _db.Couriers.Update(courier);
            await _db.SaveChangesAsync(ct);

            return Result<bool>.SuccessResult(true);
        }
        catch (Exception e)
        {
            _logger.LogError(e.Message);
            
            return Result<bool>.FailureResult("An internal error occured", ErrorType.ServerError);
        }
    }
}
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SpoonFeed.Application.DTOs.Order;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Domain.Models;
using SpoonFeed.Domain.Owned;
using SpoonFeed.Persistence;

namespace SpoonFeed.Application.Services;

public class OrderService : IOrderService
{
    private readonly IMapper _mapper;
    private readonly SpoonFeedDbContext _db;
    private readonly ILogger<OrderService> _logger;
    private IPaymentService _paymentService;
    
    public OrderService(IMapper mapper, SpoonFeedDbContext db, ILogger<OrderService> logger, IPaymentService paymentService)
    {
        _mapper = mapper;
        _db = db;
        _logger = logger;
        _paymentService = paymentService;
    }
    
    public async Task<Result<Guid>> CreateOrderAsync(CreateOrderDto orderDto, Guid userId, CancellationToken ct)
    {
        var address = _mapper.Map<Address>(orderDto.DeliveryAddress);
        var orderPositions = _mapper.Map<IList<OrderPosition>>(orderDto.OrderPositions);
        var order = _mapper.Map<Order>(orderDto);

        order.CustomerId = userId;
        order.Status = OrderStatus.PendingPayment;
        order.DeliveryAddress = address;
        order.OrderPositions = orderPositions;

        try
        {
            await _db.Orders.AddAsync(order, ct);
            await _db.SaveChangesAsync(ct);
            
            return Result<Guid>.SuccessResult(order.Id);
        }
        catch (Exception e)
        {
            _logger.LogError(e.Message);
            
            return Result<Guid>.FailureResult(
                "An internal error occured while trying to post an order.", ErrorType.ServerError);
        }
    }

    public async Task<Result<IList<OrderPositionDto>>> GetOrderPositionsAsync(
        CancellationToken ct,
        Guid orderId, 
        OrderPositionPickupStatus? positionStatus = null)
    {
        var order = await _db.Orders.FindAsync(orderId, ct);

        if (order == null)
        {
            return Result<IList<OrderPositionDto>>.FailureResult("Couldn't find an order with such id");
        }

        var query = _db.OrderPositions
            .Where(op => op.OrderId == orderId);

        if (positionStatus != null)
        {
            query = query.Where(op => op.PickupStatus == positionStatus);
        }

        var readyPositions = await query
            .Select(op => new OrderPositionDto
            {
                FoodFacilityId = op.MenuItem.FoodFacilityId,
                OrderPositionName = op.MenuItem.Name,
                FoodFacilityName = op.MenuItem.FoodFacility.Name,
                OrderPositionQuantity = op.Quantity,
                PickupStatus = op.PickupStatus
            })
            .ToListAsync(ct);

        return Result<IList<OrderPositionDto>>.SuccessResult(readyPositions);
    }

}
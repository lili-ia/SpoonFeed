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

public class CustomerOrderService : ICustomerOrderService
{
    private readonly IMapper _mapper;
    private readonly SpoonFeedDbContext _db;
    private readonly ILogger<CustomerOrderService> _logger;
    
    public CustomerOrderService(IMapper mapper, SpoonFeedDbContext db, ILogger<CustomerOrderService> logger)
    {
        _mapper = mapper;
        _db = db;
        _logger = logger;
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
        order.DeliveryConfirmationCode = GenerateConfirmationCode();

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

    public async Task<Result<IList<OrderInfoDto>>> GetOrdersHistoryAsync(Guid userId, CancellationToken ct)
    {
        var orders = await _db.Orders
            .Where(o => o.CustomerId == userId)
            .Select(o => new OrderInfoDto
            {
                OrderStatus = o.Status,
                DeliveredAt = o.Status == OrderStatus.Delivered ? o.DeliveredAt : null,
                PaymentMethod = o.PaymentMethod,
                Total = o.Total,
                OrderPositions = o.OrderPositions
                    .Select(op => new OrderPositionDto
                    {
                        OrderPositionName = op.MenuItem.Name,
                        FoodFacilityName = op.MenuItem.FoodFacility.Name,
                        OrderPositionQuantity = op.Quantity,
                        PickupStatus = op.PickupStatus
                    }).ToList()
            })
            .ToListAsync(ct);

        return Result<IList<OrderInfoDto>>.SuccessResult(orders);
    }

    public async Task<Result<OrderInfoDto>> GetOrderDetailsAsync(Guid userId, Guid orderId, CancellationToken ct)
    {
        var order = await _db.Orders
            .Where(o => o.Id == orderId && o.CustomerId == userId)
            .FirstOrDefaultAsync(ct);

        if (order == null)
        {
            return Result<OrderInfoDto>.FailureResult("Order was not found", ErrorType.NotFound);
        }
        
        var orderDto = _mapper.Map<OrderInfoDto>(order);
        
        //  todo: cached courier location
        
        return Result<OrderInfoDto>.SuccessResult(orderDto);
    }

    public async Task<Result<OrderStatus>> GetOrderStatus(Guid userId, Guid orderId, CancellationToken ct)
    {
        var order = await _db.Orders
            .Where(o => o.Id == orderId && o.CustomerId == userId)
            .FirstOrDefaultAsync(ct);

        if (order == null)
        {
            return Result<OrderStatus>.FailureResult("Order was not found", ErrorType.NotFound);
        }
        
        return Result<OrderStatus>.SuccessResult(order.Status);
    }
    
    private string GenerateConfirmationCode()
    {
        var random = new Random();
        return random.Next(1000, 9999).ToString(); 
    }
}
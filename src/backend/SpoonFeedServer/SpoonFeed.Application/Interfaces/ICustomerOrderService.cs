using SpoonFeed.Application.DTOs.Order;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.Interfaces;

public interface ICustomerOrderService
{
    Task<Result<Guid>> CreateOrderAsync(
        CreateOrderDto orderDto, 
        Guid userId, 
        CancellationToken ct);
    
    Task<Result<IList<OrderInfoDto>>> GetOrdersHistoryAsync(Guid userId, CancellationToken ct);
    
    Task<Result<OrderInfoDto>> GetOrderDetailsAsync(Guid userId, Guid orderId, CancellationToken ct);

    Task<Result<OrderStatus>> GetOrderStatus(Guid userId, Guid orderId, CancellationToken ct);
}
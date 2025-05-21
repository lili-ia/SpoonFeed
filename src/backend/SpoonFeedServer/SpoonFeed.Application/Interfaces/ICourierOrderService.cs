using SpoonFeed.Application.DTOs.Order;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.Interfaces;

public interface ICourierOrderService
{
    Task<Result<OrderPickupStatusResponse>> GetOrderPickupStatusAsync(
        CancellationToken ct,
        Guid orderId);
    
    Task<Result<bool>> RespondToOrderAsync(
        Guid courierId, 
        Guid orderId, 
        OrderResponseAction responseAction, 
        CancellationToken ct);
}
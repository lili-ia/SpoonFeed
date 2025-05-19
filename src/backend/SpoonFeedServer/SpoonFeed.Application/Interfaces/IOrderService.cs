using SpoonFeed.Application.DTOs.Order;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Domain.Models;

namespace SpoonFeed.Application.Interfaces;

public interface IOrderService
{
    Task<Result<Guid>> CreateOrderAsync(
        CreateOrderDto orderDto, 
        Guid userId, 
        CancellationToken ct);

    Task<Result<IList<OrderPositionDto>>> GetOrderPositionsAsync(
        CancellationToken ct,
        Guid orderId, 
        OrderPositionPickupStatus? positionStatus = null);
}
using SpoonFeed.Application.DTOs.Order;

namespace SpoonFeed.Application.Interfaces;

public interface IOrderService
{
    Task<Result<Guid>> CreateOrderAsync(
        CreateOrderDto orderDto, 
        Guid userId, 
        CancellationToken ct);
}
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

    Task<Result<OrderPickupStatusResponse>> GetOrderPickupStatusAsync(
        CancellationToken ct,
        Guid orderId);
}
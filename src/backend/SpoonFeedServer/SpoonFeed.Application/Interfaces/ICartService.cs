using SpoonFeed.Application.DTOs.Cart;

namespace SpoonFeed.Application.Interfaces;

public interface ICartService
{
    Task<Result<CartDto>> GetCartAsync(Guid customerId, CancellationToken ct);
    
    Task<Result<bool>> AddToCartAsync(Guid customerId, AddToCartRequest request, CancellationToken ct);
    
    Task<Result<bool>> RemoveFromCartAsync(Guid customerId, RemoveFromCartRequest request, CancellationToken ct);

    Task<Result<bool>> ClearCartAsync(Guid customerId, CancellationToken ct);
}
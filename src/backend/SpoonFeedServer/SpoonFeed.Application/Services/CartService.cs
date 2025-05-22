using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;
using SpoonFeed.Application.DTOs.Cart;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Persistence;

namespace SpoonFeed.Application.Services;

public class CartService : ICartService
{
    private readonly IMemoryCache _cache;
    private readonly ILogger<CartService> _logger;
    private readonly TimeSpan _cartExpiration = TimeSpan.FromDays(1);
    private readonly SpoonFeedDbContext _db;
    
    public CartService(IMemoryCache cache, ILogger<CartService> logger, SpoonFeedDbContext db)
    {
        _cache = cache;
        _logger = logger;
        _db = db;
    }

    private string GetCacheKey(Guid customerId) => $"cart_{customerId}";

    private async Task<CartDto> GetOrCreateCartAsync(Guid customerId)
    {
        var key = GetCacheKey(customerId);

        if (!_cache.TryGetValue<CartDto>(key, out var cartDto))
        {
            _logger.LogInformation($"Cart not found for customer {customerId}. Creating a new cart.");
            cartDto = new CartDto();
            _cache.Set(key, cartDto, _cartExpiration);
        }

        return cartDto;
    }

    public async Task<Result<CartDto>> GetCartAsync(Guid customerId, CancellationToken ct)
    {
        var cartDto = await GetOrCreateCartAsync(customerId);

        var menuItemIds = cartDto.Items.Select(i => i.MenuItemId).ToList();

        var menuItems = await _db.MenuItems
            .Where(mi => menuItemIds.Contains(mi.Id))
            .Select(mi => new { mi.Id, mi.Name, mi.Image.Url }) 
            .ToListAsync(ct);

        foreach (var item in cartDto.Items)
        {
            var menuItem = menuItems.FirstOrDefault(mi => mi.Id == item.MenuItemId);
            if (menuItem != null)
            {
                item.Name = menuItem.Name;
                item.Pic = menuItem.Url;
            }
        }

        _logger.LogInformation($"Cart retrieved for customer {customerId}. Items: {cartDto.Items.Count}");

        return Result<CartDto>.SuccessResult(cartDto);
    }


    public async Task<Result<bool>> AddToCartAsync(Guid customerId, AddToCartRequest request, CancellationToken ct)
    {
        var cartDto = await GetOrCreateCartAsync(customerId);

        var existing = cartDto.Items.FirstOrDefault(i => i.MenuItemId == request.MenuItemId);

        if (existing != null)
        {
            existing.Quantity += request.Quantity;
            _logger.LogInformation($"Increased quantity of MenuItem {request.MenuItemId} in cart for customer {customerId} by {request.Quantity}.");
        }
        else
        {
            cartDto.Items.Add(new CartItemDto
            {
                MenuItemId = request.MenuItemId,
                Quantity = request.Quantity
            });

            _logger.LogInformation($"Added MenuItem {request.MenuItemId} (Qty: {request.Quantity}) to cart for customer {customerId}.");
        }

        _cache.Set(GetCacheKey(customerId), cartDto, _cartExpiration);

        return Result<bool>.SuccessResult(true);
    }

    public async Task<Result<bool>> RemoveFromCartAsync(Guid customerId, RemoveFromCartRequest request, CancellationToken ct)
    {
        var key = GetCacheKey(customerId);

        if (!_cache.TryGetValue<CartDto>(key, out var cartDto))
        {
            _logger.LogWarning($"Attempted to remove item from non-existent cart for customer {customerId}.");
            
            return Result<bool>.FailureResult("Cart not found.");
        }

        var existing = cartDto.Items.FirstOrDefault(i => i.MenuItemId == request.MenuItemId);

        if (existing == null)
        {
            _logger.LogWarning($"Attempted to remove MenuItem {request.MenuItemId} that doesn't exist in cart for customer {customerId}.");
            return Result<bool>.FailureResult("Item not found in cart.");
        }

        cartDto.Items.Remove(existing);

        _logger.LogInformation($"Removed MenuItem {request.MenuItemId} from cart for customer {customerId}.");

        _cache.Set(key, cartDto, _cartExpiration);

        return Result<bool>.SuccessResult(true);
    }

    public async Task<Result<bool>> ClearCartAsync(Guid customerId, CancellationToken ct)
    {
        _cache.Remove(GetCacheKey(customerId));
        _logger.LogInformation($"Cleared cart for customer {customerId}.");
        
        return Result<bool>.SuccessResult(true);
    }
}

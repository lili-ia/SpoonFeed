using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.Cart;
using SpoonFeed.Application.DTOs.Order;
using SpoonFeed.Application.Interfaces;
using SpoonFeedServer.Extensions;

namespace SpoonFeedServer.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize(Roles = "Customer")]
public class CustomerController : ControllerBase
{
    private readonly IUserContextService _userContextService;
    private ICustomerOrderService _customerOrderService;
    private ICartService _cartService;
    
    public CustomerController(
        IUserContextService userContextService, 
        ICustomerOrderService customerOrderService, 
        ICartService cartService)
    {
        _userContextService = userContextService;
        _customerOrderService = customerOrderService;
        _cartService = cartService;
    }
    
    [HttpPost("orders")]
    public async Task<IActionResult> CreateOrder([FromBody] CreateOrderDto orderDto, CancellationToken ct)
    {
        var customerIdResult = TryGetCustomerId(out var customerId);
        
        if (customerIdResult != null)
        {
            return customerIdResult;
        }
        
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var result = await _customerOrderService.CreateOrderAsync(orderDto, customerId, ct);

        return result.ToActionResult();
    }

    [HttpGet("orders")]
    public async Task<IActionResult> GetOrdersHistory(CancellationToken ct)
    {
        var customerIdResult = TryGetCustomerId(out var customerId);
        
        if (customerIdResult != null)
        {
            return customerIdResult;
        }

        var result = await _customerOrderService.GetOrdersHistoryAsync(customerId, ct);

        return result.ToActionResult();
    }

    [HttpGet("orders/{orderId}")]
    public async Task<IActionResult> GetOrderDetails(Guid orderId, CancellationToken ct)
    {
        var customerIdResult = TryGetCustomerId(out var customerId);
        
        if (customerIdResult != null)
        {
            return customerIdResult;
        }

        var result = await _customerOrderService.GetOrderDetailsAsync(customerId, orderId, ct);

        return result.ToActionResult();
    }

    [HttpGet("orders/{orderId}/status")]
    public async Task<IActionResult> GetOrderStatus(Guid orderId, CancellationToken ct)
    {
        var customerIdResult = TryGetCustomerId(out var customerId);
        
        if (customerIdResult != null)
        {
            return customerIdResult;
        }

        var result = await _customerOrderService.GetOrderStatus(customerId, orderId, ct);

        return result.ToActionResult();
    }

    [HttpPost("orders/{orderId}/cancel")]
    public async Task<IActionResult> CancelOrder(Guid orderId, CancellationToken ct)
    {
        return Ok();
    }

    [HttpGet("cart")]
    public async Task<IActionResult> GetCart(CancellationToken ct)
    {
        var customerIdResult = TryGetCustomerId(out var customerId);
        
        if (customerIdResult != null)
        {
            return customerIdResult;
        }

        var result = await _cartService.GetCartAsync(customerId, ct);

        return result.ToActionResult();
    }

    [HttpPost("cart/add")]
    public async Task<IActionResult> AddToCart([FromBody] AddToCartRequest request, CancellationToken ct)
    {
        var customerIdResult = TryGetCustomerId(out var customerId);
        
        if (customerIdResult != null)
        {
            return customerIdResult;
        }
        
        var result = await _cartService.AddToCartAsync(customerId, request, ct);

        return result.ToActionResult();
    }

    [HttpPost("cart/remove")]
    public async Task<IActionResult> RemoveFromCart([FromBody] RemoveFromCartRequest request, CancellationToken ct)
    {
        var customerIdResult = TryGetCustomerId(out var customerId);
        
        if (customerIdResult != null)
        {
            return customerIdResult;
        }

        var result = await _cartService.RemoveFromCartAsync(customerId, request, ct);

        return result.ToActionResult();
    }

    [HttpPost("orders/{orderId}/pay")]
    public async Task<IActionResult> PayForOrder(Guid orderId, CancellationToken ct)
    {
        return Ok();
    }

    [HttpGet("profile")]
    public async Task<IActionResult> GetProfile(CancellationToken ct)
    {
        return Ok();
    }

    private IActionResult? TryGetCustomerId(out Guid customerId)
    {
        try
        {
            customerId = _userContextService.GetUserId();
            return null;
        }
        catch (UnauthorizedAccessException)
        {
            customerId = Guid.Empty;
            return Unauthorized("Customer was not found.");
        }
    }
}
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.Courier;
using SpoonFeed.Application.DTOs.Order;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeedServer.Extensions;

namespace SpoonFeedServer.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize(Roles = "Courier")]
public class CourierController : ControllerBase
{
    private readonly ICourierService _courierService;
    private ICourierOrderService _courierOrderService;
    private ICustomerOrderService _customerOrderService;
    private readonly IUserContextService _userContextService;
    
    public CourierController(
        ICourierService courierService, 
        IUserContextService userContextService, 
        ICourierOrderService courierOrderService, 
        ICustomerOrderService customerOrderService)
    {
        _courierService = courierService;
        _userContextService = userContextService;
        _courierOrderService = courierOrderService;
        _customerOrderService = customerOrderService;
    }
    
    [HttpGet("status")]
    public async Task<IActionResult> GetCourierStatus(CancellationToken ct)
    {
        var courierIdResult = TryGetCourierId(out var courierId);
        
        if (courierIdResult != null)
        {
            return courierIdResult;
        }
        
        var result = await _courierService.GetCourierStatusAsync(courierId, ct);

        return result.ToActionResult();
    }

    [HttpPost("status")]
    public async Task<IActionResult> SetCourierStatus([FromBody] CourierStatusDto status, CancellationToken ct)
    {
        var courierIdResult = TryGetCourierId(out var courierId);
        
        if (courierIdResult != null)
        {
            return courierIdResult;
        }
        
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }
        
        var result = await _courierService.SetCourierStatusAsync(courierId, status.CourierStatus, ct);

        return result.ToActionResult();
    }

    [HttpPost("accept/{orderId}")]
    public async Task<IActionResult> AcceptOrder(Guid orderId, CancellationToken ct)
    {
        var courierIdResult = TryGetCourierId(out var courierId);
        
        if (courierIdResult != null)
        {
            return courierIdResult;
        }
        
        var result = await _courierOrderService.RespondToOrderAsync(courierId, orderId, OrderResponseAction.Accept, ct);
        
        return result.ToActionResult();
    }

    [HttpPost("reject/{orderId}")]
    public async Task<IActionResult> RejectOrder(Guid orderId, CancellationToken ct)
    {
        var courierIdResult = TryGetCourierId(out var courierId);
        
        if (courierIdResult != null)
        {
            return courierIdResult;
        }
        
        var result = await _courierOrderService.RespondToOrderAsync(courierId, orderId, OrderResponseAction.Reject, ct);
        
        return result.ToActionResult();
    }
    
    [HttpGet("orders/{orderId}/pickup-status")]
    public async Task<IActionResult> GetOrderPickupStatus(Guid orderId, CancellationToken ct)
    {
        var result = await _courierOrderService.GetOrderPickupStatusAsync(ct, orderId);

        return result.ToActionResult();
    }

    [HttpPost("orders/{orderId}/complete")]
    public async Task<IActionResult> CompleteDeliveryWithCode(
        [FromRoute] Guid orderId, 
        [FromBody] DeliveryCodeRequest code,
        CancellationToken ct)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }
    
        var courierIdResult = TryGetCourierId(out var courierId);
        
        if (courierIdResult != null)
        {
            return courierIdResult;
        }
        
        var result = await _courierOrderService
            .CompleteDeliveryWithCodeAsync(courierId, orderId, code, ct);

        return result.ToActionResult();
    }

    private IActionResult? TryGetCourierId(out Guid courierId)
    {
        try
        {
            courierId = _userContextService.GetUserId();
            return null;
        }
        catch (UnauthorizedAccessException)
        {
            courierId = Guid.Empty;
            return Unauthorized("Courier was not found.");
        }
    }
}
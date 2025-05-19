using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.Courier;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeedServer.Extensions;

namespace SpoonFeedServer.Controllers;

[Route("api/[controller]")]
[ApiController]
public class CourierController : ControllerBase
{
    private readonly ICourierService _courierService;
    private IOrderService _orderService;
    public CourierController(ICourierService courierService, IOrderService orderService)
    {
        _courierService = courierService;
        _orderService = orderService;
    }
    
    [HttpGet("{courierId}/status")]
    [Authorize]
    public async Task<IActionResult> GetCourierStatus(Guid courierId, CancellationToken ct)
    {
        var result = await _courierService.GetCourierStatusAsync(courierId, ct);

        return result.ToActionResult();
    }

    [HttpPost("{courierId}/status")]
    [Authorize] // todo: Role = Courier
    public async Task<IActionResult> SetCourierStatus(Guid courierId, [FromBody] CourierStatusDto status, CancellationToken ct)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var result = await _courierService.SetCourierStatusAsync(courierId, status.CourierStatus, ct);

        return result.ToActionResult();
    }

    [HttpPost("{courierId}/accept/{orderId}")]
    public async Task<IActionResult> AcceptOrder(Guid courierId, Guid orderId, CancellationToken ct)
    {
        var result = await _courierService.RespondToOrderAsync(courierId, orderId, OrderResponseAction.Accept, ct);
        
        return result.ToActionResult();
    }

    [HttpPost("{courierId}/reject/{orderId}")]
    public async Task<IActionResult> RejectOrder(Guid courierId, Guid orderId, CancellationToken ct)
    {
        var result = await _courierService.RespondToOrderAsync(courierId, orderId, OrderResponseAction.Reject, ct);
        
        return result.ToActionResult();
    }

    [HttpPost("{courierId}/start/{orderId}")]
    public IActionResult StartDelivery(Guid courierId, Guid orderId)
    {
        // Потрібна логіка для початку доставки замовлення
        return Ok();
    }

    [HttpPost("{courierId}/complete/{orderId}")]
    public IActionResult CompleteDelivery(Guid courierId, Guid orderId)
    {
        // Потрібна логіка для завершення доставки замовлення
        return Ok();
    }

    [HttpGet("{courierId}/history")]
    public IActionResult GetCourierHistory(Guid courierId)
    {
        // Потрібна логіка для отримання історії замовлень кур'єра
        return Ok();
    }

    [HttpPost("{courierId}/location")]
    public IActionResult UpdateCourierLocation(Guid courierId/*, [FromBody] LocationDto location*/)
    {
        // Потрібна логіка для оновлення місцезнаходження кур'єра
        return Ok();
    }

    [HttpGet("{courierId}/current-order")]
    public IActionResult GetCurrentOrder(Guid courierId)
    {
        // Потрібна логіка для отримання поточного замовлення кур'єра
        return Ok();
    }
    
    [HttpGet("orders/{orderId}/ready-positions")]
    public async Task<IActionResult> GetReadyOrderPositions(Guid orderId, CancellationToken ct)
    {
        var result = await _orderService.GetOrderPositionsAsync(ct, orderId, OrderPositionPickupStatus.Ready);

        return result.ToActionResult();
    }
    
    [HttpGet("orders/{orderId}/all-positions")]
    public async Task<IActionResult> GetAllOrderPositions(Guid orderId, CancellationToken ct)
    {
        var result = await _orderService.GetOrderPositionsAsync(ct, orderId);

        return result.ToActionResult();
    }
}
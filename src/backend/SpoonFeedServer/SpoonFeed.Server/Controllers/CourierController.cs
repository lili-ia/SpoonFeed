using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.Courier;
using SpoonFeed.Application.Interfaces;
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
    
    [HttpGet("courier/{courierId}/status")]
    [Authorize]
    public async Task<IActionResult> GetCourierStatus(Guid courierId, CancellationToken ct)
    {
        var result = await _courierService.GetCourierStatusAsync(courierId, ct);

        return result.ToActionResult();
    }

    [HttpPost("courier/{courierId}/status")]
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

    [HttpPost("courier/{courierId}/accept/{orderId}")]
    public IActionResult AcceptOrder(int courierId, int orderId)
    {
        // Потрібна логіка для прийняття замовлення
        return Ok();
    }

    [HttpPost("courier/{courierId}/reject/{orderId}")]
    public IActionResult RejectOrder(int courierId, int orderId)
    {
        // Потрібна логіка для відмови від замовлення
        return Ok();
    }

    [HttpPost("courier/{courierId}/start/{orderId}")]
    public IActionResult StartDelivery(Guid courierId, Guid orderId)
    {
        // Потрібна логіка для початку доставки замовлення
        return Ok();
    }

    [HttpPost("courier/{courierId}/complete/{orderId}")]
    public IActionResult CompleteDelivery(Guid courierId, Guid orderId)
    {
        // Потрібна логіка для завершення доставки замовлення
        return Ok();
    }

    [HttpGet("courier/{courierId}/history")]
    public IActionResult GetCourierHistory(Guid courierId)
    {
        // Потрібна логіка для отримання історії замовлень кур'єра
        return Ok();
    }

    [HttpPost("courier/{courierId}/location")]
    public IActionResult UpdateCourierLocation(Guid courierId/*, [FromBody] LocationDto location*/)
    {
        // Потрібна логіка для оновлення місцезнаходження кур'єра
        return Ok();
    }

    [HttpGet("courier/{courierId}/current-order")]
    public IActionResult GetCurrentOrder(Guid courierId)
    {
        // Потрібна логіка для отримання поточного замовлення кур'єра
        return Ok();
    }
}
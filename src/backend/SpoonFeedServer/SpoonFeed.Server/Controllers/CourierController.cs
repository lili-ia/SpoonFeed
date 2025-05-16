using Microsoft.AspNetCore.Mvc;

namespace SpoonFeedServer.Controllers;

[Route("api/[controller]")]
[ApiController]
public class CourierController : ControllerBase
{
    //  для управління кур'єрськими замовленнями, статусами, історією.
    public CourierController()
    {
        
    }
    
    [HttpGet("courier/{courierId}/status")]
    public IActionResult GetCourierStatus(int courierId)
    {
        // Потрібна логіка для отримання статусу кур'єра
        return Ok();
    }

    [HttpPost("courier/{courierId}/status")]
    public IActionResult SetCourierStatus(int courierId/*, [FromBody] CourierStatus status*/)
    {
        // Потрібна логіка для зміни статусу кур'єра
        return Ok();
    }

    [HttpPost("courier/{courierId}/assign/{orderId}")]
    public IActionResult AssignOrderToCourier(int courierId, int orderId)
    {
        // Потрібна логіка для призначення замовлення кур'єру
        return Ok();
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
    public IActionResult StartDelivery(int courierId, int orderId)
    {
        // Потрібна логіка для початку доставки замовлення
        return Ok();
    }

    [HttpPost("courier/{courierId}/complete/{orderId}")]
    public IActionResult CompleteDelivery(int courierId, int orderId)
    {
        // Потрібна логіка для завершення доставки замовлення
        return Ok();
    }

    [HttpPost("courier/{courierId}/cancel/{orderId}")]
    public IActionResult CancelOrder(int courierId, int orderId)
    {
        // Потрібна логіка для скасування замовлення кур'єром
        return Ok();
    }

    [HttpGet("courier/{courierId}/history")]
    public IActionResult GetCourierHistory(int courierId)
    {
        // Потрібна логіка для отримання історії замовлень кур'єра
        return Ok();
    }

    [HttpPost("courier/{courierId}/location")]
    public IActionResult UpdateCourierLocation(int courierId/*, [FromBody] LocationDto location*/)
    {
        // Потрібна логіка для оновлення місцезнаходження кур'єра
        return Ok();
    }

    [HttpGet("courier/{courierId}/current-order")]
    public IActionResult GetCurrentOrder(int courierId)
    {
        // Потрібна логіка для отримання поточного замовлення кур'єра
        return Ok();
    }
}
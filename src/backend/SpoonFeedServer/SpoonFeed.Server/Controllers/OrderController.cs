using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.Order;

namespace SpoonFeedServer.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrderController : ControllerBase
{
    public OrderController()
    {
        
    }

    [HttpPost]
    [Authorize] // todo: Role = Customer
    public IActionResult CreateOrder([FromBody] CreateOrderDto orderDto)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }
        
    }
    
}
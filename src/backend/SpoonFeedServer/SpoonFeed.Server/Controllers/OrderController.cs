using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.Order;
using SpoonFeed.Application.Interfaces;
using SpoonFeedServer.Extensions;

namespace SpoonFeedServer.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class OrderController : ControllerBase
{
    private readonly IUserContextService _userContextService;
    private IOrderService _orderService;
    
    public OrderController(IUserContextService userContextService, IOrderService orderService)
    {
        _userContextService = userContextService;
        _orderService = orderService;
    }

    [HttpPost]
    [Authorize(Roles = "Customer")] 
    public async Task<IActionResult> CreateOrder([FromBody] CreateOrderDto orderDto, CancellationToken ct)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        Guid userId;

        try
        {
            userId = _userContextService.GetUserId();
        }
        catch (UnauthorizedAccessException ex)
        {
            return Unauthorized("User was not found.");
        }

        var result = await _orderService.CreateOrderAsync(orderDto, userId, ct);

        return result.ToActionResult();
    }
    
}
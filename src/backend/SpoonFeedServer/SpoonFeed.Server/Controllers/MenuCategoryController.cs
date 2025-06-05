using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.Menu;
using SpoonFeed.Application.Interfaces;
using SpoonFeedServer.Extensions;

namespace SpoonFeedServer.Controllers;

[ApiController]
[Route("api/facility/menu-categories")]
public class MenuCategoryController : ControllerBase
{
    private readonly IMenuService _menuService;
    private readonly IUserContextService _userContextService;

    public MenuCategoryController(IMenuService menuService, IUserContextService userContextService)
    {
        _menuService = menuService;
        _userContextService = userContextService;
    }

    [Authorize(Roles = "FoodFacility")]
    [HttpPost("create")]
    public async Task<IActionResult> CreateCategory([FromBody] CreateItemCategoryRequest request, CancellationToken ct = default)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }
        
        var facilityIdRequest = TryGetFacilityId(out var foodFacilityId);
        
        if (facilityIdRequest != null)
        {
            return facilityIdRequest;
        }
        
        var result = await _menuService.CreateMenuItemCategoryAsync(request, foodFacilityId, ct);

        return result.ToActionResult();
    }
    
    
    private IActionResult? TryGetFacilityId(out Guid foodFacilityId)
    {
        try
        {
            foodFacilityId = _userContextService.GetUserId();
            return null;
        }
        catch (UnauthorizedAccessException)
        {
            foodFacilityId = Guid.Empty;
            return Unauthorized("Chain was not found.");
        }
    }
}
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.Menu;
using SpoonFeed.Application.Interfaces;
using SpoonFeedServer.Extensions;

namespace SpoonFeedServer.Controllers;

[ApiController]
[Route("api/facility/menu")]
[Authorize]
public class MenuController : ControllerBase
{
    private readonly IMenuService _menuService;
    private readonly IUserContextService _userContextService;

    public MenuController(IMenuService menuService, IUserContextService userContextService)
    {
        _menuService = menuService;
        _userContextService = userContextService;
    }

    /// <summary>
    /// Gets a single menu item by ID.
    /// </summary>
    [Authorize(Roles = "FoodFacility")]
    [HttpGet("get/{id:guid}")]
    [ProducesResponseType(typeof(MenuItemResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(Guid id, CancellationToken ct = default)
    {
        var facilityIdResult = TryGetFacilityId(out var facilityId);
        
        if (facilityIdResult != null)
        {
            return facilityIdResult;
        }
        
        var result = await _menuService.GetByIdAsync(id, facilityId, ct);
        return result.ToActionResult();
    }


    /// <summary>
    /// Gets all menu items for a specific food facility.
    /// </summary>
    [Authorize(Roles = "FoodFacility")]
    [HttpGet("get/all")]
    [ProducesResponseType(typeof(IEnumerable<MenuItemResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetByFoodFacility(CancellationToken ct = default)
    {
        var facilityIdResult = TryGetFacilityId(out var facilityId);
        
        if (facilityIdResult != null)
        {
            return facilityIdResult;
        }
        
        var result = await _menuService.GetByFacilityAsync(facilityId, ct);
        return result.ToActionResult();
    }

    /// <summary>
    /// Creates a new menu item.
    /// </summary>
    [Authorize(Roles = "FoodFacility")]
    [HttpPost("add")]
    [ProducesResponseType(typeof(Guid), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create([FromBody] MenuItemCreateRequest request, CancellationToken ct = default)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }
        
        var facilityIdResult = TryGetFacilityId(out var facilityId);
        
        if (facilityIdResult != null)
        {
            return facilityIdResult;
        }
        
        var result = await _menuService.CreateAsync(facilityId, request, ct);
        return result.ToActionResult();
    }

    /// <summary>
    /// Updates an existing menu item.
    /// </summary>
    [Authorize(Roles = "FoodFacility")]
    [HttpPut("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(Guid id, [FromBody] MenuItemUpdateRequest request,
        CancellationToken ct = default)
    {
        if (id != request.Id)
        {
            return BadRequest("Mismatched ID in URL and body.");
        }
        
        var facilityIdResult = TryGetFacilityId(out var facilityId);
        
        if (facilityIdResult != null)
        {
            return facilityIdResult;
        }

        
        var result = await _menuService.UpdateAsync(facilityId, request, ct);
        return result.ToActionResult();

        throw new NotImplementedException();
    }

    /// <summary>
    /// Deletes a menu item.
    /// </summary>
    [Authorize(Roles = "FoodFacility")]
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id, CancellationToken ct = default)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }
        
        var facilityIdResult = TryGetFacilityId(out var facilityId);
        
        if (facilityIdResult != null)
        {
            return facilityIdResult;
        }
        
        var result = await _menuService.DeleteAsync(facilityId, id, ct);
        
        return result.ToActionResult();
    }
    
    private IActionResult? TryGetFacilityId(out Guid customerId)
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
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.Menu;
using SpoonFeed.Application.Interfaces;
using SpoonFeedServer.Extensions;

namespace SpoonFeedServer.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class MenuController : ControllerBase
{
    private readonly IMenuService _menuService;

    public MenuController(IMenuService menuService)
    {
        _menuService = menuService;
    }

    /// <summary>
    /// Gets a single menu item by ID.
    /// </summary>
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(MenuItemResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(Guid id)
    {
        var result = await _menuService.GetByIdAsync(id);
        return result.ToActionResult();
    }

    /// <summary>
    /// Gets all menu items for a specific food facility.
    /// </summary>
    [HttpGet("facility/{foodFacilityId:guid}")]
    [ProducesResponseType(typeof(IEnumerable<MenuItemResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetByFoodFacility(Guid foodFacilityId)
    {
        var result = await _menuService.GetByFacilityAsync(foodFacilityId);
        return result.ToActionResult();
    }

    /// <summary>
    /// Creates a new menu item.
    /// </summary>
    [HttpPost]
    [ProducesResponseType(typeof(Guid), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create([FromBody] MenuItemCreateRequest request)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);
        var result = await _menuService.CreateAsync(request);
        return result.ToActionResult();
    }

    /// <summary>
    /// Updates an existing menu item.
    /// </summary>
    [HttpPut("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(Guid id, [FromBody] MenuItemUpdateRequest request)
    {
        if (id != request.Id)
            return BadRequest("Mismatched ID in URL and body.");

        var result = await _menuService.UpdateAsync(request);

        return result.ToActionResult();
    }

    /// <summary>
    /// Deletes a menu item.
    /// </summary>
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(Guid id)
    {
        var result = await _menuService.DeleteAsync(id);
        return result.ToActionResult();
    }
}
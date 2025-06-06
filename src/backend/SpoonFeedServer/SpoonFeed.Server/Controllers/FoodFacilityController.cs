using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.FoodFacility;
using SpoonFeed.Application.Interfaces;
using SpoonFeedServer.Extensions;

namespace SpoonFeedServer.Controllers;

[ApiController]
[Route("api/facility")]
[Authorize(Roles = "FoodFacility")]
public class FoodFacilityController : ControllerBase
{
    private IFoodFacilityService _facilityService;
    private readonly IUserContextService _userContextService;
    public FoodFacilityController(IFoodFacilityService facilityService, IUserContextService userContextService)
    {
        _facilityService = facilityService;
        _userContextService = userContextService;
    }
    
    [HttpPost]
    public async Task<IActionResult> SetOrderPositionsAsReady(/*List with order positions*/)
    {
        throw new NotImplementedException();
    }
    
    [HttpGet]
    public async Task<IActionResult> GetPendingPositions()
    {
        throw new NotImplementedException();
    }

    [HttpPost("confirm-pickup/{orderId}")]
    public async Task<IActionResult> ConfirmPickup(
        [FromRoute] Guid orderId,
        [FromBody] IList<Guid> orderPositions,
        CancellationToken ct
        )
    {
        var facilityIdRequest = TryGetFacilityId(out var foodFacilityId);
        
        if (facilityIdRequest != null)
        {
            return facilityIdRequest;
        }

        var result = await _facilityService
            .ConfirmPickupAsync(foodFacilityId, orderId, orderPositions, ct);

        return result.ToActionResult();
    }

    [HttpGet("info/get")]
    [Authorize]
    public async Task<IActionResult> GetFacilityInfo()
    {
        var facilityIdRequest = TryGetFacilityId(out var foodFacilityId);
        
        if (facilityIdRequest != null)
        {
            return facilityIdRequest;
        }

        var result = await _facilityService.GetFacilityInfoAsync(foodFacilityId);

        return result.ToActionResult();
    }
    
    [HttpPut("info/update")]
    [Authorize]
    public async Task<IActionResult> UpdateFacilityInfo([FromBody] UpdateFoodFacilityInfoRequest request)
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

        var result = await _facilityService.UpdateFacilityInfoAsync(foodFacilityId, request);

        return result.ToActionResult();
    }
    
    [HttpPut("working-hours/update")]
    [Authorize]
    public async Task<IActionResult> UpdateWorkingHours([FromBody] FacilityWorkingHoursUpdateDto dto)
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

        var result = await _facilityService.UpdateWorkingHoursAsync(foodFacilityId, dto);

        return result.ToActionResult();
    }
    
    [HttpGet("working-hours/get")]
    [Authorize]
    public async Task<IActionResult> GetWorkingHours()
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

        var result = await _facilityService.GetWorkingHoursAsync(foodFacilityId);

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
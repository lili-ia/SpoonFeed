using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.Interfaces;
using SpoonFeedServer.Extensions;

namespace SpoonFeedServer.Controllers;

[ApiController]
[Route("api/food-facility")]
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
        Guid facilityId;

        try
        {
            facilityId = _userContextService.GetUserId();
        }
        catch (UnauthorizedAccessException ex)
        {
            return Unauthorized("User was not found.");
        }

        var result = await _facilityService
            .ConfirmPickupAsync(facilityId, orderId, orderPositions, ct);

        return result.ToActionResult();
    }
}
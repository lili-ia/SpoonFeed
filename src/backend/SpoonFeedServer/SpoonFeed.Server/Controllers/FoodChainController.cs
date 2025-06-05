using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.Auth;
using SpoonFeed.Application.Interfaces;
using SpoonFeedServer.Extensions;

namespace SpoonFeedServer.Controllers;

[ApiController]
[Route("api/food-chain")]
public class FoodChainController : ControllerBase
{
    private readonly IAuthService _authService;
    private readonly IUserContextService _userContextService;
    
    public FoodChainController(IAuthService authService, IUserContextService userContextService)
    {
        _authService = authService;
        _userContextService = userContextService;
    }

    [HttpPost("register-food-facility")]
    [Authorize(Roles = "FoodChain")]
    public async Task<IActionResult> RegisterFoodFacility([FromBody] FoodFacilityRegisterRequest request, CancellationToken ct = default)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }
        
        var chainIdRequest = TryGetChainId(out var chainId);
        
        if (chainIdRequest != null)
        {
            return chainIdRequest;
        }

        var result = await _authService.RegisterFoodFacilityAsync(chainId, request, ct);

        return result.ToActionResult();
    }
    
    private IActionResult? TryGetChainId(out Guid chainId)
    {
        try
        {
            chainId = _userContextService.GetUserId();
            return null;
        }
        catch (UnauthorizedAccessException)
        {
            chainId = Guid.Empty;
            return Unauthorized("Chain was not found.");
        }
    }
}
using Microsoft.AspNetCore.Mvc;

namespace SpoonFeedServer.Controllers;

[ApiController]
[Route("api/food-facility")]
public class FoodFacilityController
{
    public FoodFacilityController()
    {
        
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
}
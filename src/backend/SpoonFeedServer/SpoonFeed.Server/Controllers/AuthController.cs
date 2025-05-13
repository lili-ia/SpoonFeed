using Microsoft.AspNetCore.Mvc;

namespace SpoonFeedServer.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AuthController : ControllerBase
{
    public AuthController()
    {
        
    }
    
    [HttpPost("register")]
    public async Task<IActionResult> Register()
    {
        return Ok();
    }
    
    [HttpPost("login")]
    public async Task<IActionResult> Login()
    {
        return Ok();
    }

    [HttpPost("refresh-token")]
    public async Task<IActionResult> RefreshToken()
    {
        return Ok();
    }
}
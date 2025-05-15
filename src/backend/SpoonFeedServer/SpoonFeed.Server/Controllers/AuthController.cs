using Microsoft.AspNetCore.Mvc;
using SpoonFeed.Application.DTOs.Auth;
using SpoonFeed.Application.Interfaces;
using SpoonFeedServer.Extensions;

namespace SpoonFeedServer.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;
    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }
    
    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterUserRequest request, CancellationToken ct)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var result = await _authService.RegisterAsync(request, ct);

        return result.ToActionResult();
    }
    
    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequest request, CancellationToken ct)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }
        
        var result = await _authService.LoginAsync(request, ct);
        
        return result.ToActionResult();
    }

    [HttpPost("refresh-token")]
    public async Task<IActionResult> RefreshToken()
    {
        // todo
        throw new NotImplementedException();
    }
}
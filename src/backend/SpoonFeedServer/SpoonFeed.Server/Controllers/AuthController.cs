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
    
    /// <summary>
    /// Registers a new general user with the given credentials and role.
    /// </summary>
    /// <param name="request">The registration request containing general user details such as email, password, and role.</param>
    /// <param name="ct">Optional cancellation token to cancel the operation.</param>
    /// <returns>
    /// Returns a JWT token on successful registration (<see cref="AuthResponse"/>).
    /// Possible HTTP responses:
    /// <list type="bullet">
    /// <item><description><c>200 OK</c> – Registration succeeded and token returned.</description></item>
    /// <item><description><c>400 Bad Request</c> – Invalid input data.</description></item>
    /// <item><description><c>401 Unauthorized</c> – Authentication error (not typical for registration).</description></item>
    /// <item><description><c>404 Not Found</c> – Related resource not found (rare for register).</description></item>
    /// <item><description><c>409 Conflict</c> – A user with the provided email already exists.</description></item>
    /// <item><description><c>500 Internal Server Error</c> – Unexpected error occurred during registration.</description></item>
    /// </list>
    /// </returns>
    [HttpPost("register")]
    [ProducesResponseType(typeof(AuthResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> RegisterUserIdentity([FromBody] RegisterUserRequest request, CancellationToken ct = default)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var result = await _authService.RegisterUserIdentityAsync(request, ct);

        return result.ToActionResult();
    }
    
    /// <summary>
    /// Authenticates a user with the provided email and password credentials.
    /// </summary>
    /// <param name="request">The login request containing the user's email and password.</param>
    /// <param name="ct">Optional cancellation token to cancel the operation.</param>
    /// <returns>
    /// Returns a JWT token on successful login (<see cref="AuthResponse"/>).
    /// Possible HTTP responses:
    /// <list type="bullet">
    /// <item><description><c>200 OK</c> – Login succeeded and token returned.</description></item>
    /// <item><description><c>400 Bad Request</c> – Invalid request data.</description></item>
    /// <item><description><c>401 Unauthorized</c> – Password is incorrect.</description></item>
    /// <item><description><c>404 Not Found</c> – User with the provided email does not exist.</description></item>
    /// <item><description><c>500 Internal Server Error</c> – Unexpected server error.</description></item>
    /// </list>
    /// </returns>
    [HttpPost("login")]
    [ProducesResponseType(typeof(AuthResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Login([FromBody] LoginRequest request, CancellationToken ct = default)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }
        
        var result = await _authService.LoginAsync(request, ct);
        
        return result.ToActionResult();
    }
    
}
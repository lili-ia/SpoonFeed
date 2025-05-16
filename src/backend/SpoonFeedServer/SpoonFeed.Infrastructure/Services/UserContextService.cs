using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using SpoonFeed.Application.Interfaces;

namespace SpoonFeed.Infrastructure.Services;

public class UserContextService : IUserContextService
{
    private readonly IHttpContextAccessor _httpContextAccessor;
    
    public UserContextService(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }
    
    public Guid GetUserId()
    {
        var userIdString = _httpContextAccessor.HttpContext?.User
            .FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (userIdString == null)
        {
            throw new UnauthorizedAccessException("User Id was not found.");
        }

        if (!Guid.TryParse(userIdString, out Guid userIdGuid))
        {
            throw new UnauthorizedAccessException("User Id was not found.");
        }

        return userIdGuid;
    }

    public string GetUserEmail()
    {
        var userEmail = _httpContextAccessor.HttpContext?.User
            .FindFirst(ClaimTypes.Email)?.Value;

        if (userEmail == null)
        {
            throw new UnauthorizedAccessException("Email was not found.");
        }

        return userEmail;
    }

    public string? GetUserRole()
    {
        var userRole = _httpContextAccessor.HttpContext?.User
            .FindFirst(ClaimTypes.Role)?.Value;

        if (userRole == null)
        {
            throw new UnauthorizedAccessException("User role was not recognised.");
        }

        return userRole;
    }
}
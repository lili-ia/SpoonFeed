using SpoonFeed.Application.DTOs.Auth;
using SpoonFeed.Domain.Models;

namespace SpoonFeed.Application.Interfaces;

public interface IAuthService
{
    Task<Result<AuthResponse>> LoginAsync(LoginRequest request, CancellationToken ct);
    
    Task<Result<AuthResponse>> RegisterAsync(RegisterUserRequest request, CancellationToken ct);
}
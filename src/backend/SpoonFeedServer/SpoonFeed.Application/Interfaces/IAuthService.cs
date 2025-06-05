using SpoonFeed.Application.DTOs.Auth;
using SpoonFeed.Domain.Models;

namespace SpoonFeed.Application.Interfaces;

public interface IAuthService
{
    Task<Result<AuthResponse>> LoginAsync(LoginRequest request, CancellationToken ct);
    
    Task<Result<AuthResponse>> RegisterUserIdentityAsync(RegisterUserRequest request, CancellationToken ct);
    
    Task<Result<FoodFacilityRegisterResponse>> RegisterFoodFacilityAsync(Guid foodChainId, FoodFacilityRegisterRequest request, CancellationToken ct);
}
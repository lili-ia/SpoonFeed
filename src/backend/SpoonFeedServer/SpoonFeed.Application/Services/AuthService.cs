using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SpoonFeed.Application.DTOs.Auth;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Domain.Models;
using SpoonFeed.Persistence;

namespace SpoonFeed.Application.Services;

public class AuthService : IAuthService
{
    private readonly SpoonFeedDbContext _db;
    private readonly ILogger<AuthService> _logger;
    private readonly IPasswordService _passwordService;
    private readonly IJwtService _jwtService;
    
    public AuthService(
        SpoonFeedDbContext db, 
        ILogger<AuthService> logger, 
        IPasswordService passwordService, 
        IJwtService jwtService)
    {
        _db = db;
        _logger = logger;
        _passwordService = passwordService;
        _jwtService = jwtService;
    }
    
    // todo: implement refresh tokens
    public async Task<Result<AuthResponse>> LoginAsync(LoginRequest request, CancellationToken ct)
    {
        var user = await _db.UserIdentities
            .FirstOrDefaultAsync(x => x.Email == request.Email, ct);

        if (user == null)
        {
            return Result<AuthResponse>.FailureResult(
                $"User with email {request.Email} does not exist.", ErrorType.NotFound);
        }

        var isPasswordValid = _passwordService.VerifyPassword(user.PasswordHash, request.Password);

        if (!isPasswordValid)
        {
            return Result<AuthResponse>.FailureResult("Invalid login attempt.", ErrorType.Forbidden);
        }
        
        Role? role = null;

        if (await _db.Customers.AnyAsync(c => c.UserIdentityId == user.Id, ct))
            role = Role.Customer;
        else if (await _db.Couriers.AnyAsync(c => c.UserIdentityId == user.Id, ct))
            role = Role.Courier;
        else if (await _db.FoodChains.AnyAsync(f => f.UserIdentityId == user.Id, ct))
            role = Role.FoodChain;
        else if (await _db.FoodFacilities.AnyAsync(f => f.UserIdentityId == user.Id, ct))
            role = Role.FoodFacility;
        
        if (role == null)
            return Result<AuthResponse>.FailureResult("User role is not assigned.", ErrorType.Validation);

        try
        {
            var accessToken = _jwtService.GenerateJwtToken(
                user.Id.ToString(), user.Email, role.ToString());

            return Result<AuthResponse>.SuccessResult(new AuthResponse(accessToken));
        }
        catch (Exception e)
        {
            _logger.LogError(e.Message);
            
            return Result<AuthResponse>.FailureResult("An internal error occured", ErrorType.ServerError);
        }
    }

    public async Task<Result<AuthResponse>> RegisterAsync(RegisterUserRequest request, CancellationToken ct)
    {
        var userExists = await _db.UserIdentities
            .AnyAsync(u => u.Email == request.Email, cancellationToken: ct);

        if (userExists)
        {
            return Result<AuthResponse>.FailureResult($"User with email {request.Email} already exists.", ErrorType.Forbidden);
        }

        var newUser = new UserIdentity
        {
            Id = Guid.NewGuid(),
            Email = request.Email,
            FirstName = request.FirstName,
            LastName = request.LastName,
            PasswordHash = _passwordService.HashPassword(request.Password),
            PhoneNumber = request.PhoneNumber
        };

        try
        {
            using var tx = await _db.Database.BeginTransactionAsync(ct);
            
            await _db.UserIdentities.AddAsync(newUser, ct);

            switch (request.UserType)
            {
                case Role.Courier:
                {
                    await _db.Couriers.AddAsync(new Courier
                    {
                        UserIdentityId = newUser.Id
                    }, ct);
                    break;
                }
                case Role.Customer:
                {
                    await _db.Customers.AddAsync(new Customer
                    {
                        UserIdentityId = newUser.Id
                    }, ct);
                    break;
                }
                case Role.FoodChain:
                {
                    await _db.FoodChains.AddAsync(new FoodChain
                    {
                        UserIdentityId = newUser.Id
                    }, ct);
                    break;
                }
                case Role.FoodFacility:
                {
                    await _db.FoodFacilities.AddAsync(new FoodFacility
                    {
                        UserIdentityId = newUser.Id
                    }, ct);
                    break;
                }
            }
            
            await _db.SaveChangesAsync(ct);
            await tx.CommitAsync(ct);
            
            var token = _jwtService.GenerateJwtToken(
                newUser.Id.ToString(),
                newUser.Email,
                request.UserType.ToString());

            return Result<AuthResponse>.SuccessResult(new AuthResponse(token));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, ex.Message);
            
            return Result<AuthResponse>.FailureResult(
                "Internal error occured while trying to register a user. Please, try later", ErrorType.ServerError);
        }
    }
}
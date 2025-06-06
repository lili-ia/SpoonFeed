using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SpoonFeed.Application.DTOs.Auth;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Domain.Models;
using SpoonFeed.Domain.Owned;
using SpoonFeed.Persistence;

namespace SpoonFeed.Application.Services;

public class AuthService : IAuthService
{
    private readonly SpoonFeedDbContext _db;
    private readonly ILogger<AuthService> _logger;
    private readonly IPasswordService _passwordService;
    private readonly IJwtService _jwtService;
    private readonly IMapper _mapper;
    
    public AuthService(
        SpoonFeedDbContext db, 
        ILogger<AuthService> logger, 
        IPasswordService passwordService, 
        IJwtService jwtService, 
        IMapper mapper)
    {
        _db = db;
        _logger = logger;
        _passwordService = passwordService;
        _jwtService = jwtService;
        _mapper = mapper;
    }
    
    /// <summary>
    /// Attempts to authenticate a user with the provided login credentials.
    /// </summary>
    /// <param name="request">The login request containing the user's email and password.</param>
    /// <param name="ct">The cancellation token to cancel the operation.</param>
    /// <returns>
    /// A <see cref="Result{T}"/> containing an <see cref="AuthResponse"/> on success, 
    /// or an appropriate error result if authentication fails due to incorrect credentials, 
    /// missing user, unassigned role, or server error.
    /// </returns>
    public async Task<Result<AuthResponse>> LoginAsync(LoginRequest request, CancellationToken ct)
    {
        _logger.LogInformation("Login attempt for {Email}", request.Email);
        
        var user = await _db.UserIdentities
            .FirstOrDefaultAsync(x => x.Email == request.Email, ct);

        if (user == null)
        {
            _logger.LogWarning("Login failed for {Email}: user not found", request.Email);
            return Result<AuthResponse>.FailureResult(
                $"User with email {request.Email} does not exist.", ErrorType.NotFound);
        }

        var isPasswordValid = _passwordService.VerifyPassword(user.PasswordHash, request.Password);

        if (!isPasswordValid)
        {
            _logger.LogWarning("Login failed for {Email}: invalid password", request.Email);
            
            return Result<AuthResponse>.FailureResult("Invalid login attempt.", ErrorType.Unauthorized);
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
        {
            _logger.LogWarning("Login failed for {Email}: role not assigned", request.Email);
            
            return Result<AuthResponse>.FailureResult("User role is not assigned.", ErrorType.Validation);
        }

        try
        {
            var accessToken = _jwtService.GenerateJwtToken(
                user.Id.ToString(), user.Email, role.ToString());

            _logger.LogInformation("Login succeeded for {Email} with role {Role}", request.Email, role);
            
            return Result<AuthResponse>.SuccessResult(new AuthResponse(accessToken));
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Internal error during login for {Email}", request.Email);
            
            return Result<AuthResponse>.FailureResult("An internal error occured", ErrorType.ServerError);
        }
    }

    /// <summary>
    /// Registers a new user identity with the specified credentials and user type.
    /// </summary>
    /// <param name="request">The registration request containing basic user information and desired role.</param>
    /// <param name="ct">A cancellation token to cancel the operation.</param>
    /// <returns>
    /// A <see cref="Result{T}"/> containing an <see cref="AuthResponse"/> with a JWT access token on success, 
    /// or an appropriate error result if the user already exists, registration fails, or a server error occurs.
    /// </returns>
    public async Task<Result<AuthResponse>> RegisterUserIdentityAsync(RegisterUserRequest request, CancellationToken ct)
    {
        _logger.LogInformation("Registration attempt for {Email} as {Role}", request.Email, request.UserType);
        
        var userExists = await _db.UserIdentities
            .AnyAsync(u => u.Email == request.Email, cancellationToken: ct);

        if (userExists)
        {
            _logger.LogWarning("Registration failed for {Email}: user already exists", request.Email);
            return Result<AuthResponse>.FailureResult($"User with email {request.Email} already exists.", ErrorType.Conflict);
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
                    await _db.Couriers.AddAsync(new Courier { UserIdentityId = newUser.Id }, ct);
                    break;
                case Role.Customer:
                    await _db.Customers.AddAsync(new Customer { UserIdentityId = newUser.Id }, ct);
                    break;
                case Role.FoodChain:
                    await _db.FoodChains.AddAsync(new FoodChain
                    {
                        UserIdentityId = newUser.Id,
                        Status = FoodChainStatus.PendingApproval
                    }, ct);
                    break;
            }
            
            await _db.SaveChangesAsync(ct);
            await tx.CommitAsync(ct);
            
            var token = _jwtService.GenerateJwtToken(
                newUser.Id.ToString(),
                newUser.Email,
                request.UserType.ToString());

            _logger.LogInformation("Registration succeeded for {Email} as {Role}", request.Email, request.UserType);
            return Result<AuthResponse>.SuccessResult(new AuthResponse(token));
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Internal error during registration for {Email}", request.Email);
            
            return Result<AuthResponse>.FailureResult(
                "Internal error occured while trying to register a user. Please, try later", ErrorType.ServerError);
        }
    }

    public async Task<Result<FoodFacilityRegisterResponse>> RegisterFoodFacilityAsync(Guid foodChainId, FoodFacilityRegisterRequest request, CancellationToken ct)
    {
        _logger.LogInformation("Food facility registration attempt for chain {ChainId} with email {Email}", foodChainId, request.Email);
        
        var foodChain = await _db.FoodChains
            .FirstOrDefaultAsync(fc => fc.UserIdentityId == foodChainId, cancellationToken: ct);

        if (foodChain == null)
        {
            _logger.LogWarning("Food facility registration failed: food chain {ChainId} not found", foodChainId);
            return Result<FoodFacilityRegisterResponse>.FailureResult("Food chain not found", ErrorType.NotFound);
        }

        if (foodChain.Status != FoodChainStatus.Private && foodChain.Status != FoodChainStatus.Public)
        {
            _logger.LogWarning("Food facility registration failed: chain {ChainId} has status {Status}", foodChainId, foodChain.Status);
            return Result<FoodFacilityRegisterResponse>.FailureResult("You are not allowed to create a food facility", ErrorType.Forbidden);
        }

        var password = Guid.NewGuid().ToString().Substring(0, 8);
        
        var foodFacilityIdentity = new UserIdentity
        {
            Id = Guid.NewGuid(),
            Email = request.Email,
            FirstName = request.FirstName,
            LastName = request.LastName,
            PasswordHash = _passwordService.HashPassword(password),
            PhoneNumber = request.PhoneNumber
        };
        
        var foodFacility = new FoodFacility
        {
            UserIdentityId = foodFacilityIdentity.Id,
            Address = _mapper.Map<Address>(request.AddressDto),
            Name = request.Name,
            FoodChainId = foodChainId 
        };

        try
        {
            using var tx = await _db.Database.BeginTransactionAsync(ct);

            await _db.UserIdentities.AddAsync(foodFacilityIdentity, ct);
            await _db.FoodFacilities.AddAsync(foodFacility, ct);
            await _db.SaveChangesAsync(ct);

            await tx.CommitAsync(ct);

            var response = new FoodFacilityRegisterResponse
            {
                Password = password
            };

            _logger.LogInformation("Food facility {FacilityName} successfully registered under chain {ChainId}", request.Name, foodChainId);
            return Result<FoodFacilityRegisterResponse>.SuccessResult(response);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Internal error during food facility registration for email {Email}", request.Email);
            
            return Result<FoodFacilityRegisterResponse>.FailureResult(
                "Internal error occured while trying to register a food facility. Please, try later", ErrorType.ServerError);
        }
    }
}

using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Persistence;

namespace SpoonFeed.Application.Services;

public class CourierService : ICourierService
{
    private readonly SpoonFeedDbContext _db;
    private readonly ILogger<CourierService> _logger;

    public CourierService(SpoonFeedDbContext db, ILogger<CourierService> logger)
    {
        _db = db;
        _logger = logger;
    }

    public async Task<Result<CourierStatus>> GetCourierStatusAsync(Guid courierId, CancellationToken ct)
    {
        var courier = await _db.Couriers.FirstOrDefaultAsync(c => c.UserIdentityId == courierId, ct);

        if (courier == null)
        {
            return Result<CourierStatus>.FailureResult("Courier with such id was not found", ErrorType.NotFound);
        }

        return Result<CourierStatus>.SuccessResult(courier.CourierStatus);
    }

    public async Task<Result<bool>> SetCourierStatusAsync(Guid courierId, CourierStatus status, CancellationToken ct)
    {
        var courier = await _db.Couriers.FirstOrDefaultAsync(c => c.UserIdentityId == courierId, ct);

        if (courier == null)
        {
            return Result<bool>.FailureResult("Courier with such id was not found", ErrorType.NotFound);
        }

        try
        {
            courier.CourierStatus = status;
            await _db.SaveChangesAsync(ct);

            _logger.LogInformation("Courier {CourierId} status changed to {Status}", courierId, status);

            return Result<bool>.SuccessResult(true);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Failed to set status {Status} for courier {CourierId}", status, courierId);
            return Result<bool>.FailureResult("An internal error occurred", ErrorType.ServerError);
        }
    }
}

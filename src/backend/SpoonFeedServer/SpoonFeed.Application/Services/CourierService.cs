using Microsoft.Extensions.Logging;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Persistence;

namespace SpoonFeed.Application.Services;

public class CourierService : ICourierService
{
    private SpoonFeedDbContext _db;
    private ILogger<CourierService> _logger;
    
    public CourierService(SpoonFeedDbContext db, ILogger<CourierService> logger)
    {
        _db = db;
        _logger = logger;
    }
    
    public async Task<Result<CourierStatus>> GetCourierStatusAsync(Guid courierId, CancellationToken ct)
    {
        var courier = await _db.Couriers.FindAsync(courierId, ct);

        if (courier == null)
        {
            return Result<CourierStatus>.FailureResult("Courier with such id was not found", ErrorType.NotFound);
        }

        return Result<CourierStatus>.SuccessResult(courier.CourierStatus);
    }

    public async Task<Result<bool>> SetCourierStatusAsync(Guid courierId, CourierStatus status, CancellationToken ct)
    {
        var courier = await _db.Couriers.FindAsync(courierId, ct);
        
        if (courier == null)
        {
            return Result<bool>.FailureResult("Courier with such id was not found", ErrorType.NotFound);
        }

        try
        {
            courier.CourierStatus = status;
            _db.Couriers.Update(courier);
            await _db.SaveChangesAsync();
            
            return Result<bool>.SuccessResult(true);
        }
        catch (Exception e)
        {
            _logger.LogError(e.Message);
            
            return Result<bool>.FailureResult("An internal error occured", ErrorType.ServerError);
        }
    }
}
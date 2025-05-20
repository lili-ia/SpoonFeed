using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SpoonFeed.Application.DTOs.Order;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Persistence;

namespace SpoonFeed.Application.Services;

public class FoodFacilityService : IFoodFacilityService
{
    private readonly SpoonFeedDbContext _db;
    private ILogger<FoodFacilityService> _logger;
    
    public FoodFacilityService(SpoonFeedDbContext db, ILogger<FoodFacilityService> logger)
    {
        _db = db;
        _logger = logger;
    }
    
    public async Task<Result<bool>> ConfirmPickupAsync(
        Guid facilityId, 
        Guid orderId, 
        IList<Guid> orderPositionsIds,
        CancellationToken ct)
    {
        var positions = await _db.OrderPositions
            .Where(op => op.OrderId == orderId
                         && orderPositionsIds.Contains(op.Id)
                         && op.MenuItem.FoodFacilityId == facilityId)
            .ToListAsync(ct);

        if (positions.Count == 0)
        {
            return Result<bool>.FailureResult("No matching positions found", ErrorType.NotFound);
        }

        foreach (var op in positions)
        {
            op.PickupStatus = OrderPositionPickupStatus.PickedUp;
        }

        try
        {
            _db.OrderPositions.UpdateRange(positions);
            await _db.SaveChangesAsync(ct);
        }
        catch (Exception e)
        {
            _logger.LogError(e.Message);
            
            return Result<bool>.FailureResult("An internal error occured", ErrorType.ServerError);
        }
        
        return Result<bool>.SuccessResult(true);
    }
}
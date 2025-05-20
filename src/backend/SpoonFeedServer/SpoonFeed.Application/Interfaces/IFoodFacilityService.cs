using SpoonFeed.Application.DTOs.Order;

namespace SpoonFeed.Application.Interfaces;

public interface IFoodFacilityService
{
    Task<Result<bool>> ConfirmPickupAsync(
        Guid facilityId, 
        Guid orderId, 
        IList<Guid> orderPositionsIds,
        CancellationToken ct);
}
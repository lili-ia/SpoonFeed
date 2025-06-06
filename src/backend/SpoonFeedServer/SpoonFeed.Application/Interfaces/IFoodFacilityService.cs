using SpoonFeed.Application.DTOs.FoodFacility;
using SpoonFeed.Domain.Models;

namespace SpoonFeed.Application.Interfaces;

public interface IFoodFacilityService
{
    Task<Result<bool>> ConfirmPickupAsync(
        Guid facilityId, 
        Guid orderId, 
        IList<Guid> orderPositionsIds,
        CancellationToken ct);

    Task<Result<GetFoodFacilityInfoResponse>> GetFacilityInfoAsync(Guid facilityId);
    
    Task<Result<bool>> UpdateFacilityInfoAsync(Guid facilityId, UpdateFoodFacilityInfoRequest request);

    Task<Result<bool>> UpdateWorkingHoursAsync(Guid facilityId, FacilityWorkingHoursUpdateDto dto);

    Task<Result<List<FacilityWorkingHoursGetDto>>> GetWorkingHoursAsync(Guid facilityId);
}
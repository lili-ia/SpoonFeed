using SpoonFeed.Application.DTOs.Menu;

namespace SpoonFeed.Application.Interfaces;

public interface IMenuService
{
    Task<Result<MenuItemResponse>> GetByIdAsync(Guid itemId, Guid facilityId, CancellationToken ct);
    
    Task<Result<IEnumerable<MenuItemResponse>>> GetByFacilityAsync(Guid foodFacilityId, CancellationToken ct);
    
    Task<Result<Guid>> CreateAsync(Guid foodFacilityId, MenuItemCreateRequest request, CancellationToken ct);
    
    Task<Result<bool>> UpdateAsync(Guid foodFacilityId, MenuItemUpdateRequest request, CancellationToken ct);
    
    Task<Result<bool>> DeleteAsync(Guid foodFacilityId, Guid itemId, CancellationToken ct);
    
    Task<Result<bool>> ExistsAsync(Guid itemId, CancellationToken ct);

    Task<Result<bool>> CreateMenuItemCategoryAsync(CreateItemCategoryRequest request, Guid foodFacilityId, CancellationToken ct);
}
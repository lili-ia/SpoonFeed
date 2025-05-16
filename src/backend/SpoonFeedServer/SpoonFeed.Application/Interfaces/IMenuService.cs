using SpoonFeed.Application.DTOs.Menu;

namespace SpoonFeed.Application.Interfaces;

public interface IMenuService
{
    Task<Result<MenuItemResponse>> GetByIdAsync(Guid id);
    Task<Result<IEnumerable<MenuItemResponse>>> GetByFacilityAsync(Guid foodFacilityId);
    Task<Result<Guid>> CreateAsync(MenuItemCreateRequest request);
    Task<Result<bool>> UpdateAsync(MenuItemUpdateRequest request);
    Task<Result<bool>> DeleteAsync(Guid id);
    Task<Result<bool>> ExistsAsync(Guid id);
}
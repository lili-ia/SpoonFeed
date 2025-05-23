using SpoonFeed.Application.DTOs.Menu;

namespace SpoonFeed.Application.Interfaces;

public interface IMenuService
{
    Task<Result<MenuItemResponse>> GetByIdAsync(Guid id, CancellationToken ct);
    Task<Result<IEnumerable<MenuItemResponse>>> GetByFacilityAsync(Guid foodFacilityId, CancellationToken ct);
    Task<Result<Guid>> CreateAsync(MenuItemCreateRequest request, CancellationToken ct);
    Task<Result<bool>> UpdateAsync(MenuItemUpdateRequest request, CancellationToken ct);
    Task<Result<bool>> DeleteAsync(Guid id, CancellationToken ct);
    Task<Result<bool>> ExistsAsync(Guid id, CancellationToken ct);
}
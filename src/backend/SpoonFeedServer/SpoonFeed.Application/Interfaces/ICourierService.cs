using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.Interfaces;

public interface ICourierService
{
    Task<Result<CourierStatus>> GetCourierStatusAsync(Guid courierId, CancellationToken ct);

    Task<Result<bool>> SetCourierStatusAsync(Guid courierId, CourierStatus status, CancellationToken ct);
}
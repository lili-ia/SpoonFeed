using SpoonFeed.Domain.Models;

namespace SpoonFeed.Application.Interfaces;

public interface ICourierSelector
{
    Task<Courier?> FindBestCourierAsync(
        Order order, 
        CancellationToken ct, 
        IEnumerable<Guid> excludedCourierIds);
}
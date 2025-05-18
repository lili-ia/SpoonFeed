namespace SpoonFeed.Application.Interfaces;

public interface IOrderQueue
{
    Task EnqueueAsync(Guid orderId, CancellationToken ct);

    Task<Guid> DequeueAsync(CancellationToken ct);
}
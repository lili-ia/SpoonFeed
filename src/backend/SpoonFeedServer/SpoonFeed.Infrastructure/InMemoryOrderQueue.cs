using System.Threading.Channels;
using SpoonFeed.Application.Interfaces;

namespace SpoonFeed.Infrastructure;

public class InMemoryOrderQueue : IOrderQueue
{
    private readonly Channel<Guid> _channel;

    public InMemoryOrderQueue()
    {
        _channel = Channel.CreateUnbounded<Guid>();
    }

    public async Task EnqueueAsync(Guid orderId, CancellationToken ct)
    {
        await _channel.Writer.WriteAsync(orderId, ct);
    }

    public async Task<Guid> DequeueAsync(CancellationToken ct)
    {
        return await _channel.Reader.ReadAsync(ct);
    }
}
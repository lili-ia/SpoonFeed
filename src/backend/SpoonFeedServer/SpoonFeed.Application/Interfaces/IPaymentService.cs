namespace SpoonFeed.Application.Interfaces;

public interface IPaymentService
{
    Task<Result<bool>> ConfirmPaymentAsync(Guid orderId, CancellationToken ct);
}
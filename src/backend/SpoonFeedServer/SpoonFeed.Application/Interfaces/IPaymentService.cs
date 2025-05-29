namespace SpoonFeed.Application.Interfaces;

public interface IPaymentService
{
    Task<string> CreatePaymentIntentAsync(decimal amount, string currency, CancellationToken ct);
    
    Task<bool> ConfirmPaymentAsync(string paymentIntentId, CancellationToken ct);
}
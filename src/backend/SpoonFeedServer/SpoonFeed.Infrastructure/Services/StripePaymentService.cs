using Microsoft.Extensions.Configuration;
using SpoonFeed.Application.Interfaces;
using Stripe;

namespace SpoonFeed.Infrastructure.Services;

public class StripePaymentService : IPaymentService
{
    public StripePaymentService(IConfiguration configuration)
    {
        StripeConfiguration.ApiKey = configuration["Stripe:SecretKey"];
    }

    public async Task<string> CreatePaymentIntentAsync(decimal amount, string currency, CancellationToken ct)
    {
        var service = new PaymentIntentService();
        var options = new PaymentIntentCreateOptions
        {
            Amount = (long)(amount * 100),
            Currency = currency,
            PaymentMethodTypes = ["card"]
        };

        var paymentIntent = await service.CreateAsync(options, cancellationToken: ct);

        return paymentIntent.ClientSecret;
    }

    public async Task<bool> ConfirmPaymentAsync(string paymentIntentId, CancellationToken ct)
    {
        var service = new PaymentIntentService();
        var intent = await service.GetAsync(paymentIntentId, cancellationToken: ct);
        
        return intent.Status == "succeeded";
    }
}
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Persistence;
using SpoonFeed.Domain.Models;

namespace SpoonFeed.Application.Services;

public class OrderPaymentService : IOrderPaymentService
{
    private readonly IPaymentService _paymentService;
    private readonly SpoonFeedDbContext _db;
    private readonly ILogger _logger;
    
    public OrderPaymentService(IPaymentService paymentService, SpoonFeedDbContext db, ILogger logger)
    {
        _paymentService = paymentService;
        _db = db;
        _logger = logger;
    }
    
    public async Task<Result<string>> StartOrderPaymentAsync(Guid orderId, TransactionType transactionType, CancellationToken ct)
    {
        var order = await _db.Orders.FirstOrDefaultAsync(o => o.Id == orderId, cancellationToken: ct);

        if (order == null)
        {
            return Result<string>.FailureResult("Order not found", ErrorType.NotFound);
        }
        
        // визначити всі заклади яким іде оплата 
        // визначити скільки оплати йде кур'єру за доставку 
        // здійснити оплату закладу і кур'єру
        throw new NotImplementedException();
    }

    public async Task<Result<bool>> CreateCustomerCourierPendingTransaction(Guid orderId, Guid customerId, Guid courierId, CancellationToken ct)
    {
        var order = await _db.Orders.FirstOrDefaultAsync(o =>
            o.Id == orderId && o.CustomerId == customerId && o.CourierId == courierId, cancellationToken: ct);

        if (order == null)
        {
            return Result<bool>.FailureResult("Order not found", ErrorType.NotFound);
        }

        var pendingTransaction = new Transaction
        {
            Amount = CalculateDeliveryFee(),
            Currency = "uah",
            Status = TransactionStatus.Pending,
            TransactionType = TransactionType.DeliveryFee,
            OrderId = orderId,
            CustomerId = customerId,
            CourierId = courierId
        };

        try
        {
            await _db.Transactions.AddAsync(pendingTransaction, ct);
            await _db.SaveChangesAsync(ct);
        }
        catch (Exception e)
        {
            _logger.LogError(e.Message);
            
            return Result<bool>.FailureResult("An internal error occured", ErrorType.ServerError);
        }
        
        return Result<bool>.SuccessResult(true);
    }

    public Task<Result<bool>> CreateCustomerFacilitiesTransaction(Guid orderId, Guid customerId, Guid courierId, CancellationToken ct)
    {
        throw new NotImplementedException();
    }

    private int CalculateDeliveryFee()
    {
        var rnd = new Random();
        var fee = rnd.Next(50, 150);

        return fee;
    }
}
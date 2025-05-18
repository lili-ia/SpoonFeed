using Microsoft.Extensions.Logging;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Persistence;

namespace SpoonFeed.Application.Services;

public class PaymentService : IPaymentService
{
    private readonly SpoonFeedDbContext _db;
    private readonly ILogger<PaymentService> _logger;
    private readonly IOrderQueue _orderQueue;
    
    public PaymentService(SpoonFeedDbContext db, IOrderQueue orderQueue)
    {
        _db = db;
        _orderQueue = orderQueue;
    }

    public async Task<Result<bool>> ConfirmPaymentAsync(Guid orderId, CancellationToken ct)
    {
        var order = await _db.Orders.FindAsync(orderId, ct);

        if (order == null)
        {
            return Result<bool>.FailureResult(
                "Couldn`t find an order with such id.", ErrorType.NotFound);
        }

        if (order.Status != OrderStatus.PendingPayment)
        {
            return Result<bool>.FailureResult(
                "Order is not awaiting payment confirmation.", ErrorType.Forbidden);
        }

        // todo: add logic
        order.Status = OrderStatus.WaitingForCourier;

        try
        {
            _db.Orders.Update(order);
            await _db.SaveChangesAsync(ct);
        }
        catch (Exception e)
        {
            _logger.LogError(e.Message);
            
            return Result<bool>.FailureResult("An internal error occured", ErrorType.ServerError);
        }

        try
        {
            await _orderQueue.EnqueueAsync(orderId, ct);
        }
        catch (Exception e)
        {
            _logger.LogError(e.Message);
            
            return Result<bool>.FailureResult("An internal error occured", ErrorType.ServerError);
        }
        
        return Result<bool>.SuccessResult(true);
    }
}
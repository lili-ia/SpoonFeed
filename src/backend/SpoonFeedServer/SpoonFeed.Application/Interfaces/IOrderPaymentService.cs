using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.Interfaces;

public interface IOrderPaymentService
{
    Task<Result<string>> StartOrderPaymentAsync(Guid orderId, TransactionType transactionType, CancellationToken ct);

    Task<Result<bool>> CreateCustomerCourierPendingTransaction(Guid orderId, Guid customerId, Guid courierId, CancellationToken ct);
    
    Task<Result<bool>> CreateCustomerFacilitiesTransaction(Guid orderId, Guid customerId, Guid courierId, CancellationToken ct);
}
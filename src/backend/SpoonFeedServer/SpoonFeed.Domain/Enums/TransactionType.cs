namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents the type of transaction.
/// </summary>
public enum TransactionType
{
    /// <summary>
    /// Represents the customer's payment for an order.
    /// </summary>
    CustomerOrder,
    /// <summary>
    /// Represents the payment to the food facility for order positions.
    /// </summary>
    OrderFacility,
    /// <summary>
    /// Represents the payment to the courier for the order.
    /// </summary>
    OrderCourier,
    /// <summary>
    /// Represents the refund for the customer's order.
    /// </summary>
    OrderCustomer,
    /// <summary>
    /// Represents the refund for the ordered food facility's positions.
    /// </summary>
    FacilityOrder,
    /// <summary>
    /// Represents the refund for the courier's order payment.
    /// </summary>
    CourierOrder
}

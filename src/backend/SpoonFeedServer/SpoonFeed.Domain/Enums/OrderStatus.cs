namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents the states of order delivery.
/// </summary>
public enum OrderStatus
{
    /// <summary>
    /// Order was created but hasn't yet been filled by the user.
    /// </summary>
    Preparing,
    /// <summary>
    /// Order has been created but payment is still pending.
    /// </summary>
    PendingPayment,
    /// <summary>
    /// User submitted the order, and now it require a courier to be delivered.
    /// </summary>
    WaitingForCourier,
    /// <summary>
    /// Courier is heading to the food facility.
    /// </summary>
    Delivering,
    /// <summary>
    /// Courier is waiting for the order item to be done.
    /// </summary>
    WaitingOrderItem,
    /// <summary>
    /// Courier has reached the destination and is waiting for the customer to take the order.
    /// </summary>
    WaitingCustomer,
    /// <summary>
    /// Order was successfully delivered.
    /// </summary>
    Delivered,
    /// <summary>
    /// Order was canceled.
    /// </summary>
    Cancelled,
    /// <summary>
    /// There are no available couriers now
    /// </summary>
    CourierNotFound
}

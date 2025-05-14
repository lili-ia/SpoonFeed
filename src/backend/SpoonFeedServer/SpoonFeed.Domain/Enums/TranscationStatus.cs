namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents the current status of a Stripe transaction.
/// </summary>
public enum TransactionStatus
{
    /// <summary>
    /// Payment has been created but not yet completed.
    /// </summary>
    Pending,
    /// <summary>
    /// Payment was successful.
    /// </summary>
    Succeeded,
    /// <summary>
    /// Payment failed during processing.
    /// </summary>
    Failed,
    /// <summary>
    /// Payment was canceled before completion.
    /// </summary>
    Cancelled,
    /// <summary>
    /// Additional authentication or action is required.
    /// </summary>
    RequiresAction
}

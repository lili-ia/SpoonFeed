namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents status of the food chain account.
/// </summary>
public enum FoodChainStatus
{
    /// <summary>
    /// Food chain is created, but documents aren't provided.
    /// </summary>
    PendingDocuments,
    /// <summary>
    /// Food chain is created, but wait for approval.
    /// </summary>
    PendingApproval,
    /// <summary>
    /// The food chain is editable, but not visible.
    /// </summary>
    Private,
    /// <summary>
    /// The food chain is editable and visible for customers.
    /// </summary>
    Public,
    /// <summary>
    /// The food chain's account access is forbidden.
    /// </summary>
    Banned
}
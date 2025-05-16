namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents document approval process status.
/// </summary>
public enum DocumentStatus
{
    /// <summary>
    /// The document is waiting to be checked.
    /// </summary>
    Pending,
    /// <summary>
    /// Document passed the check.
    /// </summary>
    Approved,
    /// <summary>
    /// Document didn't pass the check.
    /// </summary>
    Rejected,
}
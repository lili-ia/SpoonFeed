namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents customer's status in the system.
/// </summary>
public enum CustomerStatus
{
    /// <summary>
    /// Represents a user who has been using the system in the past X days.  
    /// </summary>
    Active,
    /// <summary>
    /// Represents a user who hasn't been using the system in the past X days.  
    /// </summary>
    Inactive,
    /// <summary>
    /// Represents a user who is forbidden to use the system.
    /// </summary>
    Banned
}
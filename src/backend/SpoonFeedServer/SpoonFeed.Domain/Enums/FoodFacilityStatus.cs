namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents the status of a food facility
/// </summary>
public enum FoodFacilityStatus
{
    /// <summary>
    /// Represents the food facility which is not ready to take orders.
    /// </summary>
    Offline,
    /// <summary>
    /// Represents the food facility which is ready to take orders.
    /// </summary>
    Online
}

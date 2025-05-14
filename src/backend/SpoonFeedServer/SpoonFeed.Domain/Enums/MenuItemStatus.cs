namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents the status of the food facility's menu item.
/// </summary>
public enum MenuItemStatus
{
    /// <summary>
    /// Menu item is visible only for the food chain manager.  
    /// </summary>
    Hidden,
    /// <summary>
    /// Menu item is visible for everyone.
    /// </summary>
    Available,
    /// <summary>
    /// Menu item is visible for everyone to indicate that the food facility can't produce it.
    /// </summary>
    Unavailable,
    /// <summary>
    /// Menu item is visible for everyone to indicate that the item is out of stock.  
    /// </summary>
    OutOfStock
}

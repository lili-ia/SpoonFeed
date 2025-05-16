namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents the type of discount value.
/// </summary>
public enum DiscountType
{
    /// <summary>
    /// The type of value is considered to be in normilized percents (e.g., 0.1 is 10%).
    /// </summary>
    Percentage,
    /// <summary>
    /// The type of value is considered to be scalar (e.g., 100 will be taken from the item's price).
    /// </summary>
    Scalar
}

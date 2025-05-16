namespace SpoonFeed.Domain.Enums;

/// <summary>
/// Represents the user's payment method.
/// </summary>
public enum OrderPaymentMethod
{
    /// <summary>
    /// Represents an option when the user pays at delivery receiving.
    /// </summary>
    Cash,
    /// <summary>
    /// Represents any online payment (e.g., banking, Google Pay, etc.).
    /// </summary>
    Online,
}
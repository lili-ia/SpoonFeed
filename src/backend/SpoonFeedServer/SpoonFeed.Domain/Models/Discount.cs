using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents a discount applied to a specific menu item within the system.
/// </summary>
public class Discount : BaseEntity
{
    private const DiscountType DefaultDiscountType = Enums.DiscountType.Percentage;
    
    /// <summary>
    /// Represents the scalar value of discount.
    /// </summary>
    /// <remarks>
    /// Percents are considered to be normalized (e.g., 0.1 is 10%, 2 is 200%, etc.).
    /// </remarks>
    [Required(ErrorMessage = "Value is required.")]
    [Range(0.01, double.MaxValue, ErrorMessage = "Value must be greater than 0.01.")]
    public double Value { get; set; }
    
    /// <summary>
    /// Represents the type of discount value.
    /// </summary>
    public DiscountType DiscountType { get; set; } = DefaultDiscountType;
    
    /// <summary>
    /// Represents the discount's invalidation time, after which it is not active.
    /// </summary>
    public DateTime? InvalidAt { get; set; }

    [Required(ErrorMessage = "MenuItemId is required.")]
    public Guid MenuItemId { get; set; }

    /// <summary>
    /// Represents the item the discount is applied to. 
    /// </summary>
    public virtual MenuItem MenuItem { get; set; } = null!;
}
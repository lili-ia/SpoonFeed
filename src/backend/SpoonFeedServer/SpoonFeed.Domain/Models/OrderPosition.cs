using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents a menu item in the user's order with the quantity set.
/// </summary>
public class OrderPosition : BaseEntity
{
    /// <summary>
    /// Represents the unit amount of the menu item. 
    /// </summary>
    [Required(ErrorMessage = "Quantity is required.")]
    [Range(1, int.MaxValue, ErrorMessage = "Quantity must be greater than 0.")]
    public int Quantity { get; set; }
    
    /// <summary>
    /// Represents the total price of the position.
    /// Calculated by the database, with respect to quantity and discounts.
    /// </summary>
    public double TotalPrice { get; set; }
    
    [Required(ErrorMessage = "OrderId is required.")]
    public Guid OrderId { get; set; }
    
    /// <summary>
    /// Represents the order to which the item belongs.
    /// </summary>
    public virtual Order Order { get; set; } = null!;
    
    [Required(ErrorMessage = "MenuItemId is required.")]
    public Guid MenuItemId { get; set; }
    
    /// <summary>
    /// Represents the menu item this order item is representing.
    /// </summary>
    public virtual MenuItem MenuItem { get; set; } = null!;
}
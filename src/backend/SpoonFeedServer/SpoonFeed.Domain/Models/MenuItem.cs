using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents a menu item of a food facility.
/// </summary>
public class MenuItem : BaseEntity
{
    private const MenuItemStatus DefaultStatus = MenuItemStatus.Hidden;
    
    /// <summary>
    /// Represents a name of the item. 
    /// </summary>
    [Required(ErrorMessage = "Name is required.")]
    [MinLength(2, ErrorMessage = "The name of menu item should be at least 2 characters long.")]
    [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters.")]
    public string Name { get; set; } = string.Empty;
    
    /// <summary>
    /// Represents a plain description of ingredients. 
    /// </summary>
    [Required(ErrorMessage = "Ingredients is required.")]
    public string Ingredients { get; set; } = string.Empty;

    /// <summary>
    /// Represents current menu item's status. 
    /// </summary>
    [Required(ErrorMessage = "Status is required.")]
    public MenuItemStatus Status { get; set; } = DefaultStatus;
    
    /// <summary>
    /// Represents the scalar value of the item's price. 
    /// </summary>
    [Required(ErrorMessage = "Price is required.")]
    [Range(0, double.MaxValue, ErrorMessage = "Price cannot be negative.")]
    public double Price { get; set; }
    
    public Guid CurrencyId { get; set; }
    
    /// <summary>
    /// Represents the price's currency.
    /// </summary>
    [Required(ErrorMessage = "Currency is required.")]
    public virtual Currency Currency { get; set; } = null!;
    
    [Required]
    public Guid FooFoodFacilityId { get; set; }

    /// <summary>
    /// Represents the owner food facility.
    /// </summary>
    [Required(ErrorMessage = "FoodFacility is required.")]
    public virtual FoodFacility FoodFacility { get; set; } = null!;
    
    public Guid? MenuItemCategoryId { get; set; }

    /// <summary>
    /// Represents the category of the menu item.
    /// </summary>
    public virtual MenuItemCategory? MenuItemCategory { get; set; }
    
    /// <summary>
    /// Represents the weight of the menu item in grams or milliliters.
    /// </summary>
    [Required(ErrorMessage = "Weight is required.")]
    [Range(0, int.MaxValue, ErrorMessage = "Weight cannot be negative.")]
    public int Weight { get; set; }
    
    [Required(ErrorMessage = "ImageId is required.")]
    public Guid ImageId { get; set; }

    /// <summary>
    /// Represents the image of the menu item.
    /// </summary>
    [Required(ErrorMessage = "Image is required.")]
    public virtual Image Image { get; set; } = null!;

    public virtual IList<Discount> Discounts { get; set; } = [];
}
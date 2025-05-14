using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents the menu item's category.
/// </summary>
public class MenuItemCategory : BaseEntity
{
    /// <summary>
    /// Represents the name of the category.
    /// </summary>
    [Required(ErrorMessage = "Name is required.")]
    [MinLength(2, ErrorMessage = "The name of category should be at least 2 characters long.")]
    [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters.")]
    public string Name { get; set; } = string.Empty;

    [Required(ErrorMessage = "FoodFacilityId is required.")]
    public Guid FoodFacilityId { get; set; }
    
    /// <summary>
    /// Represents owner food facility.
    /// </summary>
    public virtual FoodFacility FoodFacility { get; set; } = null!;

    public virtual IList<MenuItem> MenuItems { get; set; } = [];
}
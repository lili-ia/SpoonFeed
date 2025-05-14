using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Domain.Owned;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents specific food facility of the food chain.
/// </summary>
public class FoodFacility : BaseEntity
{
    private const FoodFacilityStatus DefaultStatus = FoodFacilityStatus.Offline;
    
    /// <summary>
    /// Represents the food facility's full address.
    /// </summary>
    [Required(ErrorMessage = "Address is required.")]
    public Address Address { get; set; } = null!;
    
    /// <summary>
    /// Represent's the name of the food facility.
    /// </summary>
    [Required(ErrorMessage = "Name is required.")]
    [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters.")]
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Represents a range of food facility's working hours.
    /// </summary>
    [Required(ErrorMessage = "WorkinHours are required.")]
    public WorkingHours WorkingHours { get; set; } = null!;

    /// <summary>
    /// Represents the current status of the food facility's ability to accept orders.
    /// </summary>
    [Required(ErrorMessage = "Status is required.")]
    public FoodFacilityStatus Status { get; set; } = DefaultStatus;

    /// <summary>
    /// Represents the average score of food facility reviews.
    /// Calculated by the database.
    /// </summary>
    public double AverageScore { get; set; }
    
    public Guid FoodChainId { get; set; }

    /// <summary>
    /// Represents the owner food chain.
    /// </summary>
    public virtual FoodChain FoodChain { get; set; } = null!;

    public virtual IList<MenuItem> MenuItems { get; set; } = [];
    
    public virtual IList<Order> Orders { get; set; } = [];
    
    public virtual IList<Transaction> Transactions { get; set; } = [];
    
    public virtual IList<FoodFacilityReview> FoodFacilityReviews { get; set; } = [];
    
    public virtual IList<MenuItemCategory> MenuItemCategories { get; set; } = [];
}
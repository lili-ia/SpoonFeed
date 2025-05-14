using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents the food chain's account created by its manager.
/// </summary>
public class FoodChain
{
    private const FoodChainCategory DefaultCategory = FoodChainCategory.None;
    private const FoodChainStatus DefaultStatus = FoodChainStatus.PendingDocuments;
    
    [Key, ForeignKey("UserIdentity")]
    public Guid UserIdentityId { get; set; }
    
    /// <summary>
    /// Represents base user
    /// </summary>
    public UserIdentity UserIdentity { get; set; }
    
    /// <summary>
    /// Represents the category of the food chain.
    /// </summary>
    [Required(ErrorMessage = "Category is required.")]
    public FoodChainCategory Category { get; set; } = DefaultCategory;

    /// <summary>
    /// Represents the current state of the food chain account.
    /// </summary>
    [Required(ErrorMessage = "Status is required.")]
    public FoodChainStatus Status { get; set; } = DefaultStatus;
    
    /// <summary>
    /// Represents overall average score.
    /// Calculated as average of food facilities average scores.
    /// </summary>
    public double AverageScore { get; set; }

    public Guid? ImageId { get; set; }
    
    /// <summary>
    /// Represents the food chain's image on the platform.
    /// </summary>
    public virtual Image? Image { get; set; }

    public virtual IList<FoodFacility> Facilities { get; set; } = [];
}
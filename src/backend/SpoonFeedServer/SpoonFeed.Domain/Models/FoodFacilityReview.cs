using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents customer's review on food facility.
/// </summary>
public class FoodFacilityReview : BaseEntity
{
    /// <summary>
    /// Represents the food facility's score given by the customer. 
    /// </summary>
    [Required(ErrorMessage = "Score is required.")]
    [Range(1, 10)]
    public int Score { get; set; }
    
    [Required(ErrorMessage = "FoodFacilityId is required.")]
    public Guid FoodFacilityId { get; set; }

    /// <summary>
    /// Represents the food facility which is being reviewed.
    /// </summary>
    public virtual FoodFacility FoodFacility { get; set; } = null!;
}
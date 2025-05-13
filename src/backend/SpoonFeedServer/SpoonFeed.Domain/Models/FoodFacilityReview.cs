using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

public class FoodFacilityReview : BaseEntity
{
    public Guid FoodFacilityId { get; set; }
    
    public virtual FoodFacility FoodFacility { get; set; }
    
    [Range(1, 10)]
    public int Score { get; set; }
}
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class FoodFacility : BaseEntity
{
    public string Address { get; set; }
    
    public string Name { get; set; }
    
    public string WorkingHours { get; set; }

    public FacilityStatus FacilityStatus { get; set; }
    
    public Guid ImageId { get; set; }
    
    public virtual Image Image { get; set; }
    
    public double AverageRating { get; set; } // todo : procedure
    
    public virtual IList<MenuItem> MenuItems { get; set; }
    
    public virtual IList<Order> Orders { get; set; }
    
    public virtual IList<Transaction> Transactions { get; set; }
    
    public virtual IList<FoodFacilityReview> FoodFacilityReviews { get; set; }
}
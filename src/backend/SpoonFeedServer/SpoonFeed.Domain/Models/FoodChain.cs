using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class FoodChain : BaseEntity
{
    public string Name { get; set; }
    
    public string Email { get; set; }
    
    public string PhoneNumber { get; set; }
    
    public virtual IList<FoodFacility> Facilities { get; set; }
    
    public virtual IList<FoodChainManager> Managers { get; set; }

    public FoodChainCategory FoodChainCategory { get; set; }
    
    public double AverageScore { get; set; }   
    
    public Guid ImageId { get; set; }
    
    public virtual Image Image { get; set; }
}
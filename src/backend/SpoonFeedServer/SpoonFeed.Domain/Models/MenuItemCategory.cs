namespace SpoonFeed.Domain.Models;

public class MenuItemCategory : BaseEntity
{
    public string Name { get; set; }

    public Guid FoodFacilityId { get; set; }
    
    public virtual FoodFacility FoodFacility { get; set; }
    
    public virtual IList<MenuItem> MenuItems { get; set; }
}
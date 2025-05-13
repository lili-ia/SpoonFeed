using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class MenuItem : BaseEntity
{
    public string Name { get; set; }
    
    public string Ingredients { get; set; }
    
    public bool IsActive { get; set; }

    public MenuItemStatus MenuItemStatus { get; set; }
    
    public double Price { get; set; }
    
    public Guid CurrencyId { get; set; }
    
    public virtual Currency Currency { get; set; }
    
    public Guid FooFoodFacilityId { get; set; }
    
    public virtual FoodFacility FoodFacility { get; set; }
    
    public Guid MenuItemCategoryId { get; set; }

    public virtual MenuItemCategory MenuItemCategory { get; set; }
    
    public int Weight { get; set; }
    
    public Guid ImageId { get; set; }
    
    public virtual Image Image { get; set; }
    
    public virtual IList<Discount> Discounts { get; set; }
}
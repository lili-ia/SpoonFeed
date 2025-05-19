using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.DTOs.Order;

public class OrderPositionDto
{
    public Guid FoodFacilityId { get; set; }
    
    public string OrderPositionName { get; set; }
    
    public string FoodFacilityName { get; set; }
    
    public int OrderPositionQuantity { get; set; }
    
    public OrderPositionPickupStatus PickupStatus { get; set; }
}
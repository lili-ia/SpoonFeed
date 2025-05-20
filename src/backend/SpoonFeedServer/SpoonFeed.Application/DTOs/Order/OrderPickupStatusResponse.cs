namespace SpoonFeed.Application.DTOs.Order;

public class OrderPickupStatusResponse
{
    public bool AllPickedUp { get; set; }
    
    public IList<FacilityDto> RemainingFacilities { get; set; }
}
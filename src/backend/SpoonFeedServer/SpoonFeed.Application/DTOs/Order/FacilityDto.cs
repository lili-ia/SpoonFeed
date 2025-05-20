namespace SpoonFeed.Application.DTOs.Order;

public class FacilityDto
{
    public Guid Id { get; set; }
    
    public string FacilityName { get; set; }
    
    public int PositionsRemaining { get; set; }
}
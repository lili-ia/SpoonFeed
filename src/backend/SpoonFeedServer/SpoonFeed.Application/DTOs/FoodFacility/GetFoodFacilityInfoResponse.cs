using SpoonFeed.Application.DTOs.Shared;

namespace SpoonFeed.Application.DTOs.FoodFacility;

public class GetFoodFacilityInfoResponse
{
    public AddressDto AddressDto {get; set; }
    
    public string PhoneNumber {get; set; }
    
    public string FirstName {get; set; }
    
    public string LastName {get; set; }
    
    public string FacilityName {get; set; }
    
    public string? PicUrl { get; set; }
}
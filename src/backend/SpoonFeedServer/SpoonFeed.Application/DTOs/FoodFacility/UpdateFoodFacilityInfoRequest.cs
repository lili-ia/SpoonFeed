using System.ComponentModel.DataAnnotations;
using SpoonFeed.Application.DTOs.Shared;
using SpoonFeed.Application.Validators;

namespace SpoonFeed.Application.DTOs.FoodFacility;

public class UpdateFoodFacilityInfoRequest
{
    public AddressDto AddressDto {get; set; }
    
    [UkrainianPhoneNumber]
    public string PhoneNumber {get; set; }
    
    [OnlyLetters]
    [MinLength(3)]
    [MaxLength(30)]
    public string FirstName {get; set; }
    
    [OnlyLetters]
    [MinLength(3)]
    [MaxLength(30)]
    public string LastName {get; set; }
    
    [Required(ErrorMessage = "Name is required.")]
    [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters.")]
    public string FacilityName {get; set; }
    
    public string? PicUrl { get; set; }
}
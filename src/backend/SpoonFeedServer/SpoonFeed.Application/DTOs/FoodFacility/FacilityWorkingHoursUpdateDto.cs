using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.FoodFacility;

public class FacilityWorkingHoursUpdateDto
{
    [Required]
    [MinLength(7, ErrorMessage = "Must provide working hours for all 7 days.")]
    [MaxLength(7, ErrorMessage = "Must provide working hours for exactly 7 days.")]
    public List<DayWorkingHoursUpdateDto> Days { get; set; } = new();
}
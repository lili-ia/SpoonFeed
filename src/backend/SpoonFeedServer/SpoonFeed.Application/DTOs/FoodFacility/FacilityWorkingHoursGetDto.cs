using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.FoodFacility;

public class FacilityWorkingHoursGetDto
{
    [Required]
    public DayOfWeek Day { get; set; }

    [Required]
    public bool IsOpen { get; set; }

    [Required]
    public TimeOnly OpenTime { get; set; }

    [Required]
    public TimeOnly CloseTime { get; set; }
}
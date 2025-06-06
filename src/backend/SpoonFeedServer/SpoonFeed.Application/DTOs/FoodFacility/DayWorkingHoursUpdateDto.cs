using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.FoodFacility;

public class DayWorkingHoursUpdateDto
{
    [Required]
    public DayOfWeek Day { get; set; }

    [Required]
    public bool IsOpen { get; set; }

    // Час у форматі "HH:mm"
    [Required]
    [RegularExpression(@"^([01]\d|2[0-3]):([0-5]\d)$", ErrorMessage = "Time must be in HH:mm format")]
    public string OpenTime { get; set; } = "00:00";

    [Required]
    [RegularExpression(@"^([01]\d|2[0-3]):([0-5]\d)$", ErrorMessage = "Time must be in HH:mm format")]
    public string CloseTime { get; set; } = "00:00";
}
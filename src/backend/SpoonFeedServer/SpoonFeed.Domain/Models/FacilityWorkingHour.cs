using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

public class FacilityWorkingHour : BaseEntity
{
    [Required]
    public Guid FoodFacilityId { get; set; }
    
    public FoodFacility FoodFacility { get; set; } = null!;

    [Required]
    public DayOfWeek Day { get; set; }

    [Required]
    public bool IsOpen { get; set; }

    [Required]
    public TimeOnly OpenTime { get; set; }

    [Required]
    public TimeOnly CloseTime { get; set; }
}
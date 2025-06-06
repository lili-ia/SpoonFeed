using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace SpoonFeed.Domain.Owned;

/// <summary>
/// Represents a range of working hours.
/// </summary>
[Owned]
public class WorkingHours : IValidatableObject
{
    [Required]
    public DayOfWeek DayOfWeek { get; set; }
    
    [Required]
    public bool IsOpen { get; set; }
    
    [Required] 
    public TimeOnly OpenTime { get; set; } = TimeOnly.MinValue;

    [Required]
    public TimeOnly CloseTime { get; set; } = TimeOnly.MaxValue;

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        if (OpenTime >= CloseTime)
        {
            yield return new ValidationResult("Start time must be earlier than end time.", new[] { nameof(OpenTime), nameof(CloseTime) });
        }
    }
}

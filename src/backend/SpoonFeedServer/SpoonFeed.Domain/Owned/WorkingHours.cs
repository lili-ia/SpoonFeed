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
    public TimeOnly Start { get; set; } = TimeOnly.MinValue;

    [Required]
    public TimeOnly End { get; set; } = TimeOnly.MaxValue;

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        if (Start >= End)
        {
            yield return new ValidationResult("Start time must be earlier than end time.", new[] { nameof(Start), nameof(End) });
        }
    }
}

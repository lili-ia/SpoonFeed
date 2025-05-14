using Microsoft.EntityFrameworkCore;

namespace SpoonFeed.Domain.Owned;

/// <summary>
/// Represents a range of working hours.
/// </summary>
[Owned]
public class WorkingHours
{
    TimeOnly Start { get; set; }
    TimeOnly End { get; set; }
}
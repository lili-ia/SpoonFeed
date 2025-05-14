using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace SpoonFeed.Persistence.Converters;

public class NullableDateOnlyConverter : ValueConverter<DateOnly?, DateTime?>
{
    public NullableDateOnlyConverter() : base(
        dateOnly => dateOnly.HasValue ? dateOnly.Value.ToDateTime(TimeOnly.MinValue) : null,
        dateTime => dateTime.HasValue ? DateOnly.FromDateTime(dateTime.Value) : null) { }
}
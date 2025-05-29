using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.Validators;

public class PastDateOnlyAttribute : ValidationAttribute
{
    public override bool IsValid(object? value)
    {
        if (value == null) return true;
        return value is DateOnly date && date <= DateOnly.FromDateTime(DateTime.Today);
    }

    public override string FormatErrorMessage(string name)
    {
        return $"{name} не може бути в майбутньому.";
    }
}

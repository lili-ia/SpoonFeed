using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.Validators;

public class ExistingRoleAttribute : ValidationAttribute
{
    public override bool IsValid(object? value)
    {
        return Enum.IsDefined(typeof(Role), value);
    }

    public override string FormatErrorMessage(string name)
    {
        return "Invalid role";
    }
}
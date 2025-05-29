using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace SpoonFeed.Application.Validators;

public class UkrainianPhoneNumberAttribute : ValidationAttribute
{
    public override bool IsValid(object? value)
    {
        if (value is null) return true; 

        var input = value.ToString();
        return Regex.IsMatch(input!, @"^\+380\d{9}$");
    }

    public override string FormatErrorMessage(string name)
    {
        return "Invalid phone number";
    }
}
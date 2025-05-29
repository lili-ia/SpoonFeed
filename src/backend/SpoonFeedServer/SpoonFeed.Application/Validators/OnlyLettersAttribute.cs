using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace SpoonFeed.Application.Validators;

public class OnlyLettersAttribute : ValidationAttribute
{
    public override bool IsValid(object? value)
    {
        if (value is null) return true; 

        var input = value.ToString();
        return Regex.IsMatch(input!, @"^[а-щА-ЩЬьЮюЯяЇїІіЄєҐґa-zA-Z]+$");
    }

    public override string FormatErrorMessage(string name)
    {
        return $"{name} must contain only ukrainian or english letters.";
    }
}
using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.DTOs.Auth;

public record RegisterUserRequest(
    [Required]
    [EmailAddress]
    string Email,
    [Required]
    [StringLength(50, MinimumLength = 6)]
    string Password,
    [Required]
    [RegularExpression(@"^\+380\d{9}$", ErrorMessage = "Phone number must be in the format +380XXXXXXXXX.")]
    string PhoneNumber,
    string? FirstName, 
    string? LastName,
    string? Address,
    DateOnly? BirthDate,
    Role UserType);
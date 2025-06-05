using System.ComponentModel.DataAnnotations;
using SpoonFeed.Application.DTOs.Shared;
using SpoonFeed.Application.Validators;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.DTOs.Auth;

public record RegisterUserRequest (

    [Required(ErrorMessage = "Email is required")] 
    [EmailAddress(ErrorMessage = "Invalid email address")]
    string Email,

    [Required] 
    [StringLength(50, MinimumLength = 6)]
    string Password,

    [Required] 
    [UkrainianPhoneNumber]
    string PhoneNumber,

    [OnlyLetters]
    string? FirstName,
    
    [OnlyLetters]
    string? LastName,
    
    DateOnly? BirthDate,
    
    [ExistingRole]
    [Required]
    Role UserType);
    
using System.ComponentModel.DataAnnotations;
using SpoonFeed.Application.Validators;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.DTOs.Auth;

public class RegisterUserRequest
{
    [Required(ErrorMessage = "Email is required")] 
    [EmailAddress(ErrorMessage = "Invalid email address")]
    public string Email { get; set; }

    [Required] 
    [StringLength(50, MinimumLength = 6)]
    public string Password { get; set; }

    [Required] 
    [UkrainianPhoneNumber]
    public string PhoneNumber { get; set; }

    [OnlyLetters]
    public string? FirstName { get; set; }
    
    [OnlyLetters]
    public string? LastName { get; set; }
    
    public string? Address { get; set; }

    public DateOnly? BirthDate { get; set; }
    
    [ExistingRole]
    [Required]
    public Role UserType { get; set; }
}
    
using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents user's credentials
/// </summary>
public abstract class UserIdentity : BaseEntity
{
    /// <summary>
    /// Represent the user's email.
    /// Allows sending emails to users.
    /// </summary>
    [EmailAddress]
    [Required(ErrorMessage = "Email is required.")]
    public string Email { get; set; } = string.Empty;
    
    /// <summary>
    /// Represent the user's first name.
    /// Not required for customers.
    /// </summary>
    [MinLength(3)]
    [MaxLength(30)]
    public string? FirstName { get; set; }
    
    /// <summary>
    /// Represent the user's last name.
    /// Not required for customers.
    /// </summary>
    [MinLength(3)]
    [MaxLength(30)]
    public string? LastName { get; set; }
    
    /// <summary>
    /// Represent the user's password, hashed for security reasons.
    /// Used primary for comparison in auth service.
    /// </summary>
    [MinLength(10)]
    [MaxLength(255)]
    [Required(ErrorMessage = "Password is required.")]
    public string PasswordHash { get; set; } = string.Empty;
    
    /// <summary>
    /// Represent the user's phone number.
    /// Required by all the users for proper business logic. 
    /// </summary>
    [MaxLength(20)]
    [Required(ErrorMessage = "PhoneNumber is required.")]
    public string PhoneNumber { get; set; } = string.Empty;
}
using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

public abstract class UserIdentity : BaseEntity
{
    [EmailAddress]
    [Required]
    public string Email { get; set; }
    
    [MinLength(3)]
    [MaxLength(30)]
    public string FirstName { get; set; }
    
    [MinLength(3)]
    [MaxLength(30)]
    public string LastName { get; set; }
    
    [MinLength(10)]
    [MaxLength(255)]
    [Required]
    public string PasswordHash { get; set; }
    
    [MaxLength(20)]
    public string PhoneNumber { get; set; }
}
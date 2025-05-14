using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class FoodChain : BaseEntity
{
    [MaxLength(100)]
    public string Name { get; set; }
    
    [EmailAddress]
    [Required]
    public string Email { get; set; }
    
    [MaxLength(20)]
    public string PhoneNumber { get; set; }
    
    [MinLength(10)]
    [MaxLength(255)]
    [Required]
    public string PasswordHash { get; set; }
    public virtual IList<FoodFacility> Facilities { get; set; }
    
    public virtual IList<FoodChainManager> Managers { get; set; }

    public FoodChainCategory FoodChainCategory { get; set; }
    
    public double AverageScore { get; set; }   
    
    public Guid? ImageId { get; set; }
    
    public virtual Image? Image { get; set; }
}
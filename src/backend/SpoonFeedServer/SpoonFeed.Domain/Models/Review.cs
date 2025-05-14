using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

public abstract class Review : BaseEntity
{
    [Required(ErrorMessage = "Content is required.")]
    [StringLength(1000, ErrorMessage = "Content must be less than 1000 characters.")]
    public string Content { get; set; }
    
    [Required(ErrorMessage = "PublishedAt is required.")]
    public DateTime PublishedAt { get; set; }
    
    [Required(ErrorMessage = "CustomerId is required.")]
    public Guid CustomerId { get; set; } 
    
    public virtual Customer Customer { get; set; }
}
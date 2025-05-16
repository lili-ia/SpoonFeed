using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Base class for customer's reviews. 
/// </summary>
public abstract class Review : BaseEntity
{
    /// <summary>
    /// The text of the customer's review.
    /// </summary>
    [Required(ErrorMessage = "Content is required.")]
    [StringLength(1000, ErrorMessage = "Content must be less than 1000 characters.")]
    public string Content { get; set; } = string.Empty;
    
    /// <summary>
    /// Represents the timestamp when the review was added to the system.
    /// Set by database.
    /// </summary>
    [Required(ErrorMessage = "PublishedAt is required.")]
    public DateTime PublishedAt { get; set; }
    
    [Required(ErrorMessage = "CustomerId is required.")]
    public Guid CustomerId { get; set; } 
    
    /// <summary>
    /// Represent's the customer who wrote the review.
    /// </summary>
    public virtual Customer Customer { get; set; } = null!;
}
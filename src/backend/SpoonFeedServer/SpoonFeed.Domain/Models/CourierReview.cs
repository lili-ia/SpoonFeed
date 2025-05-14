using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents the customer's review on courier. 
/// </summary>
public class CourierReview : Review
{
    private const CourierReviewType DefaultReviewType = CourierReviewType.Other;
    
    [Required(ErrorMessage = "CourierId is required.")]
    public Guid CourierId { get; set; }
    
    /// <summary>
    /// Represents the courier who is being reviewed.
    /// </summary>
    public virtual Courier Courier { get; set; } = null!;

    /// <summary>
    /// Represents the type of review, which describes its category.
    /// </summary>
    [Required(ErrorMessage = "ReviewType is required.")]
    public CourierReviewType ReviewType { get; set; } = DefaultReviewType;
}
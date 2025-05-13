using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class CourierReview : Review
{
    [Required(ErrorMessage = "CourierId is required.")]
    public Guid CourierId { get; set; }
    
    public virtual Courier Courier { get; set; }
    
    [Required(ErrorMessage = "CourierReviewType is required.")]
    public CourierReviewType CourierReviewType { get; set; }
}
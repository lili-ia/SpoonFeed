using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class Courier : UserIdentity
{
    public TransportType? TransportType { get; set; }
    
    [Required(ErrorMessage = "AccountBalance is required.")]
    [Range(0, double.MaxValue, ErrorMessage = "Account balance cannot be negative.")]
    public double AccountBalance { get; set; }
    
    [Required(ErrorMessage = "CourierStatus is required.")]
    public CourierStatus CourierStatus { get; set; }
    
    [Range(0.5, 100, ErrorMessage = "Delivery range must be between 0.5 and 100 kilometers.")]
    public double? DeliveryRange { get; set; } 
    
    [Range(0, 5, ErrorMessage = "Average rating must be between 0 and 5.")]
    public double? AverageRating { get; set; }
    
    public virtual IList<CourierReview>? CourierReviews { get; set; }
    
    public virtual IList<Order>? Orders { get; set; }
    
    public virtual IList<Transaction>? Transactions { get; set; }
}
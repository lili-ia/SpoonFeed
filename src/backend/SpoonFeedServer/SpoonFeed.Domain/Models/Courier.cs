using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents the courier and his account.
/// </summary>
public class Courier
{
    private const float DefaultDeliveryRange = 0.5f; 
    private const TransportType DefaultTransportType = TransportType.None;
    private const CourierStatus DefaultCourierStatus = CourierStatus.Offline;
    
    [Key, ForeignKey("UserIdentity")]
    public Guid UserIdentityId { get; set; }
    
    /// <summary>
    /// Represents base user
    /// </summary>
    public UserIdentity UserIdentity { get; set; }
    
    /// <summary>
    /// Represents the courier's type of transport.
    /// Affects the max order weight.
    /// </summary>
    public TransportType TransportType { get; set; } = DefaultTransportType;

    /// <summary>
    /// Represents moneys the courier has earned by completing orders and which he can withdraw.
    /// Calculated based on completed orders and withdrawn money.
    /// </summary>
    [Required(ErrorMessage = "AccountBalance is required.")]
    [Range(0, double.MaxValue, ErrorMessage = "Account balance cannot be negative.")]
    public double AccountBalance { get; set; } = 0;
    
    /// <summary>
    /// Represents the current state of courier in the system, like offline, waiting order, delivering, etc.
    /// Set by system's events, like start accepting, accept, get food, etc.
    /// </summary>
    [Required(ErrorMessage = "CourierStatus is required.")]
    public CourierStatus CourierStatus { get; set; } = DefaultCourierStatus;

    /// <summary>
    /// Represents the distance in kilometers at which the courier can accept orders.
    /// Max value depends on the courier's transport type.
    /// </summary>
    [Required(ErrorMessage = "DeliveryRange is required.")]
    [Range(0.5, 100, ErrorMessage = "Delivery range must be between 0.5 and 100 kilometers.")]
    public float DeliveryRange { get; set; } = DefaultDeliveryRange;

    public virtual IList<CourierReview> CourierReviews { get; set; } = [];

    public virtual IList<Order> Orders { get; set; } = [];

    public virtual IList<Transaction> Transactions { get; set; } = [];
}
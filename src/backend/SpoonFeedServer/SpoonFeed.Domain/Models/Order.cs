using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Domain.Owned;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents the customer's order.
/// </summary>
public class Order : BaseEntity
{
    private const OrderStatus DefaultStatus = OrderStatus.Preparing;
    
    /// <summary>
    /// Represents the timestamp when the order submitted by user.
    /// </summary>
    public DateTime? ReceivedAt { get; set; }
    
    /// <summary>
    /// Represents the timestamp when the first courier started the delivery.
    /// </summary>
    public DateTime? AcceptedAt { get; set; }
    
    /// <summary>
    /// Represents the timestamp when the order was delivered.
    /// </summary>
    public DateTime? DeliveredAt { get; set; }
    
    /// <summary>
    /// Represents the current status of order delivery.
    /// </summary>
    [Required(ErrorMessage = "Status is required.")]
    public OrderStatus Status { get; set; } = DefaultStatus;
    
    /// <summary>
    /// Represents the courier's final destination.
    /// </summary>
    [Required(ErrorMessage = "DeliveryAddress is required.")]
    public Address DeliveryAddress { get; set; } = null!;

    /// <summary>
    /// Represents the type of order payment method.
    /// </summary>
    public OrderPaymentMethod? PaymentMethod { get; set; }
    
    /// <summary>
    /// Represents the total cost of the order.
    /// Calculated as the sum of total of order items + courier`s delivery fee
    /// </summary>
    public double Total { get; set; }
    
    /// <summary>
    /// Used to confirm delivery on customer`s side
    /// </summary>
    [Required]
    [StringLength(4, MinimumLength = 4)]
    public string DeliveryConfirmationCode { get; set; }
    
    [Required(ErrorMessage = "CustomerId is required.")]
    public Guid CustomerId { get; set; }
    
    /// <summary>
    /// Represents the customer who owns the order.
    /// </summary>
    public virtual Customer Customer { get; set; } = null!;
    
    public Guid? CourierId { get; set; }
    
    public virtual Courier? Courier { get; set; }

    public virtual IList<OrderPosition> OrderPositions { get; set; } = [];
}
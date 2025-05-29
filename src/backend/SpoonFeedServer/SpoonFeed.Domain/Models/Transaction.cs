using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents Stripe-related entity.
/// </summary>
public class Transaction : BaseEntity
{
    private const TransactionStatus DefaultStatus = TransactionStatus.Pending;
    /// <summary>
    /// Stripe PaymentIntent ID (e.g., "pi_1234abc...").
    /// </summary>
    [Required(ErrorMessage = "PaymentIntentId is required.")]
    public string PaymentIntentId { get; set; } = string.Empty;
    
    /// <summary>
    /// The total amount charged, in the smallest unit of the currency (e.g., cents).
    /// </summary>
    [Required(ErrorMessage = "Amount is required.")]
    [Range(0, long.MaxValue, ErrorMessage = "Amount cannot be negative.")]
    public long Amount { get; set; }
    
    /// <summary>
    /// Represents the currency used for the transaction.
    /// </summary>
    [Required(ErrorMessage = "Currency is required.")]
    public string Currency { get; set; } = null!;

    /// <summary>
    /// Represents the current status of the transaction.
    /// </summary>
    [Required(ErrorMessage = "Status is required.")]
    public TransactionStatus Status { get; set; } = DefaultStatus;

    /// <summary>
    /// Represents the receiver and recipient of the transaction.
    /// </summary>
    [Required(ErrorMessage = "TransactionType is required.")]
    public TransactionType TransactionType { get; set; }
    
    /// <summary>
    /// Represents the timestamp when the transaction was created.
    /// Set by the database.
    /// </summary>
    [Required(ErrorMessage = "OpenedAt is required.")]
    public DateTime OpenedAt { get; set; }
    
    /// <summary>
    /// Represents the timestamp when the transaction was modified.
    /// Set by the database.
    /// </summary>
    [Required(ErrorMessage = "UpdatedAt is required.")]
    public DateTime UpdatedAt { get; set; }
    
    /// <summary>
    /// Represents the timestamp when the transaction was closed.
    /// </summary>
    public DateTime? ClosedAt { get; set; }
    
    public Guid? OrderId { get; set; }
    
    public virtual Order? Order { get; set; }
    
    public Guid? OrderPositionId { get; set; }
    
    public virtual OrderPosition? OrderPosition { get; set; }
    public Guid? CustomerId { get; set; }
    
    public virtual Customer? Customer { get; set; }
    
    public Guid? FoodFacilityId { get; set; }
    
    public virtual FoodFacility? FoodFacility { get; set; }
    
    public Guid? CourierId { get; set; }
    
    public virtual Courier? Courier { get; set; }
}
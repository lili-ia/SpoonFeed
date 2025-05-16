using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents the customer's profile.
/// </summary>
public class Customer 
{
    private const int DefaultBonusBalance = 0;
    private const CustomerStatus DefaultCustomerStatus = CustomerStatus.Active;
    
    [Key, ForeignKey("UserIdentity")]
    public Guid UserIdentityId { get; set; }
    
    /// <summary>
    /// Represents base user
    /// </summary>
    public UserIdentity UserIdentity { get; set; }
    
    /// <summary>
    /// Represents customer's address.
    /// Used as a default address when making an order.
    /// </summary>
    [StringLength(100, ErrorMessage = "Address cannot exceed 100 characters.")]
    public string? Address { get; set; }
    
    /// <summary>
    /// Represents the user's birthdate.
    /// Could be used for special propositions and bonus gifts.
    /// </summary>
    public DateOnly? BirthDate { get; set; }

    /// <summary>
    /// Represents the customer's bonus balance.
    /// Used during the ordering process.
    /// </summary>
    [Required(ErrorMessage = "Bonuses are required.")]
    public int Bonuses { get; set; } = DefaultBonusBalance;
    
    public virtual IList<Transaction> Transactions { get; set; }
    
    public virtual IList<Review> Reviews { get; set; }
    
    public virtual IList<Order> Orders { get; set; }

    /// <summary>
    /// Represents the customer's current status in the system.
    /// Indicates whether the customer is active, inactive, or banned.
    /// </summary>
    [Required(ErrorMessage = "Status is required.")]
    public CustomerStatus Status { get; set; } = DefaultCustomerStatus;
}

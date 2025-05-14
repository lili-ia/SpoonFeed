using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents the customer's profile.
/// </summary>
public class Customer : UserIdentity
{
    private const int DefaultBonusBalance = 0;
    private const CustomerStatus DefaultCustomerStatus = CustomerStatus.Active;
    
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
    [Required(ErrorMessage = "Bonuses are required")]
    public int Bonuses { get; set; } = DefaultBonusBalance;
    
    public virtual IList<Transaction> Transactions { get; set; }
    
    public virtual IList<Review> Reviews { get; set; }
    
    public virtual IList<Order> Orders { get; set; }

    /// <summary>
    /// Represents the customer's current status in the system.
    /// Indicates whether the customer is active, inactive, or banned.
    /// </summary>
    public CustomerStatus Status { get; set; } = DefaultCustomerStatus;
}
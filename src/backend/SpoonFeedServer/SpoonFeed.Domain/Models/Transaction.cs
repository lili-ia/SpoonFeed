using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class Transaction : BaseEntity
{
    public string Token { get; set; }
    
    public double Amount { get; set; }
    
    public Guid CurrencyId { get; set; }
    
    public virtual Currency Currency { get; set; }

    public TransactionStatus TransactionStatus { get; set; }
    
    public string PaymentMethod { get; set; }

    public TransactionType TransactionType { get; set; }
    
    public DateTime CreatedAt { get; set; }
    
    public DateTime UpdatedAt { get; set; }
}
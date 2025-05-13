using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class Customer : UserIdentity
{
    public string Address { get; set; }
    
    public DateOnly BirthDate { get; set; }
    
    public int Bonuses { get; set; }
    
    public virtual IList<Transaction> Transactions { get; set; }
    
    public virtual IList<Review> Reviews { get; set; }
    
    public virtual IList<Order> Orders { get; set; }
    
    public CustomerStatus CustomerStatus { get; set; }
}
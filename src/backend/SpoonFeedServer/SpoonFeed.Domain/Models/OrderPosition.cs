namespace SpoonFeed.Domain.Models;

public class OrderPosition : BaseEntity
{
    public Guid OrderId { get; set; }
    
    public virtual Order Order { get; set; }
    
    public int Quantity { get; set; }
    
    public double TotalPrice { get; set; }
    
    public Guid MenuItemId { get; set; }
    
    public virtual MenuItem MenuItem { get; set; }
}
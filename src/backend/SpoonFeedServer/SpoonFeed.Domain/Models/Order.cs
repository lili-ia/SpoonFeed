using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class Order : BaseEntity
{
    public DateTime AcceptedAt { get; set; }
    
    public OrderStatus OrderStatus { get; set; }
    
    public string DeliveryAddress { get; set; }
    
    public virtual IList<OrderPosition> OrderPositions { get; set; }
    
    public string PaymentMethod { get; set; }
    
    public DateTime ReceivedAt { get; set; }
    
    public DateTime DeliveredAt { get; set; }
    
    public Guid CustomerId { get; set; }
    
    public virtual Customer Customer { get; set; }
    
    public Guid CourierId { get; set; }
    
    public virtual Courier Courier { get; set; }
}
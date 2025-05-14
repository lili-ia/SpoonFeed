using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class Discount : BaseEntity
{
    public double Value { get; set; }
    
    public DiscountType DiscountType { get; set; }
    
    public DateTime? InvalidAt { get; set; }
}
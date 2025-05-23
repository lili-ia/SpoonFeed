using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.DTOs.Order;

public class OrderInfoDto
{
    public OrderStatus OrderStatus { get; set; } 
    public DateTime? DeliveredAt { get; set; }
    
    public OrderPaymentMethod? PaymentMethod { get; set; }

    public double Total { get; set; }
    
    public IList<OrderPositionDto> OrderPositions { get; set; } 
    
    public string DeliveryConfirmationCode { get; set; }
    
    public double? CourierLatitude { get; set; }
    
    public double? CourierLongitude { get; set; }
}
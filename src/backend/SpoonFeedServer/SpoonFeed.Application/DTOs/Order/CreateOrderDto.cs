using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Domain.Models;

namespace SpoonFeed.Application.DTOs.Order;

public class CreateOrderDto
{
    [Required(ErrorMessage = "DeliveryAddress is required.")]
    public string? DeliveryAddress { get; set; }
    
    public OrderPaymentMethod? PaymentMethod { get; set; }
    
    public virtual IList<OrderPosition> OrderPositions { get; set; } = [];
}
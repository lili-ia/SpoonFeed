using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.Order;

public class DeliveryCodeRequest
{
    [Required]
    [StringLength(4, MinimumLength = 4)]
    public string Code { get; set; }
}
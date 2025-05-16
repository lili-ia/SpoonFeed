using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.Order;

public class CreateOrderPositionDto
{
    [Required(ErrorMessage = "MenuItemId is required.")]
    public Guid MenuItemId { get; set; }

    [Required(ErrorMessage = "Quantity is required.")]
    [Range(1, int.MaxValue, ErrorMessage = "Quantity must be greater than 0.")]
    public int Quantity { get; set; }
}
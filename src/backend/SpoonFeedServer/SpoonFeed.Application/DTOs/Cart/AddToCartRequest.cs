using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.Cart;

public class AddToCartRequest
{
    [Required(ErrorMessage = "MenuItemId is required")]
    public Guid MenuItemId { get; set; }
    
    [Required(ErrorMessage = "Quantity is required")]
    [Range(1, 50, ErrorMessage = "Quantity must be between 1 and 50.")]
    public int Quantity { get; set; }
}
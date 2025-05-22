using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.Cart;

public class RemoveFromCartRequest
{
    [Required(ErrorMessage = "MenuItemId is required")]
    public Guid MenuItemId { get; set; }
}
namespace SpoonFeed.Application.DTOs.Cart;

public class CartItemDto
{
    public Guid MenuItemId { get; set; }
 
    public string Name { get; set; }
    
    public string Pic { get; set; }
    
    public int Quantity { get; set; }
}
namespace SpoonFeed.Domain.Enums;

public enum OrderStatus
{
    Pending,       
    Confirmed,     
    Preparing,     
    ReadyForPickup, 
    PickedUp,      
    Delivering,    
    Delivered,      
    Cancelled,     
    Failed         
}

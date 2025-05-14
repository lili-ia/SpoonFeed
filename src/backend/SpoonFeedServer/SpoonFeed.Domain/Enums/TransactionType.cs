namespace SpoonFeed.Domain.Enums;

public enum TransactionType
{
    Order, // customer -> foodfacility
    Delivery, // customer -> courier
    Refund, // foodfacility -> customer
    Tip // customer -> courier
}

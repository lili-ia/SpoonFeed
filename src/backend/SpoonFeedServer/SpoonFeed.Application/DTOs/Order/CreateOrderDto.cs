using System.ComponentModel.DataAnnotations;
using SpoonFeed.Application.DTOs.Shared;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.DTOs.Order;

public class CreateOrderDto : IValidatableObject
{
    [Required(ErrorMessage = "DeliveryAddress is required.")]
    public AddressDto? DeliveryAddress { get; set; }

    [Required(ErrorMessage = "PaymentMethod is required.")]
    public OrderPaymentMethod? PaymentMethod { get; set; }

    [Required(ErrorMessage = "Order must contain at least one item.")]
    public IList<CreateOrderPositionDto> OrderPositions { get; set; } = [];

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        if (PaymentMethod != null && !Enum.IsDefined(typeof(OrderPaymentMethod), PaymentMethod))
        {
            yield return new ValidationResult(
                $"{PaymentMethod} is not a valid payment method.",
                [nameof(PaymentMethod)]);
        }

        if (OrderPositions == null || OrderPositions.Count == 0)
        {
            yield return new ValidationResult(
                "Order must contain at least one item.",
                [nameof(OrderPositions)]);
        }
    }
}

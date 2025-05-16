using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.Order;

public class AddressDto : IValidatableObject
{
    [MaxLength(255)]
    public string Street { get; set; } = null!;

    [MaxLength(100)]
    public string City { get; set; } = null!;

    [MaxLength(100)]
    public string StateOrRegion { get; set; } = null!;

    [MaxLength(20)]
    public string PostalCode { get; set; } = null!;

    public double? Latitude { get; set; }
    
    public double? Longitude { get; set; }
    
    
    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        bool hasCoordinates = Latitude.HasValue && Longitude.HasValue;
        bool hasAddressFields = !string.IsNullOrWhiteSpace(Street)
                                && !string.IsNullOrWhiteSpace(City)
                                && !string.IsNullOrWhiteSpace(StateOrRegion)
                                && !string.IsNullOrWhiteSpace(PostalCode);

        if (!hasCoordinates && !hasAddressFields)
        {
            yield return new ValidationResult(
                "Either Latitude and Longitude must be provided, or all address fields (Street, City, StateOrRegion, PostalCode) must be filled.",
                new[] { nameof(Latitude), nameof(Longitude), nameof(Street), nameof(City), nameof(StateOrRegion), nameof(PostalCode) });
        }
    }
}
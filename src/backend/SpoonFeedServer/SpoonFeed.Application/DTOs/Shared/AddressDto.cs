using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.Shared;

public class AddressDto
{
    [MinLength(1, ErrorMessage = "Street field length must be at least 1")]
    [MaxLength(255, ErrorMessage = "Street field length must be max 255")]
    public string Street { get; set; } = null!;

    [MinLength(1,  ErrorMessage = "City field length must be at least 1")]
    [MaxLength(255, ErrorMessage = "City field length must be max 255")]
    public string City { get; set; } = null!;
    
    [MinLength(4,  ErrorMessage = "City field length must be at least 4")]
    [MaxLength(20, ErrorMessage = "PostalCode field length must be max 20")]
    public string PostalCode { get; set; } = null!;

    public double? Latitude { get; set; }
    
    public double? Longitude { get; set; }
}
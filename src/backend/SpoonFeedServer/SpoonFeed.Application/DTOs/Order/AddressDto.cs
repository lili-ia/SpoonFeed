using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.Order;

public class AddressDto
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
}
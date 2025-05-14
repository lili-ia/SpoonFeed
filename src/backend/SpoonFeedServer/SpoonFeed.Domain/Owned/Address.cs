using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace SpoonFeed.Domain.Owned;

/// <summary>
/// Represents address data.
/// </summary>
[Owned]
public class Address
{
    [Required]
    [MaxLength(255)]
    public string Street { get; set; }

    [Required]
    [MaxLength(100)]
    public string City { get; set; }

    [Required]
    [MaxLength(100)]
    public string StateOrRegion { get; set; }

    [Required]
    [MaxLength(20)]
    public string PostalCode { get; set; }

    [Required]
    [MaxLength(100)]
    public string Country { get; set; }

    public double? Latitude { get; set; }
    public double? Longitude { get; set; }
}
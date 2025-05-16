using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents currency-related data.
/// Uses standard ISO 4217
/// </summary>
public class Currency : BaseEntity
{
    /// <summary>
    /// Represents the fully qualified currency name, like "Euro", "Ukrainian Hryvnia", etc.
    /// </summary>
    [Required(ErrorMessage = "Name is required.")]
    [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters.")]
    public string Name { get; set; } = string.Empty;
    
    /// <summary>
    /// Represents the standard currency code, like "UAH", "USD", etc.
    /// </summary>
    [Required(ErrorMessage = "Code is required.")]
    [StringLength(10, ErrorMessage = "Code cannot exceed 10 characters.")]
    public string Code { get; set; } = string.Empty;

    /// <summary>
    /// Represents the symbol of the currency, such as "$", "NZ$", etc.
    /// </summary>
    [Required(ErrorMessage = "Symbol is required.")]
    [StringLength(5, ErrorMessage = "Symbol cannot exceed 5 characters.")]
    public string Symbol { get; set; } = string.Empty;
}
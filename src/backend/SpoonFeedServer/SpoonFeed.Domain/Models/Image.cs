using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents an image entity within the domain.
/// </summary>
public class Image : BaseEntity
{
    /// <summary>
    /// Represents the name of the image.
    /// Often used as alt name in client apps.
    /// </summary>
    [Required(ErrorMessage = "Title is required.")]
    public string Title { get; set; } = string.Empty;
    
    /// <summary>
    /// Represents the resource location.
    /// </summary>
    [Required(ErrorMessage = "Url is required.")]
    public string Url { get; set; } = string.Empty;
}
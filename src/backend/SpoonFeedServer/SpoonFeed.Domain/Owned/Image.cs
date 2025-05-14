using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace SpoonFeed.Domain.Owned;

/// <summary>
/// Represents an image entity within the domain.
/// </summary>
[Owned]
public class Image
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
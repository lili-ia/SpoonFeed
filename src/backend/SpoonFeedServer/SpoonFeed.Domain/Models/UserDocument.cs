using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

/// <summary>
/// Represents user's document blobs
/// </summary>
public class UserDocument : BaseEntity
{
    private const DocumentStatus DefaultDocumentStatus = DocumentStatus.Pending;
    
    /// <summary>
    /// Represents the kind of document.
    /// </summary>
    [Required(ErrorMessage = "DocumentType is required.")]
    public DocumentType DocumentType { get; set; }
    
    /// <summary>
    /// Represents the timestamp when the document was added.
    /// Set by database. 
    /// </summary>
    [Required(ErrorMessage = "CreatedAt is required.")]
    public DateTime CreatedAt { get; set; }
    
    /// <summary>
    /// Represents the timestamp when the document was changed.
    /// Set by database.
    /// </summary>
    [Required(ErrorMessage = "UpdatedAt is required.")]
    public DateTime UpdatedAt { get; set; }
    
    [Required(ErrorMessage = "Owner is required.")]
    public Guid OwnerId { get; set; }
    
    /// <summary>
    /// Represents the document's owner.
    /// </summary>
    public UserIdentity Owner { get; set; } = null!;

    /// <summary>
    /// Represents the current status of document approval.
    /// </summary>
    [Required(ErrorMessage = "DocumentStatus is required.")]
    public DocumentStatus DocumentStatus { get; set; } = DefaultDocumentStatus;
    
    /// <summary>
    /// Represents the resource location.
    /// </summary>
    [Required(ErrorMessage = "Url is required.")]
    public string Url { get; set; } = string.Empty;
}
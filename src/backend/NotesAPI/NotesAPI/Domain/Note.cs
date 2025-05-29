using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace NotesAPI.Domain;

public class Note
{
    [Required]
    public int Id { get; set; }
    
    [Required]
    public string Title { get; set; }
    
    [Required]
    public string Content { get; set; }

    [Required] 
    public DateTime CreationDate { get; set; } = DateTime.UtcNow;
    
    [Required]
    public int UserId { get; set; }
}
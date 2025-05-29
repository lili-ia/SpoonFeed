using System.ComponentModel.DataAnnotations;

namespace NotesAPI.Domain;

public class User
{
    [Required]
    public int Id { get; set; }
    
    [Required]
    public string Name { get; set; }
    
    [Required]
    [EmailAddress]
    public string Email { get; set; }
}
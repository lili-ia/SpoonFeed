using System.ComponentModel.DataAnnotations;

namespace NotesAPI.ViewModels;

public class NoteViewModel
{
    [Required(ErrorMessage = "Title is required")]
    [Length(1, 200, ErrorMessage = "Title must be between 1 and 200 symbols")]
    public string Title { get; set; }
    
    [Required(ErrorMessage = "Content is required")]
    [Length(1, int.MaxValue, ErrorMessage = "Content must be at least 1 symbol")]
    public string Content { get; set; }
    
    [Required(ErrorMessage = "UserId is required")]
    public int UserId { get; set; }
}
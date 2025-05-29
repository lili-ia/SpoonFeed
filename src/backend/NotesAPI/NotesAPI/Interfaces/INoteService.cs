using NotesAPI.Domain;
using NotesAPI.Services;
using NotesAPI.ViewModels;

namespace NotesAPI.Interfaces;

public interface INoteService
{
    Task<Result<bool>> AddNoteAsync(NoteViewModel model);

    Task<Result<Note>> UpdateNoteAsync(NoteViewModel model, int noteId);

    Task<Result<bool>> DeleteNoteAsync(int noteId);

    Task<Result<List<Note>>> GetUserNotesAsync(int userId);
    
    public event NoteEventHandler NoteAdded;
    
    public event NoteEventHandler NoteDeleted;
}
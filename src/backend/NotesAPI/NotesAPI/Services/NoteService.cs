using NotesAPI.Domain;
using NotesAPI.Interfaces;
using NotesAPI.ViewModels;

namespace NotesAPI.Services;

public class NoteService : INoteService
{
    public event NoteEventHandler NoteAdded;
    
    public event NoteEventHandler NoteDeleted;

    private ILogger<NoteService> _logger;
    private MemoryStorage _memoryStorage;
    
    public NoteService(MemoryStorage memoryStorage, ILogger<NoteService> logger)
    {
        _memoryStorage = memoryStorage;
        _logger = logger;
    }

    public async Task<Result<bool>> AddNoteAsync(NoteViewModel model)
    {
        var userExists = _memoryStorage.Users.Any(u => u.Id == model.UserId);

        if (!userExists)
        {
            return Result<bool>.Failure("User not found");
        }

        var note = new Note
        {
            Id = _memoryStorage.NextNoteId,
            Title = model.Title,
            Content = model.Content,
            CreationDate = DateTime.UtcNow,
            UserId = model.UserId
        };
        
        _memoryStorage.NextNoteId++;
        _memoryStorage.Notes.Add(note);
        OnNoteAdded();

        return Result<bool>.Success(true);
    }

    public async Task<Result<Note>> UpdateNoteAsync(NoteViewModel model, int noteId)
    {
        var userExists = _memoryStorage.Users.Any(u => u.Id == model.UserId);

        if (!userExists)
        {
            return Result<Note>.Failure("User not found");
        }

        var note = _memoryStorage.Notes.FirstOrDefault(n => n.Id == noteId);

        if (note == null)
        {
            return Result<Note>.Failure("Note not found");
        }
        
        note.Content = model.Content;
        note.Title = model.Title;
        
        return Result<Note>.Success(note);
    }

    public async Task<Result<bool>> DeleteNoteAsync(int noteId)
    {
        var note = _memoryStorage.Notes.FirstOrDefault(n => n.Id == noteId);

        if (note == null)
        {
            return Result<bool>.Failure("Note not found");
        }

        _memoryStorage.Notes.Remove(note);
        OnNoteDeleted();
        
        return Result<bool>.Success(true);
    }

    public async Task<Result<List<Note>>> GetUserNotesAsync(int userId)
    {
        var userExists = _memoryStorage.Users.Any(u => u.Id == userId);

        if (!userExists)
        {
            return Result<List<Note>>.Failure("User not found");
        }

        var notes = _memoryStorage.Notes
            .Where(n => n.UserId == userId)
            .ToList();
        
        return Result<List<Note>>.Success(notes);
    }

    void OnNoteAdded()
    {
        _logger.LogInformation("OnNoteAdded executed");
        NoteAdded?.Invoke(this, EventArgs.Empty);
    }

    void OnNoteDeleted()
    {
        _logger.LogInformation("OnNoteDeleted executed");
        NoteDeleted?.Invoke(this, EventArgs.Empty);
    }
}


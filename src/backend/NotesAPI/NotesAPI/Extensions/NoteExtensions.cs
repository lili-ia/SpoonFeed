using NotesAPI.Domain;

namespace NotesAPI.Extensions;

public static class NoteExtensions
{
    public static List<Note> SortByCreationDate(this List<Note> notes)
    {
        return notes.OrderBy(n => n.CreationDate).ToList();
    }
}
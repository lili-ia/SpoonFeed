using Microsoft.AspNetCore.Mvc;
using NotesAPI.Interfaces;
using NotesAPI.ViewModels;

namespace NotesAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class NotesController : ControllerBase
{
    private readonly INoteService _noteService;
    
    public NotesController(INoteService noteService)
    {
        _noteService = noteService;
    }

    [HttpPost("add")]
    public async Task<IActionResult> AddAsync([FromBody] NoteViewModel model)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var result = await _noteService.AddNoteAsync(model);

        if (!result.IsSuccess)
        {
            return NotFound(result.Error);
        }

        return Ok("Task successfully created");
    }
    
    [HttpPut("update/{noteId}")]
    public async Task<IActionResult> UpdateAsync([FromBody] NoteViewModel model, [FromRoute] int noteId)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var result = await _noteService.UpdateNoteAsync(model, noteId);

        if (!result.IsSuccess)
        {
            return NotFound(result.Error);
        }

        return Ok(result.Value);
    }

    [HttpDelete("delete/{noteId}")]
    public async Task<IActionResult> DeleteAsync([FromRoute] int noteId)
    {
        var result = await _noteService.DeleteNoteAsync(noteId);

        if (!result.IsSuccess)
        {
            return NotFound(result.Error);
        }
        
        return Ok("Task successfully deleted");
    }

    [HttpGet("{userId}")]
    public async Task<IActionResult> GetUserNotesAsync([FromRoute] int userId)
    {
        var result = await _noteService.GetUserNotesAsync(userId);

        if (!result.IsSuccess)
        {
            return NotFound(result.Error);
        }
        
        return Ok(result.Value);
    }
}
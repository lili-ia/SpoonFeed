using Microsoft.AspNetCore.Mvc;
using NotesAPI.Interfaces;
using NotesAPI.ViewModels;

namespace NotesAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class UsersController : ControllerBase
{
    private readonly IUserService _userService;
    
    public UsersController(IUserService userService)
    {
        _userService = userService;
    }

    [HttpPost("add")]
    public async Task<IActionResult> AddAsync([FromBody] UserViewModel model)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var result = await _userService.AddUserAsync(model);

        if (!result.IsSuccess)
        {
            return NotFound(result.Error);
        }

        return Ok("User successfully added");
    }

    [HttpPut("update/{userId}")]
    public async Task<IActionResult> UpdateAsync([FromBody] UserViewModel model, [FromRoute] int userId)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        var result = await _userService.UpdateUserAsync(model, userId);
        
        if (!result.IsSuccess)
        {
            return NotFound(result.Error);
        }

        return Ok(result.Value);
    }

    [HttpDelete("delete/{userId}")]
    public async Task<IActionResult> DeleteAsync([FromRoute] int userId)
    {
        var result = await _userService.DeleteUserAsync(userId);
        
        if (!result.IsSuccess)
        {
            return NotFound(result.Error);
        }

        return Ok("User successfully deleted");
    }
}
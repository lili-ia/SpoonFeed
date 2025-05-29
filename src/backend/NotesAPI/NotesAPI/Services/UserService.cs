using NotesAPI.Domain;
using NotesAPI.Interfaces;
using NotesAPI.ViewModels;

namespace NotesAPI.Services;

public class UserService : IUserService
{
    private MemoryStorage _memoryStorage;
    
    public UserService(MemoryStorage memoryStorage)
    {
        _memoryStorage = memoryStorage;
    }
    
    public async Task<Result<bool>> AddUserAsync(UserViewModel model)
    {
        var user = new User
        {
            Id = _memoryStorage.NextUserId,
            Name = model.Name,
            Email = model.Email
        };
        
        _memoryStorage.NextUserId++;
        _memoryStorage.Users.Add(user);
        
        return Result<bool>.Success(true);
    }

    public async Task<Result<User>> UpdateUserAsync(UserViewModel model, int userId)
    {
        var user = _memoryStorage.Users.FirstOrDefault(u => u.Id == userId);

        if (user == null)
        {
            return Result<User>.Failure("User not found");
        }

        user.Email = model.Email;
        user.Name = model.Name;
        
        return Result<User>.Success(user);
    }
    
    public async Task<Result<bool>> DeleteUserAsync(int userId)
    {
        var user = _memoryStorage.Users.FirstOrDefault(u => u.Id == userId);

        if (user == null)
        {
            return Result<bool>.Failure("User not found");
        }

        _memoryStorage.Users.Remove(user);
        
        return Result<bool>.Success(true);
    }
}
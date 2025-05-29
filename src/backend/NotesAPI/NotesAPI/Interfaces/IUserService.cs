using NotesAPI.Domain;
using NotesAPI.ViewModels;

namespace NotesAPI.Interfaces;

public interface IUserService
{
    Task<Result<bool>> AddUserAsync(UserViewModel model);

    Task<Result<User>> UpdateUserAsync(UserViewModel model, int userId);

    Task<Result<bool>> DeleteUserAsync(int userId);
}
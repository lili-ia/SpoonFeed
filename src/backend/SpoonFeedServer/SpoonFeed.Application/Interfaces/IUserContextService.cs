namespace SpoonFeed.Application.Interfaces;

public interface IUserContextService
{
    Guid GetUserId();

    string GetUserEmail();

    string? GetUserRole();
}
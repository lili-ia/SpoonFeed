namespace SpoonFeed.Application.Interfaces;

public interface IJwtService
{
    public string GenerateJwtToken(string userId, string email, string role);
    
    // todo: refresh tokens
}
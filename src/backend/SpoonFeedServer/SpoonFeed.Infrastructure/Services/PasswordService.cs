
using System.Security.Cryptography;
using SpoonFeed.Application.Interfaces;

namespace SpoonFeed.Infrastructure.Services;

public class PasswordService : IPasswordService
{
    private const int SaltSize = 16; 
    private const int KeySize = 32; 
    private const int Iterations = 100_000;
    private const char Delimiter = ';';
    
    public PasswordService()
    {
        
    }
    
    public string HashPassword(string password)
    {
        using var rng = RandomNumberGenerator.Create();
        var salt = new byte[SaltSize];
        rng.GetBytes(salt);
        
        var key = new Rfc2898DeriveBytes(
            password, salt, Iterations, HashAlgorithmName.SHA256).GetBytes(KeySize);
        
        return $"{Convert.ToBase64String(salt)}{Delimiter}{Convert.ToBase64String(key)}";
        
    }

    public bool VerifyPassword(string hashedPassword, string rawPassword)
    {
        var parts = hashedPassword.Split(Delimiter);
        if (parts.Length != 2)
            return false;

        var salt = Convert.FromBase64String(parts[0]);
        var key = Convert.FromBase64String(parts[1]);

        var attemptedKey = new Rfc2898DeriveBytes(rawPassword, salt, Iterations, HashAlgorithmName.SHA256).GetBytes(KeySize);

        return CryptographicOperations.FixedTimeEquals(key, attemptedKey);
    }
}
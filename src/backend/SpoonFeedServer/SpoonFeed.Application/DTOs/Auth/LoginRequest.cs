using System.ComponentModel.DataAnnotations;

namespace SpoonFeed.Application.DTOs.Auth;

public record LoginRequest(
    [Required]
    [EmailAddress]
    string Email,
    [Required]
    [StringLength(50, MinimumLength = 6)]
    string Password);
using System.ComponentModel.DataAnnotations;
using SpoonFeed.Application.DTOs.Shared;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Domain.Owned;

namespace SpoonFeed.Application.DTOs.Auth;

public record FoodFacilityRegisterRequest(
    [Required] [EmailAddress] string Email,
    [Required] string Password,
    [Required] string PhoneNumber,
    string? FirstName,
    string? LastName,
    DateOnly? BirthDate,
    [Required] Role UserType,
    [Required] AddressDto AddressDto,
    [Required] string Name,
    WorkingHours? WorkingHours
) : RegisterUserRequest(Email, Password, PhoneNumber, FirstName, LastName, BirthDate, UserType);

using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.DTOs.Menu;

public record MenuItemCreateRequest(
    [Required, MinLength(2), StringLength(100)]
    string Name,
    [Required]
    string Ingredients,
    MenuItemStatus Status,
    [Required, Range(0, double.MaxValue)]
    double Price,
    [Required]
    Guid CurrencyId,
    [Required]
    Guid FoodFacilityId,
    Guid? MenuItemCategoryId,
    [Required, Range(0, int.MaxValue)]
    int Weight,
    [Required]
    Guid ImageId);

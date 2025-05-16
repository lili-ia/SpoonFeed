using System.ComponentModel.DataAnnotations;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.DTOs.Menu;

public record MenuItemUpdateRequest(
    [Required(ErrorMessage = "Id is required.")]
    Guid Id,
    [Required(ErrorMessage = "Name is required.")]
    [MinLength(2, ErrorMessage = "The name of menu item should be at least 2 characters long.")]
    [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters.")]
    string Name,
    [Required(ErrorMessage = "Ingredients is required.")]
    string Ingredients,
    MenuItemStatus Status,
    [Required(ErrorMessage = "Price is required.")]
    [Range(0, double.MaxValue, ErrorMessage = "Price cannot be negative.")]
    double Price,
    [Required(ErrorMessage = "CurrencyId is required.")]
    Guid CurrencyId,
    [Required(ErrorMessage = "FoodFacilityId is required.")]
    Guid FoodFacilityId,
    Guid? MenuItemCategoryId,
    [Required(ErrorMessage = "Weight is required.")]
    [Range(0, int.MaxValue, ErrorMessage = "Weight cannot be negative.")]
    int Weight,
    [Required(ErrorMessage = "ImageId is required.")]
    Guid ImageId
) : MenuItemCreateRequest(Name, Ingredients, Status, Price, CurrencyId, FoodFacilityId, MenuItemCategoryId, Weight, ImageId);
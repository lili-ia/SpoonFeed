using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Application.DTOs.Menu;

public record MenuItemResponse(
    Guid Id,
    string Name,
    string Ingredients,
    MenuItemStatus Status,
    double Price,
    CurrencyCode CurrencyCode,
    Guid FoodFacilityId,
    string FoodFacilityName,
    Guid? MenuItemCategoryId,
    string? CategoryName,
    int Weight,
    Guid ImageId,
    string ImageUrl);

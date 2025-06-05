using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SpoonFeed.Application.DTOs.Menu;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Models;
using SpoonFeed.Persistence;

namespace SpoonFeed.Application.Services;

public class MenuService : IMenuService
{
    private readonly SpoonFeedDbContext _dbContext;
    private readonly ILogger<MenuService> _logger;

    public MenuService(SpoonFeedDbContext dbContext, ILogger<MenuService> logger)
    {
        _dbContext = dbContext;
        _logger = logger;
    }

    public async Task<Result<MenuItemResponse>> GetByIdAsync(Guid itemId, Guid facilityId, CancellationToken ct)
    {
        var menuItem = await _dbContext.MenuItems
            .Include(x => x.FoodFacility)
            .Include(x => x.MenuItemCategory)
            .Include(x => x.Image)
            .FirstOrDefaultAsync(x => x.Id == itemId && x.FoodFacilityId == facilityId, ct);
        if (menuItem == null)
        {
            return Result<MenuItemResponse>.FailureResult("Menu item does not exist.");
        }

        var response = new MenuItemResponse(
            Id: menuItem.Id,
            Name: menuItem.Name,
            Ingredients: menuItem.Ingredients,
            Status: menuItem.Status,
            Price: menuItem.Price,
            CurrencyCode: menuItem.CurrencyCode,
            FoodFacilityId: menuItem.FoodFacilityId,
            FoodFacilityName: menuItem.FoodFacility.Name,
            MenuItemCategoryId: menuItem.MenuItemCategoryId,
            CategoryName: menuItem.MenuItemCategory?.Name,
            Weight: menuItem.Weight,
            ImageId: menuItem.ImageId,
            ImageUrl: menuItem.Image.Url
        );

        return Result<MenuItemResponse>.SuccessResult(response);
    }

    public async Task<Result<IEnumerable<MenuItemResponse>>> GetByFacilityAsync(Guid foodFacilityId,
        CancellationToken ct)
    {
        var menuItems = await _dbContext.MenuItems
            .Where(x => x.FoodFacilityId == foodFacilityId)
            .Include(x => x.FoodFacility)
            .Include(x => x.MenuItemCategory)
            .Include(x => x.Image)
            .ToListAsync(ct);

        var response = menuItems.Select(mi => new MenuItemResponse(
            Id: mi.Id,
            Name: mi.Name,
            Ingredients: mi.Ingredients,
            Status: mi.Status,
            Price: mi.Price,
            CurrencyCode: mi.CurrencyCode,
            FoodFacilityId: mi.FoodFacilityId,
            FoodFacilityName: mi.FoodFacility.Name,
            MenuItemCategoryId: mi.MenuItemCategoryId,
            CategoryName: mi.MenuItemCategory?.Name,
            Weight: mi.Weight,
            ImageId: mi.ImageId,
            ImageUrl: mi.Image.Url
        ));

        return Result<IEnumerable<MenuItemResponse>>.SuccessResult(response);
    }

    public async Task<Result<Guid>> CreateAsync(Guid foodFacilityId, MenuItemCreateRequest request, CancellationToken ct)
    {
        var item = new MenuItem()
        {
            Name = request.Name,
            Ingredients = request.Ingredients,
            Price = request.Price,
            CurrencyCode = request.CurrencyCode,
            FoodFacilityId = foodFacilityId,
            MenuItemCategoryId = request.MenuItemCategoryId,
            Weight = request.Weight,
            ImageId = request.ImageId
        };
        try
        {
            await _dbContext.MenuItems.AddAsync(item, ct);
            await _dbContext.SaveChangesAsync(ct);
            return Result<Guid>.SuccessResult(item.Id);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error occurred in {Method}", nameof(CreateAsync));
            return Result<Guid>.FailureResult(
                "An internal error occured while trying to post a menu item.", ErrorType.ServerError);
        }
    }

    public async Task<Result<bool>> UpdateAsync(Guid foodFacilityId, MenuItemUpdateRequest request, CancellationToken ct)
    {
        var item = await _dbContext.MenuItems.FindAsync([request.Id], ct);
        if (item == null)
        {
            return Result<bool>.FailureResult("Menu item does not exist.");
        }

        item.Name = request.Name;
        item.Ingredients = request.Ingredients;
        item.Status = request.Status;
        item.Price = request.Price;
        item.CurrencyCode = request.CurrencyCode;
        item.FoodFacilityId = request.FoodFacilityId;
        item.MenuItemCategoryId = request.MenuItemCategoryId;
        item.Weight = request.Weight;
        item.ImageId = request.ImageId;
        try
        {
            await _dbContext.SaveChangesAsync(ct);
            return Result<bool>.SuccessResult(true);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error occurred in {Method}", nameof(CreateAsync));
            return Result<bool>.FailureResult(
                "An internal error occured while trying to update a menu item.", ErrorType.ServerError);
        }
    }

    public async Task<Result<bool>> DeleteAsync(Guid foodFacilityId, Guid id, CancellationToken ct)
    {
        var item = await _dbContext.MenuItems.FindAsync([id], ct);
        if (item == null)
        {
            return Result<bool>.FailureResult("Menu item does not exist.");
        }

        try
        {
            _dbContext.MenuItems.Remove(item);
            await _dbContext.SaveChangesAsync(ct);
            return Result<bool>.SuccessResult(true);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error occurred in {Method}", nameof(CreateAsync));
            return Result<bool>.FailureResult(
                "An internal error occured while trying to delete a menu item.", ErrorType.ServerError);
        }
    }

    public async Task<Result<bool>> ExistsAsync(Guid itemId, CancellationToken ct)
    {
        var exists = await _dbContext.MenuItems.AnyAsync(x => x.Id == itemId, ct);
        return Result<bool>.SuccessResult(exists);
    }

    public async Task<Result<bool>> CreateMenuItemCategoryAsync(CreateItemCategoryRequest request, Guid foodFacilityId, CancellationToken ct)
    {
        var category = new MenuItemCategory
        {
            Id = Guid.NewGuid(),
            Name = request.Name,
            FoodFacilityId = foodFacilityId
        };

        try
        {
            await _dbContext.MenuItemCategories.AddAsync(category, ct);
            await _dbContext.SaveChangesAsync(ct);
            
            return Result<bool>.SuccessResult(true);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error occurred in {Method}", nameof(CreateAsync));
            
            return Result<bool>.FailureResult(
                "An internal error occured while trying to create a menu item category.", ErrorType.ServerError);
        }
    }
}
using System.Globalization;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SpoonFeed.Application.DTOs.FoodFacility;
using SpoonFeed.Application.DTOs.Shared;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Domain.Models;
using SpoonFeed.Domain.Owned;
using SpoonFeed.Persistence;
using DayOfWeek = System.DayOfWeek;

namespace SpoonFeed.Application.Services;

public class FoodFacilityService : IFoodFacilityService
{
    private readonly SpoonFeedDbContext _db;
    private readonly ILogger<FoodFacilityService> _logger;
    private readonly IMapper _mapper;
    
    public FoodFacilityService(SpoonFeedDbContext db, ILogger<FoodFacilityService> logger, IMapper mapper)
    {
        _db = db;
        _logger = logger;
        _mapper = mapper;
    }
    
    public async Task<Result<bool>> ConfirmPickupAsync(
        Guid facilityId, 
        Guid orderId, 
        IList<Guid> orderPositionsIds,
        CancellationToken ct)
    {
        var positions = await _db.OrderPositions
            .Where(op => op.OrderId == orderId
                         && orderPositionsIds.Contains(op.Id)
                         && op.MenuItem.FoodFacilityId == facilityId)
            .ToListAsync(ct);

        if (positions.Count == 0)
        {
            return Result<bool>.FailureResult("No matching positions found", ErrorType.NotFound);
        }

        foreach (var op in positions)
        {
            op.PickupStatus = OrderPositionPickupStatus.PickedUp;
        }

        try
        {
            _db.OrderPositions.UpdateRange(positions);
            await _db.SaveChangesAsync(ct);
        }
        catch (Exception e)
        {
            _logger.LogError(e.Message);
            
            return Result<bool>.FailureResult("An internal error occured", ErrorType.ServerError);
        }
        
        return Result<bool>.SuccessResult(true);
    }

    public async Task<Result<GetFoodFacilityInfoResponse>> GetFacilityInfoAsync(Guid facilityId)
    {
        var facility = await _db.FoodFacilities
            .Include(ff => ff.UserIdentity)
            .Include(ff => ff.UserIdentity.ProfilePic)
            .FirstOrDefaultAsync(u => u.UserIdentityId == facilityId);

        if (facility == null)
        {
            return Result<GetFoodFacilityInfoResponse>
                .FailureResult("Food Facility not found", ErrorType.NotFound);
        }

        var response = new GetFoodFacilityInfoResponse
        {
            AddressDto = _mapper.Map<AddressDto>(facility.Address),
            PhoneNumber = facility.UserIdentity.PhoneNumber,
            FirstName = facility.UserIdentity.FirstName,
            LastName = facility.UserIdentity.LastName,
            FacilityName = facility.Name,
            PicUrl = facility.UserIdentity.ProfilePic?.Url ?? ""
        };

        return Result<GetFoodFacilityInfoResponse>.SuccessResult(response);
    }

    public async Task<Result<bool>> UpdateFacilityInfoAsync(Guid facilityId, UpdateFoodFacilityInfoRequest request)
    {
        var facility = await _db.FoodFacilities
            .Include(ff => ff.UserIdentity)
            .ThenInclude(ui => ui.ProfilePic)
            .FirstOrDefaultAsync(u => u.UserIdentityId == facilityId);

        if (facility == null)
        {
            return Result<bool>.FailureResult("Food Facility not found", ErrorType.NotFound);
        }

        facility.Address = _mapper.Map<Address>(request.AddressDto);
        facility.UserIdentity.PhoneNumber = request.PhoneNumber;
        facility.UserIdentity.FirstName = request.FirstName;
        facility.UserIdentity.LastName = request.LastName;
        facility.Name = request.FacilityName;

        var currentPic = facility.UserIdentity.ProfilePic;
        var newPicUrl = request.PicUrl?.Trim();

        if (!string.IsNullOrEmpty(newPicUrl))
        {
            if (currentPic == null || currentPic.Url != newPicUrl)
            {
                var newPic = new Image
                {
                    Id = Guid.NewGuid(),
                    Url = newPicUrl,
                    Title = $"{facility.Name} profile pic"
                };

                if (currentPic != null)
                {
                    _db.Images.Remove(currentPic);
                }

                await _db.Images.AddAsync(newPic);
                facility.UserIdentity.ProfilePicId = newPic.Id;
            }
        }
        else if (currentPic != null && string.IsNullOrEmpty(newPicUrl))
        {
            _db.Images.Remove(currentPic);
            facility.UserIdentity.ProfilePicId = null;
        }

        try
        {
            await _db.SaveChangesAsync();
            
            return Result<bool>.SuccessResult(true);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error updating food facility info");
            
            return Result<bool>.FailureResult("Internal error occurred", ErrorType.ServerError);
        }
    }

    public async Task<Result<bool>> UpdateWorkingHoursAsync(Guid facilityId, FacilityWorkingHoursUpdateDto dto)
    {
        var facility = await _db.FoodFacilities
            .Include(f => f.WorkingHours)
            .FirstOrDefaultAsync(f => f.UserIdentityId == facilityId);

        if (facility == null)
        {
            return Result<bool>.FailureResult("Food Facility not found", ErrorType.NotFound);
        }

        _db.WorkingHours.RemoveRange(facility.WorkingHours);

        const string timeFormat = "HH:mm";           // 09:30
        var newHours = new List<FacilityWorkingHour>();

        foreach (var d in dto.Days)
        {
            if (!TimeOnly.TryParseExact(d.OpenTime, timeFormat, null,
                    DateTimeStyles.None, out var open) ||
                !TimeOnly.TryParseExact(d.CloseTime, timeFormat, null,
                    DateTimeStyles.None, out var close))
            {
                return Result<bool>.FailureResult(
                    $"Invalid time for {d.Day}. Expected {timeFormat}.", ErrorType.Validation);
            }

            if (d.IsOpen && open >= close)
            {
                return Result<bool>.FailureResult(
                    $"For {d.Day} open time must be earlier than close time.",
                    ErrorType.Validation);
            }

            newHours.Add(new FacilityWorkingHour
            {
                Id             = Guid.NewGuid(),
                FoodFacilityId = facility.UserIdentityId,
                Day            = d.Day,
                IsOpen         = d.IsOpen,
                OpenTime       = open,
                CloseTime      = close
            });
        }

        await _db.WorkingHours.AddRangeAsync(newHours);

        try
        {
            await _db.SaveChangesAsync();
        }
        catch (Exception e)
        {
            _logger.LogError(e.Message);
            
            return Result<bool>.FailureResult("An internal error occured", ErrorType.ServerError);
        }

        return Result<bool>.SuccessResult(true);
    }

    public async Task<Result<List<FacilityWorkingHoursGetDto>>> GetWorkingHoursAsync(Guid facilityId)
    {
        var hours = await _db.WorkingHours
            .Where(fh => fh.FoodFacilityId == facilityId)
            .OrderBy(fh => fh.Day)
            .ToListAsync();

        if (hours == null || !hours.Any())
        {
            var defaultHours = Enum.GetValues<DayOfWeek>()
                .Select(day => new FacilityWorkingHoursGetDto
                {
                    Day = day,
                    IsOpen = false,
                    OpenTime = new TimeOnly(0, 0),       
                    CloseTime = new TimeOnly(23, 59)   
                })
                .ToList();

            var entitiesToAdd = defaultHours.Select(d => new FacilityWorkingHour
            {
                FoodFacilityId = facilityId,
                Day = d.Day,
                IsOpen = d.IsOpen,
                OpenTime = d.OpenTime,
                CloseTime = d.CloseTime
            }).ToList();

            _db.WorkingHours.AddRange(entitiesToAdd);
            await _db.SaveChangesAsync();

            return Result<List<FacilityWorkingHoursGetDto>>.SuccessResult(defaultHours);
        }

        var dtoList = hours.Select(h => new FacilityWorkingHoursGetDto
        {
            Day = h.Day,
            IsOpen = h.IsOpen,
            OpenTime = h.OpenTime,
            CloseTime = h.CloseTime
        }).ToList();

        return Result<List<FacilityWorkingHoursGetDto>>.SuccessResult(dtoList);
    }

}
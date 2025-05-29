using Microsoft.EntityFrameworkCore;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Domain.Models;
using SpoonFeed.Persistence;

namespace SpoonFeed.Infrastructure.Services;

public class CourierSelector : ICourierSelector
{
    private readonly SpoonFeedDbContext _db;
    
    public CourierSelector(SpoonFeedDbContext db)
    {
        _db = db;
    }
    
    public async Task<Courier?> FindBestCourierAsync(
        Order order, 
        CancellationToken ct, 
        IEnumerable<Guid> excludedCourierIds)
    {
        var foodFacilitiesIds =  order.OrderPositions
            .Select(op => op.MenuItem.FoodFacilityId)
            .Distinct().ToList();

        var foodFacilities = await _db.FoodFacilities
            .Where(ff => foodFacilitiesIds.Contains(ff.UserIdentityId)).ToListAsync(cancellationToken: ct);

        if (foodFacilities.Count == 0)
        {
            return null;
        }

        var couriers =  await _db.Couriers
            .Where(c => c.CourierStatus == CourierStatus.WaitingForOrder
                        && c.CurrentLatitude != null && c.CurrentLongitude != null)
            .Where(c => !excludedCourierIds.Contains(c.UserIdentityId))
            .ToListAsync(cancellationToken: ct);

        var rankedCouriers = couriers.Select(courier =>
        {
            double minDistance = foodFacilities.Select(ff =>
                {
                    if (ff.Longitude is null && ff.Latitude is null)
                    {
                        return double.MaxValue;
                    }

                    return GetDistance(
                        courier.CurrentLatitude!.Value, courier.CurrentLongitude!.Value,
                        ff.Latitude!.Value, ff.Longitude!.Value);

                })
                .Min();
            return new
            {
                Courier = courier,
                Distance = minDistance
            };
        })
        .OrderBy(x => x.Distance)
        .Select(x => x.Courier)
        .ToList();

        return couriers.FirstOrDefault();
    }
    
    private double GetDistance(double lat1, double lon1, double lat2, double lon2)
    {
        const double R = 6371e3; 
        double φ1 = lat1 * Math.PI / 180;
        double φ2 = lat2 * Math.PI / 180;
        double Δφ = (lat2 - lat1) * Math.PI / 180;
        double Δλ = (lon2 - lon1) * Math.PI / 180;

        double a = Math.Sin(Δφ / 2) * Math.Sin(Δφ / 2) +
                   Math.Cos(φ1) * Math.Cos(φ2) *
                   Math.Sin(Δλ / 2) * Math.Sin(Δλ / 2);

        double c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));

        return R * c;
    }
}
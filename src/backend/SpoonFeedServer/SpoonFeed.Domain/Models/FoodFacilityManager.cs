using System.Diagnostics;
using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class FoodFacilityManager : UserIdentity
{
    public ManagerStatus ManagerStatus { get; set; }
    
    public Guid FoodFacilityId { get; set; }
    
    public virtual FoodFacility FoodFacility { get; set; }
}
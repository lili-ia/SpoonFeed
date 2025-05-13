using SpoonFeed.Domain.Enums;

namespace SpoonFeed.Domain.Models;

public class FoodChainManager : UserIdentity
{
    public ManagerStatus ManagerStatus { get; set; }

    public Guid FoodChainId { get; set; }
    
    public virtual FoodChain FoodChain { get; set; }
}
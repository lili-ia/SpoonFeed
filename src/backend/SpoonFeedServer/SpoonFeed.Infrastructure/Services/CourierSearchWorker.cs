
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Domain.Enums;
using SpoonFeed.Persistence;

namespace SpoonFeed.Infrastructure.Services;

public class CourierSearchWorker : BackgroundService
{
    private readonly IOrderQueue _orderQueue;
    private readonly ILogger<CourierSearchWorker> _logger;
    private readonly IServiceScopeFactory _scopeFactory;
    private ICourierSelector _courierSelector;
    
    const int ConfirmationTimeoutSeconds = 180;
    
    public CourierSearchWorker(
        IOrderQueue orderQueue, 
        ILogger<CourierSearchWorker> logger, 
        IServiceScopeFactory scopeFactory, 
        ICourierSelector courierSelector)
    {
        _orderQueue = orderQueue;
        _logger = logger;
        _scopeFactory = scopeFactory;
        _courierSelector = courierSelector;
    }
    
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            var orderId = await _orderQueue.DequeueAsync(stoppingToken);

            using var scope = _scopeFactory.CreateScope();
            var db = scope.ServiceProvider.GetRequiredService<SpoonFeedDbContext>();

            var order = await db.Orders.FindAsync(orderId);

            if (order == null || order.Status != OrderStatus.WaitingForCourier)
            {
                _logger.LogWarning("Order not found or not in searching state.");
                continue;
            }

            var excludedCourierIds = new HashSet<Guid>();
            
            while (!stoppingToken.IsCancellationRequested)
            {
                var courier = await _courierSelector.FindBestCourierAsync(order, stoppingToken, excludedCourierIds);

                if (courier == null)
                {
                    _logger.LogWarning("No available courier found for order {OrderId}", order.Id);

                    order.Status = OrderStatus.CourierNotFound;
                    await db.SaveChangesAsync(stoppingToken);
                    break;
                }

                courier.CourierStatus = CourierStatus.Assigned;
                order.Status = OrderStatus.WaitingForCourier;
                order.CourierId = courier.UserIdentityId;

                try
                {
                    db.Couriers.Update(courier);
                    db.Orders.Update(order);
                    await db.SaveChangesAsync(stoppingToken);
                }
                catch (Exception e)
                {
                    _logger.LogError("An error occured while trying to assing an order to courier");
                    continue;
                }
                _logger.LogInformation(
                    $"Sending a confirmation request for order {order.Id} to courier {courier.UserIdentityId}");
                
                // todo: NotifyCourierAsync
                
                await Task.Delay(TimeSpan.FromSeconds(ConfirmationTimeoutSeconds), stoppingToken);

                var refreshedOrder = await db.Orders.FindAsync(orderId, stoppingToken);

                if (refreshedOrder.Status != OrderStatus.Delivering)
                {
                    _logger.LogInformation($"Courier {courier.UserIdentityId} did not accepted order {order.Id}");
                    excludedCourierIds.Add(courier.UserIdentityId);
                    break;
                }

                _logger.LogInformation($"Courier {courier.UserIdentityId} accepted order {order.Id}");
            }
        }
    }
}
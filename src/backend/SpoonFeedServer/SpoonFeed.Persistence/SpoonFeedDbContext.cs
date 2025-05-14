using Microsoft.EntityFrameworkCore;
using SpoonFeed.Domain.Models;

namespace SpoonFeed.Persistence;

public class SpoonFeedDbContext : DbContext
{
    public DbSet<Courier> Couriers { get; set; }
    public DbSet<CourierReview> CourierReviews { get; set; }
    public DbSet<Currency> Currencies { get; set; }
    public DbSet<Customer> Customers { get; set; }
    public DbSet<Discount> Discounts { get; set; }
    public DbSet<FoodChain> FoodChains { get; set; }
    public DbSet<FoodChainManager> FoodChainManagers { get; set; }
    public DbSet<FoodFacility> FoodFacilities { get; set; }
    public DbSet<FoodFacilityManager> FoodFacilityManagers { get; set; }
    public DbSet<FoodFacilityReview> FoodFacilityReviews { get; set; }
    public DbSet<Image> Images { get; set; }
    public DbSet<MenuItem> MenuItems { get; set; }
    public DbSet<MenuItemCategory> MenuItemCategories { get; set; }
    public DbSet<Order> Orders { get; set; }
    public DbSet<OrderPosition> OrderPositions { get; set; }
    public DbSet<Review> Reviews { get; set; }
    public DbSet<Transaction> Transactions { get; set; }
    
    public SpoonFeedDbContext(DbContextOptions<SpoonFeedDbContext> options) : base(options)
    {
        
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
         modelBuilder.Entity<Currency>()
            .HasIndex(c => c.Code)
            .IsUnique();

        modelBuilder.Entity<MenuItem>()
            .HasOne(mi => mi.Currency)
            .WithMany()
            .HasForeignKey(mi => mi.CurrencyId);

        modelBuilder.Entity<MenuItem>()
            .HasOne(mi => mi.FoodFacility)
            .WithMany(f => f.MenuItems)
            .HasForeignKey(mi => mi.FooFoodFacilityId);

        modelBuilder.Entity<MenuItem>()
            .HasOne(mi => mi.MenuItemCategory)
            .WithMany(mc => mc.MenuItems)
            .HasForeignKey(mi => mi.MenuItemCategoryId);

        modelBuilder.Entity<MenuItem>()
            .HasMany(mi => mi.Discounts)
            .WithMany();

        modelBuilder.Entity<Order>()
            .HasOne(o => o.Customer)
            .WithMany(c => c.Orders)
            .HasForeignKey(o => o.CustomerId);

        modelBuilder.Entity<Order>()
            .HasOne(o => o.Courier)
            .WithMany(c => c.Orders)
            .HasForeignKey(o => o.CourierId);

        modelBuilder.Entity<Order>()
            .HasMany(o => o.OrderPositions)
            .WithOne()
            .HasForeignKey(op => op.Id);

        modelBuilder.Entity<OrderPosition>()
            .HasOne(op => op.MenuItem)
            .WithMany()
            .HasForeignKey(op => op.MenuItemId);

        modelBuilder.Entity<Transaction>()
            .HasOne(t => t.Currency)
            .WithMany()
            .HasForeignKey(t => t.CurrencyId);

        modelBuilder.Entity<Customer>()
            .HasMany(c => c.Transactions)
            .WithOne()
            .HasForeignKey(t => t.CustomerId);

        modelBuilder.Entity<Customer>()
            .HasMany(c => c.Reviews)
            .WithOne(r => r.Customer)
            .HasForeignKey(r => r.CustomerId);

        modelBuilder.Entity<Courier>()
            .HasMany(c => c.Transactions)
            .WithOne()
            .HasForeignKey(t => t.CourierId);

        modelBuilder.Entity<Courier>()
            .HasMany(c => c.CourierReviews)
            .WithOne(r => r.Courier)
            .HasForeignKey(r => r.CourierId);
        
        modelBuilder.Entity<Order>()
            .HasMany(f => f.OrderPositions)
            .WithOne(o => o.Order)
            .HasForeignKey(o => o.OrderId);
        
        modelBuilder.Entity<OrderPosition>()
            .HasOne(op => op.MenuItem)
            .WithMany()
            .HasForeignKey(op => op.MenuItemId);

        modelBuilder.Entity<FoodFacility>()
            .HasMany(f => f.Transactions)
            .WithOne()
            .HasForeignKey(t => t.FoodFacilityId);

        modelBuilder.Entity<FoodFacility>()
            .HasMany(f => f.FoodFacilityReviews)
            .WithOne(r => r.FoodFacility)
            .HasForeignKey(r => r.FoodFacilityId);

        modelBuilder.Entity<MenuItemCategory>()
            .HasOne(mc => mc.FoodFacility)
            .WithMany(f => f.MenuItemCategories)
            .HasForeignKey(mc => mc.FoodFacilityId);

        modelBuilder.Entity<MenuItem>()
            .HasOne(mi => mi.MenuItemCategory)
            .WithMany(mc => mc.MenuItems)
            .HasForeignKey(mi => mi.MenuItemCategoryId);
        
        modelBuilder.Entity<FoodChain>()
            .HasMany(fc => fc.Facilities)
            .WithOne()
            .HasForeignKey(fc => fc.FoodChainId);

        modelBuilder.Entity<FoodChain>()
            .HasMany(fc => fc.Managers)
            .WithOne(m => m.FoodChain)
            .HasForeignKey(m => m.FoodChainId);

        modelBuilder.Entity<FoodFacilityManager>()
            .HasOne(m => m.FoodFacility)
            .WithMany()
            .HasForeignKey(m => m.FoodFacilityId);

        modelBuilder.Entity<Customer>()
            .Property(c => c.BirthDate)
            .HasConversion(
                d => d.ToDateTime(TimeOnly.MinValue),
                d => DateOnly.FromDateTime(d)
            );
    }
}
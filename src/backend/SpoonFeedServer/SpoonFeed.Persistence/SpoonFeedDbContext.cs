using Microsoft.EntityFrameworkCore;
using SpoonFeed.Domain.Models;
using SpoonFeed.Persistence.Converters;

namespace SpoonFeed.Persistence;

public class SpoonFeedDbContext : DbContext
{
    public DbSet<Courier> Couriers { get; set; }
    public DbSet<CourierReview> CourierReviews { get; set; }
    public DbSet<Currency> Currencies { get; set; }
    public DbSet<Customer> Customers { get; set; }
    public DbSet<Discount> Discounts { get; set; }
    public DbSet<FoodChain> FoodChains { get; set; }
    public DbSet<FoodFacility> FoodFacilities { get; set; }
    public DbSet<FoodFacilityReview> FoodFacilityReviews { get; set; }
    public DbSet<Image> Images { get; set; }
    public DbSet<MenuItem> MenuItems { get; set; }
    public DbSet<MenuItemCategory> MenuItemCategories { get; set; }
    public DbSet<Order> Orders { get; set; }
    public DbSet<OrderPosition> OrderPositions { get; set; }
    public DbSet<Transaction> Transactions { get; set; }
    public DbSet<UserDocument> UserDocuments { get; set; }

    public SpoonFeedDbContext(DbContextOptions<SpoonFeedDbContext> options) : base(options)
    {
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // modelBuilder.Entity<Courier>(e =>
        // {
        //     
        // });

        modelBuilder.Entity<CourierReview>(e =>
        {
            e.HasOne(cr => cr.Courier)
                .WithMany(c => c.CourierReviews)
                .HasForeignKey(cr => cr.CourierId);

            e.HasOne(cr => cr.Customer)
                .WithMany()
                .HasForeignKey(cr => cr.CustomerId);
        });

        modelBuilder.Entity<Currency>(e =>
        {
            e.HasIndex(c => c.Code)
                .IsUnique();
        });

        modelBuilder.Entity<Customer>(e =>
        {
            e.Property(c => c.BirthDate)
                .HasConversion(new NullableDateOnlyConverter());
        });

        modelBuilder.Entity<Discount>(e =>
        {
            e.HasOne(d => d.MenuItem)
                .WithMany(mi => mi.Discounts)
                .HasForeignKey(d => d.MenuItemId);
        });

        modelBuilder.Entity<FoodChain>(e =>
        {
            e.HasOne(fc => fc.Image)
                .WithMany()
                .HasForeignKey(fc => fc.ImageId);
        });

        modelBuilder.Entity<FoodFacility>(e =>
        {
            e.HasOne(ff => ff.FoodChain)
                .WithMany(fc => fc.Facilities)
                .HasForeignKey(ff => ff.FoodChainId);
        });
        
        modelBuilder.Entity<FoodFacilityReview>(e =>
        {
            e.HasOne(fr => fr.FoodFacility)
                .WithMany(ff => ff.FoodFacilityReviews)
                .HasForeignKey(fr => fr.FoodFacilityId);

            e.HasOne(fr => fr.Customer)
                .WithMany()
                .HasForeignKey(fr => fr.CustomerId);
        });

        // modelBuilder.Entity<Image>(e =>
        // {
        //
        // });
        
        modelBuilder.Entity<MenuItem>(e =>
        {
            e.HasOne(mi => mi.Currency)
                .WithMany()
                .HasForeignKey(mi => mi.CurrencyId);

            e.HasOne(mi => mi.FoodFacility)
                .WithMany(f => f.MenuItems)
                .HasForeignKey(mi => mi.FooFoodFacilityId);

            e.HasOne(mi => mi.MenuItemCategory)
                .WithMany(mc => mc.MenuItems)
                .HasForeignKey(mi => mi.MenuItemCategoryId);

            e.HasOne(mi => mi.Image)
                .WithMany()
                .HasForeignKey(mi => mi.ImageId);
        });

        // modelBuilder.Entity<MenuItemCategory>(e =>
        // {
        //
        // });

        modelBuilder.Entity<Order>(e =>
        {
            e.HasOne(o => o.Customer)
                .WithMany(c => c.Orders)
                .HasForeignKey(o => o.CustomerId);

            e.HasOne(o => o.Courier)
                .WithMany(c => c.Orders)
                .HasForeignKey(o => o.CourierId);
        });

        modelBuilder.Entity<OrderPosition>(e =>
        {
            e.HasOne(op => op.Order)
                .WithMany(o => o.OrderPositions)
                .HasForeignKey(op => op.OrderId);

            e.HasOne(op => op.MenuItem)
                .WithMany()
                .HasForeignKey(op => op.MenuItemId);
        });

        modelBuilder.Entity<Transaction>(e =>
        {
            e.HasOne(t => t.Currency)
                .WithMany()
                .HasForeignKey(t => t.CurrencyId);

            e.HasOne(t => t.Customer)
                .WithMany(c => c.Transactions)
                .HasForeignKey(t => t.CustomerId);

            e.HasOne(t => t.Courier)
                .WithMany(c => c.Transactions)
                .HasForeignKey(t => t.CourierId);

            e.HasOne(t => t.FoodFacility)
                .WithMany(f => f.Transactions)
                .HasForeignKey(t => t.FoodFacilityId);
        });

        modelBuilder.Entity<UserDocument>(e =>
        {
            e.HasOne(ud => ud.Owner)
                .WithMany(ui => ui.Documents)
                .HasForeignKey(ud => ud.OwnerId);
        });
    }
}
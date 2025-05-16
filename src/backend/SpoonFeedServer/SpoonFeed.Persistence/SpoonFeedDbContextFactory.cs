using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;

namespace SpoonFeed.Persistence;

public class SpoonFeedDbContextFactory : IDesignTimeDbContextFactory<SpoonFeedDbContext>
{
    public SpoonFeedDbContext CreateDbContext(string[] args)
    {
        var builder = new ConfigurationBuilder()
            .SetBasePath(Path.Combine(Directory.GetCurrentDirectory(), "..", "SpoonFeed.Server"))
            .AddJsonFile("appsettings.json");
        
        IConfiguration config = builder.Build();
        
        var optionsBuilder = new DbContextOptionsBuilder<SpoonFeedDbContext>();
        var connectionString = config.GetConnectionString("DefaultDevelopment");

        optionsBuilder.UseSqlServer(connectionString);

        return new SpoonFeedDbContext(optionsBuilder.Options);
    }
}
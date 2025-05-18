using Microsoft.EntityFrameworkCore;
using SpoonFeed.Application.Interfaces;
using SpoonFeed.Application.Mappings;
using SpoonFeed.Application.Services;
using SpoonFeed.Infrastructure.Services;
using SpoonFeed.Persistence;
using SpoonFeedServer.Extensions;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("DefaultDevelopment");

builder.Services.AddDbContext<SpoonFeedDbContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddTransient<IJwtService, JwtService>();
builder.Services.AddScoped<IPasswordService, PasswordService>();
builder.Services.AddScoped<IAuthService, AuthService>();

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<IUserContextService, UserContextService>();

builder.Services.AddAutoMapper(typeof(AutoMapperProfile).Assembly);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddControllers();
builder.Services.AddLogging();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseLoggerMiddleware();

app.Run();

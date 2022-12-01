using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.ResponseCompression;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using RecipeBook.Dal.SeedInterfaces;
using RecipeBook.Dal.SeedService;
using System.Text;
using CaffShop.BLL.Interfaces;
using CaffShop.BLL.Managers;
using CaffShop.DAL;
using CaffShop.DAL.Entities;
using CaffShop.Server.Hosting;
using Microsoft.OpenApi.Models;
using CaffShop.Shared.CustomeDTOs;
using Microsoft.Extensions.Options;
using CaffShop.Server.ExceptionHandler;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using WatchDog;
using WatchDog.src.Enums;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddDbContext<CaffShopDbContext>(db => db.UseSqlServer(builder.Configuration.GetConnectionString(nameof(CaffShopDbContext))));
builder.Services.AddIdentity<User, IdentityRole<int>>(options => {
  options.Password.RequireDigit = true;
  options.Password.RequiredLength = 8;
  options.Password.RequireNonAlphanumeric = true;
  options.Password.RequireUppercase = true;
  options.Password.RequireLowercase = true;
})
  .AddEntityFrameworkStores<CaffShopDbContext>()
  .AddUserManager<CaffShopUserManager>()
  .AddDefaultTokenProviders();

builder.Services.AddControllers(options =>
{
  options.Filters.Add<ModelValidationFilter>();
  options.Filters.Add<HttpResponseExceptionFilter>();
});
builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages();

builder.Services.AddWatchDogServices(settings =>
{
  settings.IsAutoClear = true;
  settings.ClearTimeSchedule = WatchDogAutoClearScheduleEnum.Weekly;
  settings.SqlDriverOption = WatchDogSqlDriverEnum.MSSQL;
  settings.SetExternalDbConnString = "Server=db;Database=tempdb;User Id=SA;Password=S3cur3P@ssW0rd!;";
});

builder.Services.Configure<ApiBehaviorOptions>(options => options.SuppressModelStateInvalidFilter = true);

builder.Services.AddScoped<ITokenManager, TokenManager>();
builder.Services.AddScoped<ICaffManager, CaffManager>();

builder.Services.AddScoped<IUserSeedService, UserSeedService>();

var jwtSettings = builder.Configuration.GetSection("JwtSettings");
builder.Services.AddAuthentication(opt =>
{
  opt.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
  opt.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
  options.TokenValidationParameters = new TokenValidationParameters
  {
    ValidateIssuer = false,
    ValidateAudience = false,
    ValidateLifetime = true,
    ValidateIssuerSigningKey = true,
    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings.GetSection("securityKey").Value))
  };
});

var fileSettings = builder.Configuration.GetSection(nameof(FileSettings));
builder.Services.Configure<FileSettings>(fileSettings);
builder.Services.AddSingleton<IFileSettings>(sp => sp.GetRequiredService<IOptions<FileSettings>>().Value);
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(option =>
{
  option.SwaggerDoc("v1", new OpenApiInfo { Title = "Demo API", Version = "v1" });
  option.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
  {
    In = ParameterLocation.Header,
    Description = "Please enter a valid token",
    Name = "Authorization",
    Type = SecuritySchemeType.Http,
    BearerFormat = "JWT",
    Scheme = "Bearer"
  });
  option.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type=ReferenceType.SecurityScheme,
                    Id="Bearer"
                }
            },
            new string[]{}
        }
    });
});

var app = builder.Build();

await app.MigrateDatabaseAsync<CaffShopDbContext>();


app.UseHttpLogging();
/*if (app.Environment.IsDevelopment())
{
  app.UseSwagger();
  app.UseSwaggerUI();
}*/
app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

if (!app.Environment.IsDevelopment())
{
  app.UseWatchDogExceptionLogger();
  app.UseWatchDog(opt =>
  {
    opt.WatchPageUsername = "admin";
    opt.WatchPagePassword = "admin";
  });
}




app.Run();
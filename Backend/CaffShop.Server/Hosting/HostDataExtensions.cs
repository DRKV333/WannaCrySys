using CaffShop.Dal.SeedInterfaces;
using Microsoft.EntityFrameworkCore;

namespace CaffShop.Server.Hosting
{
  public static class HostDataExtensions
  {
    public async static Task<IHost> MigrateDatabaseAsync<TContext>(this IHost host) where TContext : DbContext
    {
      using (var scope = host.Services.CreateScope())
      {
        scope.ServiceProvider.GetRequiredService<TContext>().Database.Migrate();

        var roleSeeder = scope.ServiceProvider.GetRequiredService<IRoleSeedService>();
        await roleSeeder.SeedRoleAsync();
        var userSeeder = scope.ServiceProvider.GetRequiredService<IUserSeedService>();
        await userSeeder.SeedUserAsync();      
      }
      return host;
    }
  }
}

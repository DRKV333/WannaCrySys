using Microsoft.AspNetCore.Identity;
using RecipeBook.Dal.SeedInterfaces;
using RecipeBook.Dal.Users;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace RecipeBook.Dal.SeedService
{
  public class RoleSeedService : IRoleSeedService
  {
    private readonly RoleManager<IdentityRole<int>> roleManager;

    public RoleSeedService(RoleManager<IdentityRole<int>> roleManager)
    {
      this.roleManager = roleManager;
    }

    public async Task SeedRoleAsync()
    {
        await roleManager.CreateAsync(new IdentityRole<int> { Name = Roles.Administrator });

      if (!await roleManager.RoleExistsAsync(Roles.User))
        await roleManager.CreateAsync(new IdentityRole<int> { Name = Roles.User });
    }
  }
}

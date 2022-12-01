using Microsoft.AspNetCore.Identity;
using RecipeBook.Dal.SeedInterfaces;
using RecipeBook.Dal.Users;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CaffShop.DAL.Entities;

namespace RecipeBook.Dal.SeedService
{
  public class UserSeedService : IUserSeedService
  {
    private readonly UserManager<User> userManager;

    public UserSeedService(UserManager<User> userManager)
    {
      this.userManager = userManager;
    }

    public async Task SeedUserAsync()
    {
      if (!(await userManager.GetUsersInRoleAsync(Roles.Administrator)).Any(u => u.UserName == "CaffAdmin"))
      {
        var user = new User
        {
          Email = "admin@CaffShop.hu",
          Name = "Admin",
          SecurityStamp = Guid.NewGuid().ToString(),
          UserName = "CaffAdmin"
        };

        var createResult = await userManager.CreateAsync(user, "$Admin123");
        var addToRoleResult = await userManager.AddToRoleAsync(user, Roles.Administrator);

        if (!createResult.Succeeded || !addToRoleResult.Succeeded)
        {
          throw new ApplicationException("Administrator clould not be created:" +
              String.Join(", ", createResult.Errors.Concat(addToRoleResult.Errors).Select(e => e.Description)));
        }
      }

      if (!(await userManager.GetUsersInRoleAsync(Roles.User)).Any(u => u.UserName == "TestUser"))
      {
        var user = new User
        {
          Email = "test@CaffShop.hu",
          Name = "Test User",
          SecurityStamp = Guid.NewGuid().ToString(),
          UserName = "TestUser"
        };

        var createResult = await userManager.CreateAsync(user, "$Test123");
        var addToRoleResult = await userManager.AddToRoleAsync(user, Roles.User);

        if (!createResult.Succeeded || !addToRoleResult.Succeeded)
        {
          throw new ApplicationException("User clould not be created:" +
              String.Join(", ", createResult.Errors.Concat(addToRoleResult.Errors).Select(e => e.Description)));
        }
      }
    }
  }
}

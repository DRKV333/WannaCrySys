using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CaffShop.DAL.Entities;
using CaffShop.Dal.SeedInterfaces;

namespace CaffShop.Dal.SeedService
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
    }
  }
}

using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CaffShop.DAL;
using CaffShop.DAL.Entities;

namespace CaffShop.BLL.Managers
{
  public class CaffShopUserManager : UserManager<User>
  {
    private readonly UserStore<User, IdentityRole<int>, CaffShopDbContext, int, IdentityUserClaim<int>,
       IdentityUserRole<int>, IdentityUserLogin<int>, IdentityUserToken<int>, IdentityRoleClaim<int>>
       _store;

    public CaffShopUserManager(IUserStore<User> store, IOptions<IdentityOptions> optionsAccessor, IPasswordHasher<User> passwordHasher, IEnumerable<IUserValidator<User>> userValidators, IEnumerable<IPasswordValidator<User>> passwordValidators, ILookupNormalizer keyNormalizer, IdentityErrorDescriber errors, IServiceProvider services, ILogger<UserManager<User>> logger) : base(store, optionsAccessor, passwordHasher, userValidators, passwordValidators, keyNormalizer, errors, services, logger)
    {
      _store = (UserStore<User, IdentityRole<int>, CaffShopDbContext, int, IdentityUserClaim<int>,
       IdentityUserRole<int>, IdentityUserLogin<int>, IdentityUserToken<int>, IdentityRoleClaim<int>>)store;
    }

    public async Task<bool> IsInRoleByIdAsync(User user, int roleId, CancellationToken cancellationToken = default(CancellationToken))
    {
      cancellationToken.ThrowIfCancellationRequested();
      ThrowIfDisposed();

      if (user == null)
        throw new ArgumentNullException(nameof(user));


      var role = await _store.Context.Set<IdentityRole>().FindAsync(roleId);
      if (role == null)
        return false;

      var userRole = await _store.Context.Set<IdentityUserRole<string>>().FindAsync(new object[] { user.Id, roleId }, cancellationToken);
      return userRole != null;
    }
  }
}

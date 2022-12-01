using CaffShop.DAL.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.DAL.EntityConfigurations
{
    public class UserConfiguration : IEntityTypeConfiguration<User>
    {
        public void Configure(EntityTypeBuilder<User> builder)
        {
            builder.HasData(
              new User { Id = 1, Name = "Test User", UserName = "TestUser", NormalizedUserName = "TESTUSER", Email = "test@CaffShop.hu", NormalizedEmail = "TEST@CAFFSHOP.HU", EmailConfirmed = false, PasswordHash = "AQAAAAEAACcQAAAAEHlNBzcWsbKkUu26Mb4zd607WIad9JP/gM7a5iS/jzI+TRc5R8gBWrJMIUIyyts6Pg==", SecurityStamp = "SecurityStamp", ConcurrencyStamp = "d573a016-651e-49d3-bb5f-f87a88ef31ba", PhoneNumber = null, PhoneNumberConfirmed = false, TwoFactorEnabled = false, LockoutEnd = null, LockoutEnabled = true, AccessFailedCount = 0 }
            );
        }
    }
}

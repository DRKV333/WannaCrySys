using CaffShop.DAL.Entities;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;

namespace CaffShop.DAL.EntityConfigurations
{
    public class RoleConfiguration : IEntityTypeConfiguration<IdentityRole<int>>
    {
        public void Configure(EntityTypeBuilder<IdentityRole<int>> builder)
        {
            builder.HasData(
              new IdentityRole<int> { Id = 1, Name = "Administrator", NormalizedName = "ADMINISTRATOR", ConcurrencyStamp = "1e117783-7170-47cd-a20b-92ed75d5e03a" },
              new IdentityRole<int> { Id = 2, Name = "User", NormalizedName = "USER", ConcurrencyStamp = "99664e4d-f6e0-4049-b8eb-b8f0118aaf8e" }
            );
        }
    }
}


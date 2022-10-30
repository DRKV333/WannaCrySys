using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CaffShop.DAL.Entities;

namespace CaffShop.DAL
{
  public partial class CaffShopDbContext : IdentityDbContext<User, IdentityRole<int>, int>
  {
    protected CaffShopDbContext() { }
    public CaffShopDbContext(DbContextOptions options) : base(options)
    {
    }
    public override DbSet<User>? Users { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
      base.OnModelCreating(modelBuilder);

      modelBuilder.Entity<User>(entity =>
      {
        entity.ToTable("Users");
        entity.Property(e => e.Name).IsRequired().HasMaxLength(250);

        entity.Property(e => e.CreatedDate)
          .HasColumnType("DATETIME2 (0)")
          .HasDefaultValueSql("(getdate())");
      });

      OnModelCreatingPartial(modelBuilder);
    }

  }
}


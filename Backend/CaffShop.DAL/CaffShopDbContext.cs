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
    public DbSet<Caff> Caffs { get; set; }
    public DbSet<Comment> Comment { get; set; }
    public DbSet<Purchase> Purchases { get; set; }

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
      });

      modelBuilder.Entity<Caff>(entity =>
      {
        entity.Property(e => e.Title).IsRequired();

        entity.Property(e => e.CreatedDate)
          .HasColumnType("DATETIME2 (0)")
          .HasDefaultValueSql("(getdate())");

        entity.HasOne(e => e.Owner)
          .WithMany(s => s.Caffs)
          .HasForeignKey(e => e.OwnerId)
          .OnDelete(DeleteBehavior.ClientCascade)
          .HasConstraintName("FK_Caffs_Users_Owner");
      });

      modelBuilder.Entity<Comment>(entity =>
      {
        entity.Property(e => e.Content).IsRequired();

        entity.Property(e => e.CreatedDate)
          .HasColumnType("DATETIME2 (0)")
          .HasDefaultValueSql("(getdate())");

       entity.HasOne(e => e.Caff)
          .WithMany(s => s.Comments)
          .HasForeignKey(e => e.CaffId)
          .OnDelete(DeleteBehavior.ClientCascade)
          .HasConstraintName("FK_Comments_Caffs_Caff");

        entity.HasOne(e => e.User)
          .WithMany(s => s.Comments)
          .HasForeignKey(e => e.UserId)
          .OnDelete(DeleteBehavior.ClientCascade)
          .HasConstraintName("FK_Comments_Users_User");
      });

      modelBuilder.Entity<Purchase>(entity =>
      {
        entity.Property(e => e.CreatedDate)
          .HasColumnType("DATETIME2 (0)")
          .HasDefaultValueSql("(getdate())");

        entity.HasOne(e => e.Caff)
          .WithMany(s => s.Purchases)
          .HasForeignKey(e => e.CaffId)
          .OnDelete(DeleteBehavior.ClientCascade)
          .HasConstraintName("FK_Purchases_Caffs_Caff");

        entity.HasOne(e => e.User)
          .WithMany(s => s.Purchases)
          .HasForeignKey(e => e.UserId)
          .OnDelete(DeleteBehavior.ClientCascade)
          .HasConstraintName("FK_Purchases_Users_User");
      });

      OnModelCreatingPartial(modelBuilder);
    }

  }
}


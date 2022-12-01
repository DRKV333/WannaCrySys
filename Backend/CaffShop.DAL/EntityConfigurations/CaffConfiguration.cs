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
  public class CaffConfiguration : IEntityTypeConfiguration<Caff>
  {
    public void Configure(EntityTypeBuilder<Caff> builder)
    {
      builder.HasData(
        new Caff { Id = 1, Title = "Caff test entity", OwnerId = 2, FileName = "Test", UniqueFileName = "Test", ImgURL = "Test" }
      );
    }
  }
}

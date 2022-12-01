using CaffShop.DAL.EntityConfigurations;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.DAL
{
  public partial class CaffShopDbContext
  {
    partial void OnModelCreatingPartial(ModelBuilder modelBuilder) 
    {
     modelBuilder.ApplyConfiguration(new CaffConfiguration());
    }
  }
}

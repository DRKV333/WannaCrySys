using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace CaffShop.DAL.Entities
{
  public class User : IdentityUser<int>
  {
    public User()
    {
      Comments = new HashSet<Comment>();
      Purchases = new HashSet<Purchase>();
      Caffs = new HashSet<Caff>();
    }

    [PersonalData]
    public string? Name { get; set; }
    public virtual ICollection<Comment> Comments { get; set; }
    public virtual ICollection<Purchase> Purchases { get; set; }
    public virtual ICollection<Caff> Caffs { get; set; }
  }
}

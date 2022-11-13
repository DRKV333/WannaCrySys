using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.DAL.Entities
{
  public class User : IdentityUser<int>
  {
    public User()
    {
    }

    [PersonalData]
    public string? Name { get; set; }
    public DateTime CreatedDate { get; set; }
    public string? RefreshToken { get; set; }
    public DateTime? RefreshTokenExpiryTime { get; set; }
  }
}

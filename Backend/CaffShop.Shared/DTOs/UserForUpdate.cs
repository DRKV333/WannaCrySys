using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.DTOs
{
  public class UserForUpdate
  {
    [Required(ErrorMessage = "Név kötelező")]
    public string Name { get; set; }

    public string Password { get; set; }
  }
}

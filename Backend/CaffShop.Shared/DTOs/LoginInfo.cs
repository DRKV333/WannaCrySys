using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.DTOs
{
  public class LoginInfo
  {
    [Required(ErrorMessage = "Username is required")]
    [MinLength(8)]
    [MaxLength(64)]
    public string Username { get; set; }

    [Required(ErrorMessage = "Password is required")]
    [MinLength(8)]
    public string Password { get; set; }
  }
}

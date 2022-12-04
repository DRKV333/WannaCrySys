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
    [MinLength(8, ErrorMessage = "Minimum 8 characters are required")]
    [MaxLength(64, ErrorMessage = "Maximum 32 characters are allowed")]
    public string Username { get; set; }

    [Required(ErrorMessage = "Password is required")]
    [MinLength(8, ErrorMessage = "Minimum 8 characters are required")]
    public string Password { get; set; }
  }
}

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace CaffShop.Shared
{
  public class UserForRegistrationDto
  {
    [Required(ErrorMessage = "Name is required")]
    [MinLength(8)]
    [MaxLength(32)]
    public string Name { get; set; }

    [Required(ErrorMessage = "Username is required")]
    [MinLength(8)]
    [MaxLength(64)]
    public string Username { get; set; }

    [Required(ErrorMessage = "Password is required")]
    [MinLength(8)]
    public string Password { get; set; }

    [Compare("Password", ErrorMessage = "Value has to match with the given password")]
    [MinLength(8)]
    public string ConfirmPassword { get; set; }
  }
}

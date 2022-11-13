using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace CaffShop.Shared
{
  public class UserForRegistrationDto
  {
    [Required(ErrorMessage = "Name is required")]
    public string Name { get; set; }

    [Required(ErrorMessage = "Username is required")]
    public string Username { get; set; }

    [Required(ErrorMessage = "Password is required")]
    public string Password { get; set; }

    [Compare("Password", ErrorMessage = "Value has to match with the given password")]
    public string ConfirmPassword { get; set; }
  }
}

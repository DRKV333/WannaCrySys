using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace CaffShop.Shared
{
  public class UserForRegistrationDto
  {
    [Required(ErrorMessage = "Name is required")]
    [MinLength(8, ErrorMessage = "Minimum 8 characters are required")]
    [MaxLength(32, ErrorMessage = "Maximum 32 characters are allowed")]
    public string Name { get; set; }

    [Required(ErrorMessage = "Username is required")]
    [MinLength(8, ErrorMessage = "Minimum 8 characters are required")]
    [MaxLength(64, ErrorMessage = "Maximum 32 characters are allowed")]
    public string Username { get; set; }

    [Required(ErrorMessage = "Password is required")]
    [MinLength(8, ErrorMessage = "Minimum 8 characters are required")]
    public string Password { get; set; }

    [Compare("Password", ErrorMessage = "Value has to match with the given password")]
    [MinLength(8, ErrorMessage = "Minimum 8 characters are required")]
    public string ConfirmPassword { get; set; }
  }
}

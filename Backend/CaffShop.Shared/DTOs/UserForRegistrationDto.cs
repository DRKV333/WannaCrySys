using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace CaffShop.Shared
{
  public class UserForRegistrationDto
  {
    [Required(ErrorMessage = "Név kötelező")]
    public string Name { get; set; }

    [Required(ErrorMessage = "Email kötelező.")]
    public string Email { get; set; }

    [Required(ErrorMessage = "Jelszó kötelező")]
    public string Password { get; set; }

    [Compare("Password", ErrorMessage = "A jelszó és a megerősítés nem egyezik meg.")]
    public string ConfirmPassword { get; set; }
  }
}

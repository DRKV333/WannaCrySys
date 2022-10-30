using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace CaffShop.Shared
{
    public class UserForAuthenticationDto
    {
        [Required(ErrorMessage = "Email kötelező.")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Jelszó kötelező.")]
        public string Password { get; set; }
    }
}

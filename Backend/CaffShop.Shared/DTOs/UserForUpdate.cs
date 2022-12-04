using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.DTOs
{
  public class UserForUpdate
  {
    [Required(ErrorMessage = "Name is required")]
    [MinLength(8, ErrorMessage = "Minimum 8 characters are required")]
    [MaxLength(32, ErrorMessage = "Maximum 32 characters are allowed")]
    public string Name { get; set; }
    [AllowNull]
    public string Password { get; set; }
    [AllowNull]
    public string ConfirmPassword { get; set; }
  }
}

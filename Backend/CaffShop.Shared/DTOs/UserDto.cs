using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.DTOs
{
  public class UserDto
  {
    public int Id { get; set; }

    [Required(ErrorMessage = "Név kötelező")]
    public string Name { get; set; }

    [Required(ErrorMessage = "Email kötelező.")]
    public string Email { get; set; }
  }
}

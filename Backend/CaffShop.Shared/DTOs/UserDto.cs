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
    public string Name { get; set; }
    public string UserName { get; set; }
    public List<CaffListItemDto> Caffs { get; set; }
  }
}

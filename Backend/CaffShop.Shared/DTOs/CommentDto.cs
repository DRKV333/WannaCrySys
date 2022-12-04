using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.DTOs
{
  public class CommentDto
  {
    public int Id { get; set; }
    public DateTime CreatedDate { get; set; }
    public string Content { get; set; }
    public string UserName { get; set; }
    public bool IsOwner { get; set; }
  }
}

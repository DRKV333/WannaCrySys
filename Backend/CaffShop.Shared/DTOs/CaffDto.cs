using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.DTOs
{
  public class CaffDto
  {
    public int Id { get; set; }
    public string Title { get; set; }
    public DateTime CreatedDate { get; set; }
    public string OwnerName { get; set; }
    public string ImgURL { get; set; }
    public List<CommentDto> Comments { get; set; }
    public int NumberOfPurchases { get; set; }
  }
}

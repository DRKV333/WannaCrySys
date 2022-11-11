using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.DAL.Entities
{
  public class Purchase
  {
    [Key]
    public int Id { get; set; }
    public DateTime CreatedDate { get; set; }
    public int UserId { get; set; }
    public virtual User? User { get; set; }
    public int CaffId { get; set; }
    public virtual Caff? Caff { get; set; }
  }
}

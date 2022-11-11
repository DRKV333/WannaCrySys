using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace CaffShop.DAL.Entities
{
  public class Caff
  {
    public Caff()
    {
      Comments = new HashSet<Comment>();
      Purchases = new HashSet<Purchase>();
    }

    [Key]
    public int Id { get; set; }
    public string Title { get; set; }
    public DateTime CreatedDate { get; set; }
    public int OwnerId { get; set; }
    public virtual User? Owner { get; set; }
    public string ImgURL { get; set; }
    public string FilePath { get; set; }
    public virtual ICollection<Comment> Comments { get; set; }
    public virtual ICollection<Purchase> Purchases { get; set; }
  }
}

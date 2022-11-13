using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.DTOs
{
  public class CaffForEditingDto
  {
    [Required(ErrorMessage = "Title is required")]
    public string Title { get; set; }
    public IFormFile CaffFile { get; set; }
  }
}

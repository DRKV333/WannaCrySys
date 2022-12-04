using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.DTOs
{
  public class CaffForEditingDto
  {
    [Required(ErrorMessage = "Title is required")]
    [MinLength(8, ErrorMessage = "Minimum 8 characters are required")]
    [MaxLength(128)]
    public string Title { get; set; }
    [AllowNull]
    public IFormFile CaffFile { get; set; } = null;
  }
}

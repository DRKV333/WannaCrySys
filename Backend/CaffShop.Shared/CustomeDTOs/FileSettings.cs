using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.CustomeDTOs
{
  public class FileSettings : IFileSettings
  {
    public string FilePath { get; set; }
    public int MaxSizeInMegaBytes { get; set; }
  }

  public interface IFileSettings
  {
    public string FilePath { get; }
    public int MaxSizeInMegaBytes { get; }
  }
}

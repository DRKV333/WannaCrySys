using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.BLL.Interfaces
{
    internal interface IFileService
    {
        Stream GetImageAsStream();
        byte[] GetImageAsByteArray();
    }
}

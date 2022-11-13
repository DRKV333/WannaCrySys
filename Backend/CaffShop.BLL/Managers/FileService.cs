using CaffShop.BLL.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;
using System.Buffers.Text;

namespace CaffShop.BLL.Managers
{
    public class FileService : IFileService
    {
        public Stream GetImageAsStream()
        {
            var stream = new MemoryStream(Convert.FromBase64String(Image.Base64Image));

            return stream;
        }

        public byte[] GetImageAsByteArray()
        {
            var bytes = Convert.FromBase64String(Image.Base64Image);

            return bytes;
        }
    }
}

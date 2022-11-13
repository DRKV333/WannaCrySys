using System;
using System.Collections.Generic;
using System.Text;

namespace CaffShop.Shared
{
    public class ServerResponseDto
    {
        public bool IsSuccessful { get; set; }
        public IEnumerable<string> Errors { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Text;

namespace CaffShop.Shared
{
    public class ValidationResult
    {
        public bool IsSuccessful { get; set; }
        public List<string> Errors { get; set; }
    }
}

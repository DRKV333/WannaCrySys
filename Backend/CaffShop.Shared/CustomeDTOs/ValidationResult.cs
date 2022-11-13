using System;
using System.Collections.Generic;
using System.Text;

namespace CaffShop.Shared
{
    public class ValidationResult
    {
        public bool IsSuccessful { get; set; }
        public List<string> Errors { get; set; } = new List<string>();
    }

    public class FileValidationResult : ValidationResult
    {
        public byte[] CaffFile { get; set; }
        public string FullPath { get; set; }
        public string FullName { get; set; }

    }
}

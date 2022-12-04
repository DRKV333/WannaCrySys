using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.Exceptions
{
  public abstract class CustomException : Exception
  {
    public int StatusCode { get; }

    public CustomException(HttpStatusCode statusCode, string message) : base(message)
    {
      StatusCode = (int)statusCode;
    }
  }
}

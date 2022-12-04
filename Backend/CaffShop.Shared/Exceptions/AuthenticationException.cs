using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.Exceptions
{
  public class AuthenticationException : CustomException
  {
    public AuthenticationException(string msg) : base(HttpStatusCode.Unauthorized, msg)
    {
    }
  }
}

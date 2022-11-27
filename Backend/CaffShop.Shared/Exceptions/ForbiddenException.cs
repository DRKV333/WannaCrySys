using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.Shared.Exceptions
{
  public class ForbiddenException : CustomException
  {
    public ForbiddenException(string msg) : base(HttpStatusCode.Forbidden, msg)
    {
    }
  }
}

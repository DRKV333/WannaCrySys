using System;
using System.Net;
using System.Runtime.Serialization;

namespace CaffShop.Shared.Exceptions
{
  public class EntityNotFoundException : CustomException
  {
    public EntityNotFoundException(string msg): base(HttpStatusCode.NotFound, msg)
    {
    }
  }
}

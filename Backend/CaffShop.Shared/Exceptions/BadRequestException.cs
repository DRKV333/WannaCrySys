using System;
using System.Net;
using System.Runtime.Serialization;

namespace CaffShop.Shared.Exceptions
{
  public class BadRequestException : CustomException
  {
    public BadRequestException(string msg) : base(HttpStatusCode.BadRequest, msg)
    {
    }
  }
}
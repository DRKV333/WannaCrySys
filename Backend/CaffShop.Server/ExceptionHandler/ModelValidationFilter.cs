using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;
using CaffShop.Shared.Exceptions;

namespace CaffShop.Server.ExceptionHandler
{
  public class ModelValidationFilter : IActionFilter
  {
    public void OnActionExecuting(ActionExecutingContext context)
    {
      if (!context.ModelState.IsValid)
      {
        context.Result = new UnprocessableEntityObjectResult(context.ModelState);
      }
    }

    public void OnActionExecuted(ActionExecutedContext context) { }
  }
}

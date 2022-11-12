using CaffShop.BLL.Interfaces;
using CaffShop.BLL.Managers;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Parking.Server.Controllers;

namespace CaffShop.Server.Controllers
{
  [ApiController]
  [Route("[controller]")]
  public class CaffController : ControllerBase
  {
    private readonly ICaffManager _caffManager;
    private readonly ILogger<CaffController> _logger;

    public CaffController(ICaffManager caffManager, ILogger<CaffController> logger)
    {
      _caffManager = caffManager;
      _logger = logger;
    }
  }
}

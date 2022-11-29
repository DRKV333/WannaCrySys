using CaffShop.BLL.Interfaces;
using CaffShop.BLL.Managers;
using CaffShop.Shared.DTOs;
using CaffShop.Shared;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;
using CaffShop.Server.ExceptionHandler;
using CaffShop.Shared.Exceptions;
using MySqlX.XDevAPI.Common;
using WatchDog;
using FileInfo = CaffShop.Shared.FileInfo;

namespace CaffShop.Server.Controllers
{
  [ApiController]
  [Authorize]
  [Route("[controller]")]
  public class CaffController : ControllerBase
  {
    private readonly ICaffManager _caffManager;
    private readonly CaffShopUserManager _userManager;
    private readonly ILogger<CaffController> _logger;

    public CaffController(ICaffManager caffManager, CaffShopUserManager userManager, ILogger<CaffController> logger)
    {
      _caffManager = caffManager;
      _userManager = userManager;
      _logger = logger;
    }

    [HttpGet("GetCaffList")]
    public async Task<List<CaffListItemDto>> GetCaffList(string? title = "")
    {
      return await _caffManager.GetCaffList(title);
    }

    [HttpGet("GetCaff")]
    public async Task<CaffDto> GetCaff(int caffId)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      var caff = await _caffManager.GetCaff(caffId, user.Id);

      if (caff == null)
      {
        WatchLogger.Log($"Caff does not exist with the given ID: {caffId}");
        throw new EntityNotFoundException($"Caff does not exist with the given ID: {caffId}");
      }

      return caff;
    }

    [HttpPost("PurchaseCaff")]
    public async Task<IActionResult> PurchaseCaff(int caffId)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      await _caffManager.PurchaseCaff(user.Id, caffId);
      return StatusCode(204);
    }

    [HttpPost("AddComment")]
    public async Task<IActionResult> AddComment(int caffId, string content)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      await _caffManager.AddComment(user.Id, caffId, content);
      return StatusCode(201);
    }

    [HttpPut("EditComment")]
    public async Task<IActionResult> EditComment(int commentId, string content)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      await _caffManager.EditComment(user.Id, commentId, content);
      return StatusCode(204);
    }

    [HttpDelete("DeleteComment")]
    public async Task<IActionResult> DeleteComment(int commentId)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      await _caffManager.DeleteComment(user.Id, commentId);
      return StatusCode(204);
    }

    [HttpPost("AddNewCaff")]
    [RequestSizeLimit(67108864)]
    public async Task<IActionResult> AddNewCaff([FromForm] CaffForEditingDto caffDto)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      await _caffManager.AddNewCaff(user.Id, caffDto);
      return StatusCode(201);
    }

    [HttpPut("EditCaff")]
    [RequestSizeLimit(67108864)]
    public async Task<IActionResult> EditCaff(int caffId, [FromForm] CaffForEditingDto caffDto)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      await _caffManager.EditCaff(user.Id, caffId, caffDto);
      return StatusCode(204);
    }

    [HttpDelete("DeleteCaff")]
    public async Task<IActionResult> DeleteCaff(int caffId)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      await _caffManager.DeleteCaff(user.Id, caffId);
      return StatusCode(204);
    }

    [HttpGet("DownloadCaffFile")]
    public async Task<ActionResult> DownloadCaffFile(int caffId)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      FileInfo result = await _caffManager.DownloadCaffFile(user.Id, caffId);
      var provider = new FileExtensionContentTypeProvider();
      provider.Mappings.Add(".caff", "application/text");
      if (!provider.TryGetContentType(result.FullPath, out var contentType))
      {
        contentType = "application/octet-stream";
      }
      return File(result.CaffFile, contentType, result.FullName);
    }
  }
}

using CaffShop.BLL.Interfaces;
using CaffShop.BLL.Managers;
using CaffShop.Shared.DTOs;
using CaffShop.Shared;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Parking.Server.Controllers;
using System.Diagnostics;
using System.Net;

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
    public async Task<List<CaffListItemDto>> GetCaffList(string title)
    {
      return await _caffManager.GetCaffList(title);
    }

    [HttpGet("GetCaff")]
    public async Task<CaffDto> GetCaff(int caffId)
    {
      return await _caffManager.GetCaff(caffId);
    }

    [HttpPost("PurchaseCaff")]
    public async Task<IActionResult> PurchaseCaff(int caffId)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      ValidationResult result = await _caffManager.PurchaseCaff(user.Id, caffId);

      if (!result.IsSuccessful)
      {
        return BadRequest(result.Errors);
      }

      return Ok();
    }

    [HttpPost("AddComment")]
    public async Task<IActionResult> AddComment(int caffId, string content)
    {
      if (string.IsNullOrEmpty(content))
      {
        return BadRequest("There is no given content");
      }

      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      ValidationResult result = await _caffManager.AddComment(user.Id, caffId, content);

      if (!result.IsSuccessful)
      {
        return BadRequest(result.Errors);
      }

      return Ok();
    }

    [HttpPut("EditComment")]
    public async Task<IActionResult> EditComment(int commentId, string content)
    {
      if (string.IsNullOrEmpty(content))
      {
        return BadRequest("There is no given content");
      }

      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      ValidationResult result = await _caffManager.EditComment(user.Id, commentId, content);

      if (!result.IsSuccessful)
      {
        return BadRequest(result.Errors);
      }

      return Ok();
    }

    [HttpDelete("DeleteComment")]
    public async Task<IActionResult> DeleteComment(int commentId)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      ValidationResult result = await _caffManager.DeleteComment(user.Id, commentId);

      if (!result.IsSuccessful)
      {
        return BadRequest(result.Errors);
      }

      return Ok();
    }

    [HttpPost("AddNewCaff")]
    public async Task<IActionResult> AddNewCaff([FromForm] CaffForEditingDto caffDto)
    {
      if (!ModelState.IsValid)
      {
        return BadRequest();
      }

      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      ValidationResult result = await _caffManager.AddNewCaff(user.Id, caffDto);

      if (!result.IsSuccessful)
      {
        return BadRequest(result.Errors);
      }

      return Ok();
    }

    [HttpPut("EditCaff")]
    public async Task<IActionResult> EditCaff(int caffId, [FromForm] CaffForEditingDto caffDto)
    {
      if (!ModelState.IsValid)
      {
        return BadRequest();
      }

      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      ValidationResult result = await _caffManager.EditCaff(user.Id, caffId, caffDto);

      if (!result.IsSuccessful)
      {
        return BadRequest(result.Errors);
      }

      return Ok();
    }

    [HttpDelete("DeleteCaff")]
    public async Task<IActionResult> DeleteCaff(int caffId)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      ValidationResult result = await _caffManager.DeleteCaff(user.Id, caffId);

      if (!result.IsSuccessful)
      {
        return BadRequest(result.Errors);
      }

      return Ok();
    }

    [HttpGet("DownloadCaffFile")]
    public async Task<IActionResult> DownloadCaffFile(int caffId)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      
      ValidationResult result = await _caffManager.DownloadCaffFile(user.Id, caffId);

      if (!result.IsSuccessful)
      {
        return BadRequest(result.Errors);
      }

      return Ok();
    }
  }
}

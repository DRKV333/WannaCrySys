using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Authorization;
using CaffShop.BLL.Managers;
using CaffShop.BLL.Interfaces;
using CaffShop.Shared;
using CaffShop.Shared.DTOs;
using CaffShop.DAL.Entities;

namespace Parking.Server.Controllers
{
  [ApiController]
  [Route("[controller]")]
  public class AuthController : ControllerBase
  {
    private readonly CaffShopUserManager _userManager;
    private readonly ITokenManager _tokenManager;
    private readonly ILogger<AuthController> _logger;

    public AuthController(CaffShopUserManager userManager, ITokenManager tokenManager, IConfiguration configuration, ILogger<AuthController> logger)
    {
      _userManager = userManager;
      _tokenManager = tokenManager;
      _logger = logger;
    }

    [HttpPost("Register")]
    public async Task<IActionResult> Register([FromBody] UserForRegistrationDto userForRegistration)
    {
      if (!ModelState.IsValid)
      {
        return BadRequest();
      }

      User user = new User
      {
        UserName = userForRegistration.Username,
        Name = userForRegistration.Name
      };

      var result = await _userManager.CreateAsync(user, userForRegistration.Username);
      if (!result.Succeeded)
      {
        var errors = result.Errors.Select(e => e.Description).ToList();
        return BadRequest(errors);
      }

      await _userManager.AddToRoleAsync(user, "User");

      return StatusCode(201);
    }

    [HttpPost("Login")]
    public async Task<IActionResult> Login(string username, string password)
    {
      var user = await _userManager.FindByNameAsync(username);

      if (user == null || !await _userManager.CheckPasswordAsync(user, password))
      {
        return Unauthorized("Invalid Authentication");
      }

      var signingCredentials = _tokenManager.GetSigningCredentials();
      var claims = await _tokenManager.GetClaims(user);
      var tokenOptions = _tokenManager.GenerateTokenOptions(signingCredentials, claims);
      var token = new JwtSecurityTokenHandler().WriteToken(tokenOptions);
      await _userManager.UpdateAsync(user);

      return Ok(token);
    }

    [Authorize]
    [HttpGet("GetUser")]
    public async Task<UserDto> GetUser()
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      return await _userManager.GetUser(user.Id);
    }

    [Authorize]
    [HttpPost("EditUser")]
    public async Task<IActionResult> EditUser([FromBody] UserForUpdate userDto)
    {
      if (!ModelState.IsValid)
      {
        return BadRequest();
      }

      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      user.Name = userDto.Name;
      await _userManager.UpdateAsync(user);
      var token = await _userManager.GeneratePasswordResetTokenAsync(user);
      if (string.IsNullOrEmpty(userDto.Password))
      {
        await _userManager.ResetPasswordAsync(user, token, userDto.Password);
      }

      return Ok();
    }
  }
}

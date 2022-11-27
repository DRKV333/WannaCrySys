using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Authorization;
using CaffShop.BLL.Managers;
using CaffShop.BLL.Interfaces;
using CaffShop.Shared;
using CaffShop.Shared.DTOs;
using CaffShop.DAL.Entities;
using System.Net;
using CaffShop.Server.ExceptionHandler;
using CaffShop.Shared.Exceptions;
using WatchDog;
using MySqlX.XDevAPI.Common;

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
      User user = new User
      {
        UserName = userForRegistration.Username,
        Name = userForRegistration.Name
      };

      var result = await _userManager.CreateAsync(user, userForRegistration.Password);
      if (!result.Succeeded)
      {
        WatchLogger.Log(result.Errors.First().Description);
        throw new UnprocessableEntityException(result.Errors.First().Description);
      }

      await _userManager.AddToRoleAsync(user, "User");
      return StatusCode(201);
    }

    [HttpPost("Login")]
    public async Task<IActionResult> Login([FromBody]LoginInfo info)
    {
      var user = await _userManager.FindByNameAsync(info.Username);

      if (user == null || !await _userManager.CheckPasswordAsync(user, info.Password))
      {
        WatchLogger.Log("Invalid Authentication");
        throw new AuthenticationException("Invalid Authentication");
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
      var currentUser = await _userManager.FindByNameAsync(User.Identity?.Name);
      var user = await _userManager.GetUser(currentUser.Id);

      if (user == null)
      {
        WatchLogger.Log($"User does not exist with the given ID: {currentUser.Id}");
        throw new EntityNotFoundException($"User does not exist with the given ID: {currentUser.Id}");
      }
      return user;
    }

    [Authorize]
    [HttpPut("EditUser")]
    public async Task<IActionResult> EditUser([FromBody] UserForUpdate userDto)
    {
      var user = await _userManager.FindByNameAsync(User.Identity?.Name);
      user.Name = userDto.Name;
      var result = await _userManager.UpdateAsync(user);
      if (!result.Succeeded)
      {
        WatchLogger.Log(result.Errors.First().Description);
        throw new UnprocessableEntityException(result.Errors.First().Description);
      }

      if (!string.IsNullOrEmpty(userDto.Password))
      {
        var token = await _userManager.GeneratePasswordResetTokenAsync(user);
        result = await _userManager.ResetPasswordAsync(user, token, userDto.Password);
        if (!result.Succeeded)
        {
          WatchLogger.Log(result.Errors.First().Description);
          throw new UnprocessableEntityException(result.Errors.First().Description);
        }
      }
      return StatusCode(204);
    }
  }
}

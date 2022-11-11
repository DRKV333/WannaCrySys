using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.AspNetCore.Authorization;
using CaffShop.BLL.Managers;
using CaffShop.BLL.Interfaces;
using CaffShop.Shared;
using CaffShop.Shared.DTOs;
using CaffShop.DAL.Entities;
using CaffShop.Shared.CustomeDTOs;

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

    [HttpPost("CreateUser")]
    public async Task<IActionResult> CreateUser([FromBody]UserForRegistrationDto userForRegistration)
    {
      if (userForRegistration == null || !ModelState.IsValid)
      {
        return BadRequest();
      }

      User user = new User
      { 
        UserName = userForRegistration.Email,
        Name = userForRegistration.Name,
        Email = userForRegistration.Email
      };

      var result = await _userManager.CreateAsync(user, userForRegistration.Password);
      if (!result.Succeeded)
      {
        var errors = result.Errors.Select(e => e.Description);
        return BadRequest(new ServerResponseDto { IsSuccessful = false, Errors = errors });
      }

      await _userManager.AddToRoleAsync(user, "User");

      return StatusCode(201);
    }

    [HttpPost("Login")]
    public async Task<IActionResult> Login(string email, string password)
    {
      var user = await _userManager.FindByEmailAsync(email);

      if (user == null || !await _userManager.CheckPasswordAsync(user, password))
        return Unauthorized(new AuthResponseDto { ErrorMessage = "Invalid Authentication" });

      var signingCredentials = _tokenManager.GetSigningCredentials();
      var claims = await _tokenManager.GetClaims(user);
      var tokenOptions = _tokenManager.GenerateTokenOptions(signingCredentials, claims);
      var token = new JwtSecurityTokenHandler().WriteToken(tokenOptions);
      await _userManager.UpdateAsync(user);

      return Ok(new AuthResponseDto { IsAuthSuccessful = true, Token = token });
    }

    [Authorize]
    [HttpGet("GetUser")]
    public async Task<UserDto> GetUser()
    {
      var user = await _userManager.FindByEmailAsync(User.Identity?.Name);
      return new UserDto { Name = user.Name, Id = user.Id, Email = user.Email };
    }

    [Authorize]
    [HttpPost("EditUser")]
    public async Task EditUser([FromBody] UserForUpdate userDto)
    {
      var currentUser = await _userManager.FindByEmailAsync(User.Identity?.Name);
      var user = await _userManager.FindByIdAsync(currentUser.Id.ToString());
      if (user != null) {
        user.Name = userDto.Name;
        await _userManager.UpdateAsync(user);
        var token = await _userManager.GeneratePasswordResetTokenAsync(user);
        if (userDto.Password.Length > 5)
        {
          var result = await _userManager.ResetPasswordAsync(user, token, userDto.Password);
        }

      }
    }
  }
}

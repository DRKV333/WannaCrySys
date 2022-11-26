using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using CaffShop.BLL.Interfaces;
using CaffShop.DAL.Entities;

namespace CaffShop.BLL.Managers
{
  public class TokenManager : ITokenManager
  {
    private readonly IConfiguration _configuration;
    private readonly IConfigurationSection _jwtSettings;
    private readonly UserManager<User> _userManager;
    public TokenManager(IConfiguration configuration, UserManager<User> userManager)
    {
      _configuration = configuration;
      _jwtSettings = _configuration.GetSection("JwtSettings");
      _userManager = userManager;
    }

    public SigningCredentials GetSigningCredentials()
    {
      var key = Encoding.UTF8.GetBytes(_jwtSettings.GetSection("securityKey").Value);
      var secret = new SymmetricSecurityKey(key);

      return new SigningCredentials(secret, SecurityAlgorithms.HmacSha256);
    }

    public async Task<List<Claim>> GetClaims(User user)
    {
      var claims = new List<Claim>
      {
        new Claim("username", user.UserName),
        new Claim(ClaimTypes.Name, user.UserName)
    };

      var roles = await _userManager.GetRolesAsync(user);
      foreach (var role in roles)
      {
        claims.Add(new Claim("role", role));
        claims.Add(new Claim(ClaimTypes.Role, role));
      }

      return claims;
    }

    public JwtSecurityToken GenerateTokenOptions(SigningCredentials signingCredentials, List<Claim> claims)
    {
      var tokenOptions = new JwtSecurityToken(
        issuer: _jwtSettings.GetSection("validIssuer").Value,
        audience: _jwtSettings.GetSection("validAudience").Value,
        claims: claims,
        expires: DateTime.Now.AddMinutes(Convert.ToDouble(_jwtSettings.GetSection("expiryInMinutes").Value)),
        signingCredentials: signingCredentials);

      return tokenOptions;
    }
  }
}


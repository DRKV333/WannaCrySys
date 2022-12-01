using CaffShop.Shared.DTOs;
using Microsoft.AspNetCore.Mvc.Testing;
using System.Net;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using Ubiety.Dns.Core;

namespace CaffShop.Test
{
  [TestClass]
  public class CaffTests
  {
    private readonly JsonSerializerOptions _options;
    public CaffTests()
    {
      _options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
    }

    [TestMethod]
    public async Task Default()
    {
      var webAppFactory = new WebApplicationFactory<Program>();
      var httpClient = webAppFactory.CreateDefaultClient();
      httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IkNhZmZBZG1pbiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJDYWZmQWRtaW4iLCJyb2xlIjoiVXNlciIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlVzZXIiLCJleHAiOjE2Njk4MzE2NTAsImlzcyI6Iklzc3Vlck5hbWUifQ.JDKByUBMbpz2Sfdr1DLX2_HsUwp2YpMS6d0znf4vBa4");
      var res = await httpClient.GetAsync("/caff/GetCaffList");
      Assert.AreEqual(HttpStatusCode.Unauthorized, res.StatusCode);
    }

    [TestMethod]
    public async Task Login()
    {
      var webAppFactory = new WebApplicationFactory<Program>();
      var httpClient = webAppFactory.CreateDefaultClient();

      LoginInfo info = new LoginInfo()
      {
        Username = "CaffAdmin",
        Password = "$Admin123"
      };

      var content = JsonSerializer.Serialize(info);
      var bodyContent = new StringContent(content, Encoding.UTF8, "application/json");
      var authResult = await httpClient.PostAsync("auth/login", bodyContent);
      var authContent = await authResult.Content.ReadAsStringAsync();
      Console.WriteLine(authContent);
      Assert.IsNotNull(authContent);
    }
  }
}
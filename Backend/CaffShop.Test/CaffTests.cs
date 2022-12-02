using CaffShop.Shared.DTOs;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.WebUtilities;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;
using Ubiety.Dns.Core;

namespace CaffShop.Test
{
  [TestClass]
  public class CaffTests
  {
    private readonly JsonSerializerOptions _options;
    private static WebApplicationFactory<Program> _factory;
    private static HttpClient _httpClient;

    public CaffTests()
    {
      _options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
    }

    [ClassInitialize]
    public static async Task InitAsync(TestContext context)
    {
      _factory = new WebApplicationFactory<Program>();
      _httpClient = _factory.CreateDefaultClient();

      LoginInfo info = new LoginInfo()
      {
        Username = "TestUser",
        Password = "$Test123"
      };

      var content = JsonSerializer.Serialize(info);
      var bodyContent = new StringContent(content, Encoding.UTF8, "application/json");
      var authResult = await CaffTests._httpClient.PostAsync("auth/login", bodyContent);
      var token = await authResult.Content.ReadAsStringAsync();
      CaffTests._httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
    }

    [TestMethod]
    public async Task GetUserTest()
    {
      var res = await CaffTests._httpClient.GetFromJsonAsync<UserDto>("auth/GetUser");
      Assert.AreEqual(res.UserName, "TestUser");
    }

    [TestMethod]
    public async Task EditUserTest()
    {
      UserForUpdate user = new UserForUpdate()
      {
        Name = "Test User2",
        Password = "",
        ConfirmPassword = ""
      };

      var content = JsonSerializer.Serialize(user);
      var bodyContent = new StringContent(content, Encoding.UTF8, "application/json");
      var res = await CaffTests._httpClient.PutAsync("auth/EditUser", bodyContent);
      Assert.AreEqual(HttpStatusCode.NoContent, res.StatusCode);

      var edited = await CaffTests._httpClient.GetFromJsonAsync<UserDto>("auth/GetUser");
      Assert.AreEqual(edited.Name, "Test User2");

      user.Name = "Test User";
      content = JsonSerializer.Serialize(user);
      bodyContent = new StringContent(content, Encoding.UTF8, "application/json");
      res = await CaffTests._httpClient.PutAsync("auth/EditUser", bodyContent);
      Assert.AreEqual(HttpStatusCode.NoContent, res.StatusCode);
    }

    [TestMethod]
    public async Task GetCaffTest()
    {
      var res = await CaffTests._httpClient.GetFromJsonAsync<CaffDto>(QueryHelpers.AddQueryString("caff/GetCaff", "caffId", "1"));
      Assert.AreEqual(res.Title, "Caff test entity");
    }

    [TestMethod]
    public async Task GetNotExistingCaffTest()
    {
      var res = await CaffTests._httpClient.GetAsync(QueryHelpers.AddQueryString("caff/GetCaff", "caffId", "9999999"));
      Assert.AreEqual(HttpStatusCode.NotFound, res.StatusCode);
    }

    [TestMethod]
    public async Task GetCaffListTest()
    {
      var res = await CaffTests._httpClient.GetFromJsonAsync<List<CaffListItemDto>>(QueryHelpers.AddQueryString("caff/GetCaffList", "title", ""));
      Assert.AreNotEqual(res.Count, 0);
    }

    [TestMethod]
    public async Task GetCaffFilteredListTest()
    {
      var res = await CaffTests._httpClient.GetFromJsonAsync<List<CaffListItemDto>> (QueryHelpers.AddQueryString("caff/GetCaffList", "title", "Caff test entity"));
      Assert.AreEqual(res.Count, 1);
    }

    [TestMethod]
    public async Task GetCaffFilteredListWithZeroEntityTest()
    {
      var res = await CaffTests._httpClient.GetFromJsonAsync<List<CaffListItemDto>>(QueryHelpers.AddQueryString("caff/GetCaffList", "title", "sdwedyxsdfasdfg56ce66196as849"));
      Assert.AreEqual(res.Count, 0);
    }

    [TestMethod]
    public async Task PurchaseCaffTest()
    {
      var caffBefore = await CaffTests._httpClient.GetFromJsonAsync<CaffDto>(QueryHelpers.AddQueryString("caff/GetCaff", "caffId", "1"));
      var res = await CaffTests._httpClient.PostAsync("caff/PurchaseCaff?caffId=1", null);
      Assert.AreEqual(HttpStatusCode.NoContent, res.StatusCode);
      var caffAfter = await CaffTests._httpClient.GetFromJsonAsync<CaffDto>(QueryHelpers.AddQueryString("caff/GetCaff", "caffId", "1"));
      Assert.AreEqual(caffBefore.NumberOfPurchases + 1, caffAfter.NumberOfPurchases);
    }

    [TestMethod]
    public async Task DeleteNotExistingCommentTest()
    {
      var res = await CaffTests._httpClient.DeleteAsync(QueryHelpers.AddQueryString("caff/DeleteComment", "commentId", "999999"));
      Assert.AreEqual(HttpStatusCode.NotFound, res.StatusCode);
    }

    [TestMethod]
    public async Task AddCommentToNotExistingCaffTest()
    {
      var res = await CaffTests._httpClient.PostAsync("caff/AddComment?caffId=999999&content=asd", null);
      Assert.AreEqual(HttpStatusCode.NotFound, res.StatusCode);
    }

    [TestMethod]
    public async Task AddCommentToExistingCaffTest()
    {
      var res = await CaffTests._httpClient.PostAsync("caff/AddComment?caffId=1&content=teszt", null);
      Assert.AreEqual(HttpStatusCode.Created, res.StatusCode);
    }

    [TestMethod]
    public async Task EditCommenWithNoContentTest()
    {
      var res = await CaffTests._httpClient.PutAsync("caff/EditComment?commentId=1", null);
      Assert.AreEqual(HttpStatusCode.UnprocessableEntity, res.StatusCode);
    }

    [TestMethod]
    public async Task EditNotExistingCommentTest()
    {
      var res = await CaffTests._httpClient.PutAsync("caff/EditComment?commentId=999999&content=teszt2", null);
      Assert.AreEqual(HttpStatusCode.NotFound, res.StatusCode);
    }
  }
}
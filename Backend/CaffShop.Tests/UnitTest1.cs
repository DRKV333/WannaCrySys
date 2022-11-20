using CaffShop.BLL.Interfaces;
using CaffShop.BLL.Managers;
using CaffShop.DAL;
using CaffShop.DAL.Entities;
using CaffShop.Server.Controllers;
using CaffShop.Shared.CustomeDTOs;
using CaffShop.Shared.DTOs;
using CaffShop.Test;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.TestHost;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using System.Net.Sockets;

namespace CaffShop.Tests
{
  public class UnitTest1
  {
    private  TestServer _server;
    private  HttpClient _client;


    [Fact]
    public async void Test1()
    {
      //// Arrange
      //var entities = new List<Caff>();
      //entities.Add(new Caff
      //{
      //  Id = 1,
      //  Title = "TEST NAME"
      //});

      //var mock = new Mock<DbSet<Caff>>();
      //var mockContext = new Mock<CaffShopDbContext>();
      //mockContext.Setup(m => m.Caffs).Returns(DbContextMock.GetQueryableMockDbSet<Caff>(entities));






      //// Act

      //var service = new CaffManager(mockUsermanager.Object, mockFileSettings.Object, mockContext.Object);
      //var res = service.GetCaffList("");

      //// Assert
      //Assert.NotNull(res);


      //create In Memory Database
      //    var options = new DbContextOptionsBuilder<CaffShopDbContext>()
      //.UseInMemoryDatabase(databaseName: "CaffDataBase")
      //.Options;

      //    using (var context = new CaffShopDbContext(options))
      //    {
      //      context.Caffs.Add(new Caff
      //      {
      //        Id = 1,
      //        Title = "USA",
      //        FileName = "asd",
      //        ImgURL = "asd",
      //        UniqueFileName = "ds"
      //      });

      //      context.Caffs.Add(new Caff
      //      {
      //        Id = 2,
      //        Title = "UK",
      //        FileName = "asd",
      //        ImgURL = "asd",
      //        UniqueFileName = "ds"
      //      });
      //      context.SaveChanges();
      //    }

      //    var mockIUserStore = new Mock<IUserStore<User>>();
      //    var mockIOptions = new Mock<IOptions<IdentityOptions>>();
      //    var mockIPasswordHasher = new Mock<IPasswordHasher<User>>();
      //    var mockUserValidators = new Mock<IEnumerable<IUserValidator<User>>>();
      //    var mockpasswordValidators = new Mock<IEnumerable<IPasswordValidator<User>>>();
      //    var mockkeyNormalizer = new Mock<ILookupNormalizer>();
      //    var mockerrors = new Mock<IdentityErrorDescriber>();
      //    var mockservices = new Mock<IServiceProvider>();
      //    var mocklogger = new Mock<ILogger<UserManager<User>>>();
      //    IUserStore<User> a = new UserStore<User>();

      //    CaffShopUserManager usermanager = new CaffShopUserManager(mockIUserStore.Object,
      //      mockIOptions.Object, mockIPasswordHasher.Object, mockUserValidators.Object, mockpasswordValidators.Object,
      //      mockkeyNormalizer.Object, mockerrors.Object, mockservices.Object, mocklogger.Object);

      //    using (var context = new CaffShopDbContext(options))
      //    {

      //      var mockFileSettings = new Mock<IFileSettings>();
      //      CaffManager manager = new CaffManager(usermanager, mockFileSettings.Object, context);

      //      var result = await manager.GetCaffList("") as List<CaffListItemDto>;

      //      Assert.NotNull(result);

      _server = new TestServer(new WebHostBuilder()
          .UseStartup<Startup>());
      _client = _server.CreateClient();
      Assert.NotNull(a);
    }

    }

  }

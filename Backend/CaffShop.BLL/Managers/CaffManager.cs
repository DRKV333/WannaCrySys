using CaffShop.BLL.Interfaces;
using CaffShop.DAL;
using CaffShop.DAL.Entities;
using CaffShop.Shared;
using CaffShop.Shared.CustomeDTOs;
using CaffShop.Shared.DTOs;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace CaffShop.BLL.Managers
{
  public class CaffManager : ICaffManager
  {
    private readonly CaffShopUserManager _userManager;
    private readonly IFileSettings _fileSettings;
    private readonly CaffShopDbContext _dbContext;
    public CaffManager(CaffShopUserManager userManager, IFileSettings fileSettings, CaffShopDbContext dbContext)
    {
      _userManager = userManager;
      _fileSettings = fileSettings;
      _dbContext = dbContext;
    }

    public async Task<List<CaffListItemDto>> GetCaffList(string title)
    {
      return _dbContext.Caffs.Where(p => p.Title.Contains(title)).Select(p => new CaffListItemDto
      {
        Id = p.Id,
        Title = p.Title,
        ImgURL = p.ImgURL
      }).ToList();
    }

    public async Task<CaffDto> GetCaff(int caffId)
    {
      return _dbContext.Caffs.Where(p => p.Id == caffId).Select(p => new CaffDto
      {
        Id = p.Id,
        Title = p.Title,
        ImgURL = p.ImgURL,
        CreatedDate = p.CreatedDate,
        OwnerName = p.Owner.Name,
        NumberOfPurchases = p.Purchases.Count,
        Comments = p.Comments.Select(c => new CommentDto
        {
          Id = c.Id,

          Content = c.Content,
          CreatedDate = c.CreatedDate,
          UserName = c.User.Name
        }).ToList()
      }).FirstOrDefault();
    }

    public async Task<ValidationResult> PurchaseCaff(int userId, int caffId)
    {
      ValidationResult result = new ValidationResult();

      Caff dbEntity = _dbContext.Caffs.Find(caffId);
      if (dbEntity == null)
      {
        result.Errors.Add($"Caff does not exist with the given ID: {caffId}");
        return result;
      }

      _dbContext.Purchases.Add(new Purchase
      {
        UserId = userId,
        CaffId = caffId
      });
      _dbContext.SaveChanges();

      result.IsSuccessful = true;
      return result;
    }

    public async Task<ValidationResult> AddComment(int userId, int caffId, string content)
    {
      ValidationResult result = new ValidationResult();

      Caff dbEntity = _dbContext.Caffs.Find(caffId);
      if (dbEntity == null)
      {
        result.Errors.Add($"Caff does not exist with the given ID: {caffId}");
        return result;
      }

      _dbContext.Comments.Add(new Comment
      {
        UserId = userId,
        CaffId = caffId,
        Content = content
      });
      
      _dbContext.SaveChanges();

      result.IsSuccessful = true;
      return result;
    }

    public async Task<ValidationResult> EditComment(int userId, int commentId, string newContent)
    {
      ValidationResult result = new ValidationResult();

      Comment dbEntity = _dbContext.Comments.Find(commentId);
      if (dbEntity == null)
      {
        result.Errors.Add($"Comment does not exist with the given ID: {commentId}");
        return result;
      }

      var user = await _userManager.FindByIdAsync(userId.ToString());
      if (dbEntity.UserId != userId && !(await _userManager.IsInRoleAsync(user, "Administrator")))
      {
        result.Errors.Add($"User with ID: {userId} can not edit this comment");
        return result;
      }

      dbEntity.Content = newContent;
      _dbContext.Comments.Update(dbEntity);
      _dbContext.SaveChanges();

      result.IsSuccessful = true;
      return result;
    }

    public async Task<ValidationResult> DeleteComment(int userId, int commentId)
    {
      ValidationResult result = new ValidationResult();

      Comment dbEntity = _dbContext.Comments.Find(commentId);

      var user = await _userManager.FindByIdAsync(userId.ToString());
      if (dbEntity.UserId != userId && !(await _userManager.IsInRoleAsync(user, "Administrator")))
      {
        result.Errors.Add($"User with ID: {userId} can not delete this comment");
        return result;
      }

      _dbContext.Comments.Remove(dbEntity);
      _dbContext.SaveChanges();

      result.IsSuccessful = true;
      return result;
    }


    [DllImport("libcaff", SetLastError = true)]
    private static extern bool libcaff_makePreview(string inPath, string outPath, long maxDecodeSize = 100000000);


    [DllImport("libcaff")]
    private static extern string libcaff_getLastError();

    public async Task<ValidationResult> AddNewCaff(int userId, CaffForEditingDto newCaffDto)
    {
      ValidationResult result = ValidateUploadedFile(newCaffDto.CaffFile);
      if (!result.IsSuccessful)
      {
        return result;
      }

      try
      {
        string guid = Guid.NewGuid().ToString();
        string uniqueFileName = guid + ".caff";
        string uniqueImageName = guid + ".png";
        var directoryPath = Path.Combine(Directory.GetCurrentDirectory(), _fileSettings.FilePath);

        if (!Directory.Exists(directoryPath))
        {
            Directory.CreateDirectory(directoryPath);
        }

        var filePath = Path.Combine(directoryPath, uniqueFileName);
        newCaffDto.CaffFile.CopyTo(new FileStream(filePath, FileMode.Create));

        var imageDirectoryPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images");

        if (!Directory.Exists(imageDirectoryPath))
        {
          Directory.CreateDirectory(imageDirectoryPath);
        }

        var imagePath = Path.Combine(imageDirectoryPath, uniqueImageName);

        bool IsSuccessful = libcaff_makePreview(filePath, imagePath);
        if (!IsSuccessful)
        {
          result.Errors.Add(libcaff_getLastError());
          return result;
        }

        _dbContext.Caffs.Add(new Caff
        {
          Title = newCaffDto.Title,
          OwnerId = userId,
          FileName = newCaffDto.CaffFile.FileName,
          UniqueFileName = uniqueFileName,
          ImgURL = "images\\" + uniqueImageName
        });

        _dbContext.SaveChanges();
      }
      catch (Exception ex)
      {
        result.IsSuccessful = false;
        result.Errors.Add(ex.Message);
      }

      return result;
    }

    public async Task<ValidationResult> EditCaff(int userId, int caffId, CaffForEditingDto newCaffDto)
    {
      ValidationResult result = new ValidationResult();
      result.IsSuccessful = true;

      if (newCaffDto.CaffFile != null && newCaffDto.CaffFile.Length > 0)
      {
        result = ValidateUploadedFile(newCaffDto.CaffFile);
        if (!result.IsSuccessful)
        {
          return result;
        }
      }

      Caff dbEntity = _dbContext.Caffs.Where(c => c.Id == caffId).FirstOrDefault();
      if (dbEntity == null)
      {
        result.IsSuccessful = false;
        result.Errors.Add($"Caff does not exist with the given ID: {caffId}");
        return result;
      }

      var user = await _userManager.FindByIdAsync(userId.ToString());
      if (dbEntity.OwnerId != userId && !(await _userManager.IsInRoleAsync(user, "Administrator")))
      {
        result.Errors.Add($"User with ID: {userId} can not edit this caff");
        return result;
      }

      try
      {
        if (newCaffDto.CaffFile != null && newCaffDto.CaffFile.Length > 0)
        {
          string guid = Guid.NewGuid().ToString();
          string uniqueFileName = guid + ".caff";
          string uniqueImageName = guid + ".png";
          var directoryPath = Path.Combine(Directory.GetCurrentDirectory(), _fileSettings.FilePath);

          if (!Directory.Exists(directoryPath))
          {
            Directory.CreateDirectory(directoryPath);
          }

          var filePath = Path.Combine(directoryPath, uniqueFileName);
          newCaffDto.CaffFile.CopyTo(new FileStream(filePath, FileMode.Create));

          var imageDirectoryPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "images");

          if (!Directory.Exists(imageDirectoryPath))
          {
            Directory.CreateDirectory(imageDirectoryPath);
          }

          var imagePath = Path.Combine(imageDirectoryPath, uniqueImageName);

          bool IsSuccessful = libcaff_makePreview(filePath, imagePath);
          if (!IsSuccessful)
          {
            result.Errors.Add(libcaff_getLastError());
            return result;
          }

          dbEntity.FileName = newCaffDto.CaffFile.FileName;
          dbEntity.UniqueFileName = uniqueFileName;
          dbEntity.ImgURL = "images\\" + uniqueImageName;
        }

        dbEntity.Title = newCaffDto.Title;
        _dbContext.Caffs.Update(dbEntity);
        _dbContext.SaveChanges();
      }
      catch (Exception ex)
      {
        result.IsSuccessful = false;
        result.Errors.Add(ex.Message);
      }

      return result;
    }

    public async Task<ValidationResult> DeleteCaff(int userId, int caffId)
    {
      ValidationResult result = new ValidationResult();

      Caff dbEntity = _dbContext.Caffs.Where(c => c.Id == caffId).FirstOrDefault();
      if (dbEntity == null)
      {
        result.Errors.Add($"Caff does not exist with the given ID: {caffId}");
        return result;
      }

      var user = await _userManager.FindByIdAsync(userId.ToString());
      if (dbEntity.OwnerId != userId && !(await _userManager.IsInRoleAsync(user, "Administrator")))
      {
        result.Errors.Add($"User with ID: {userId} can not delete this caff");
        return result;
      }

      var filePath = Path.Combine(Directory.GetCurrentDirectory(), _fileSettings.FilePath, dbEntity.UniqueFileName);
      if (File.Exists(filePath))
      {
        File.Delete(filePath);
      }

      var imagePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", dbEntity.ImgURL);
      if (File.Exists(imagePath))
      {
        File.Delete(imagePath);
      }

      var comments = _dbContext.Comments.Where(c => c.CaffId == caffId).Select(c => c).ToList();
      _dbContext.Comments.RemoveRange(comments);

      var purchases = _dbContext.Purchases.Where(c => c.CaffId == caffId).Select(c => c).ToList();
      _dbContext.Purchases.RemoveRange(purchases);

      _dbContext.Caffs.Remove(dbEntity);
      _dbContext.SaveChanges();

      result.IsSuccessful = true;
      return result;
    }

    private ValidationResult ValidateUploadedFile(IFormFile file) {

      ValidationResult result = new ValidationResult();

      if (file == null || file.Length == 0)
      {
        result.Errors.Add("File is missing");
        return result;
      }

      var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
      if (ext != ".caff")
      {
        result.Errors.Add("Not supported file extension");
        return result;
      }

      if (file.Length > _fileSettings.MaxSizeInMegaBytes * 1024 * 1024)
      {
        result.Errors.Add($"The size of the given file is over the limit ({_fileSettings.MaxSizeInMegaBytes} MB)");
        return result;
      }

      result.IsSuccessful = true;
      return result;
    }
  }
}

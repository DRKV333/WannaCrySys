using CaffShop.BLL.Interfaces;
using CaffShop.DAL;
using CaffShop.DAL.Entities;
using CaffShop.Shared;
using CaffShop.Shared.CustomeDTOs;
using CaffShop.Shared.DTOs;
using CaffShop.Shared.Exceptions;
using Microsoft.AspNetCore.Http;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Runtime.InteropServices;
using WatchDog;
using FileInfo = CaffShop.Shared.FileInfo;

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
      return _dbContext.Caffs.Where(p => p
      .Id == caffId).Select(p => new CaffDto
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

    public async Task PurchaseCaff(int userId, int caffId)
    {
      Caff dbEntity = _dbContext.Caffs.Find(caffId);
      if (dbEntity == null)
      {
        WatchLogger.Log($"Caff does not exist with the given ID: {caffId}");
        throw new EntityNotFoundException($"Caff does not exist with the given ID: {caffId}");
      }

      _dbContext.Purchases.Add(new Purchase
      {
        UserId = userId,
        CaffId = caffId
      });
      _dbContext.SaveChanges();
    }

    public async Task AddComment(int userId, int caffId, string content)
    {
      if (string.IsNullOrEmpty(content))
      {
        WatchLogger.Log($"Comment content is required");
        throw new UnprocessableEntityException($"Comment content is required");
      }
      else if (content.Length > 256)
      {
        WatchLogger.Log($"Comment is too long (max 256 characters allowed)");
        throw new UnprocessableEntityException($"Comment is too long (max 256 characters allowed)");
      }

      Caff dbEntity = _dbContext.Caffs.Find(caffId);
      if (dbEntity == null)
      {
        WatchLogger.Log($"Caff does not exist with the given ID: {caffId}");
        throw new EntityNotFoundException($"Caff does not exist with the given ID: {caffId}");
      }

      _dbContext.Comments.Add(new Comment
      {
        UserId = userId,
        CaffId = caffId,
        Content = content
      });

      _dbContext.SaveChanges();
    }

    public async Task EditComment(int userId, int commentId, string newContent)
    {
      if (string.IsNullOrEmpty(newContent))
      {
        WatchLogger.Log($"Comment content is required");
        throw new UnprocessableEntityException($"Comment content is required");
      }
      else if (newContent.Length > 256)
      {
        WatchLogger.Log($"Comment is too long (max 256 characters allowed)");
        throw new UnprocessableEntityException($"Comment is too long (max 256 characters allowed)");
      }

      Comment dbEntity = _dbContext.Comments.Find(commentId);
      if (dbEntity == null)
      {
        WatchLogger.Log($"Comment does not exist with the given ID: {commentId}");
        throw new EntityNotFoundException($"Comment does not exist with the given ID: {commentId}");
      }

      var user = await _userManager.FindByIdAsync(userId.ToString());
      if (dbEntity.UserId != userId && !(await _userManager.IsInRoleAsync(user, "Administrator")))
      {
        WatchLogger.Log($"User with ID: {userId} can not edit this comment");
        throw new ForbiddenException($"You can not edit this comment");
      }

      dbEntity.Content = newContent;
      _dbContext.Comments.Update(dbEntity);
      _dbContext.SaveChanges();
    }

    public async Task DeleteComment(int userId, int commentId)
    {
      Comment dbEntity = _dbContext.Comments.Find(commentId);
      if (dbEntity == null)
      {
        WatchLogger.Log($"Comment does not exist with the given ID: {commentId}");
        throw new EntityNotFoundException($"Comment does not exist with the given ID: {commentId}");
      }

      var user = await _userManager.FindByIdAsync(userId.ToString());
      if (dbEntity.UserId != userId && !(await _userManager.IsInRoleAsync(user, "Administrator")))
      {
        WatchLogger.Log($"User with ID: {userId} can not delete this comment");
        throw new ForbiddenException($"You can not delete this comment");
      }

      _dbContext.Comments.Remove(dbEntity);
      _dbContext.SaveChanges();
    }


    [DllImport("libcaff", SetLastError = true)]
    private static extern bool libcaff_makePreview(string inPath, string outPath, long maxDecodeSize = 100000000);


    [DllImport("libcaff")]
    private static extern string libcaff_getLastError();

    public async Task AddNewCaff(int userId, CaffForEditingDto newCaffDto)
    {
      ValidationResult result = ValidateUploadedFile(newCaffDto.CaffFile);
      if (!result.IsSuccessful)
      {
        WatchLogger.Log(result.Error);
        throw new UnprocessableEntityException(result.Error);
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
          var error = libcaff_getLastError();
          WatchLogger.Log(error);
          throw new UnprocessableEntityException(error);
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
        throw new Exception(ex.Message);
      }
    }

    public async Task EditCaff(int userId, int caffId, CaffForEditingDto newCaffDto)
    {
      ValidationResult result = new ValidationResult();
      if (newCaffDto.CaffFile != null && newCaffDto.CaffFile.Length > 0)
      {
        result = ValidateUploadedFile(newCaffDto.CaffFile);
        if (!result.IsSuccessful)
        {
          WatchLogger.Log(result.Error);
          throw new UnprocessableEntityException(result.Error);
        }
      }

      Caff dbEntity = _dbContext.Caffs.Where(c => c.Id == caffId).FirstOrDefault();
      if (dbEntity == null)
      {
        WatchLogger.Log($"Caff does not exist with the given ID: {caffId}");
        throw new EntityNotFoundException($"Caff does not exist with the given ID: {caffId}");
      }

      var user = await _userManager.FindByIdAsync(userId.ToString());
      if (dbEntity.OwnerId != userId && !(await _userManager.IsInRoleAsync(user, "Administrator")))
      {
        WatchLogger.Log($"User with ID: {userId} can not edit this caff");
        throw new ForbiddenException($"You can not edit this caff");
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
            var error = libcaff_getLastError();
            WatchLogger.Log(error);
            throw new UnprocessableEntityException(error);
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
        throw new Exception(ex.Message);
      }
    }

    public async Task DeleteCaff(int userId, int caffId)
    {
      Caff dbEntity = _dbContext.Caffs.Where(c => c.Id == caffId).FirstOrDefault();
      if (dbEntity == null)
      {
        WatchLogger.Log($"Caff does not exist with the given ID: {caffId}");
        throw new EntityNotFoundException($"Caff does not exist with the given ID: {caffId}");
      }

      var user = await _userManager.FindByIdAsync(userId.ToString());
      if (dbEntity.OwnerId != userId && !(await _userManager.IsInRoleAsync(user, "Administrator")))
      {
        WatchLogger.Log($"User with ID: {userId} can not delete this caff");
        throw new ForbiddenException($"You can not delete this caff");
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
    }

    public async Task<FileInfo> DownloadCaffFile(int userId, int caffId)
    {
      FileInfo result = new FileInfo();

      Caff dbEntity = _dbContext.Caffs.Where(c => c.Id == caffId).FirstOrDefault();
      if (dbEntity == null)
      {
        WatchLogger.Log($"Caff does not exist with the given ID: {caffId}");
        throw new EntityNotFoundException($"Caff does not exist with the given ID: {caffId}");
      }

      var user = await _userManager.FindByIdAsync(userId.ToString());

      if (!_dbContext.Purchases.Any(p => p.CaffId == caffId && p.UserId == userId) && !(await _userManager.IsInRoleAsync(user, "Administrator")))
      {
        WatchLogger.Log($"User with ID: {userId} can not access this caff file");
        throw new ForbiddenException($"You can not access this caff file");
      }

      var filePath = Path.Combine(Directory.GetCurrentDirectory(), _fileSettings.FilePath, dbEntity.UniqueFileName);
      if (File.Exists(filePath))
      {
        var bytes = await File.ReadAllBytesAsync(filePath);
        result.CaffFile = bytes;
        result.FullName = dbEntity.FileName;
        result.FullPath = filePath;
        return result;
      }
      else
      {
        WatchLogger.Log($"The file does not exist!");
        throw new EntityNotFoundException($"The file does not exist!");
      }
    }

    private ValidationResult ValidateUploadedFile(IFormFile file)
    {
      ValidationResult result = new ValidationResult();
      result.IsSuccessful = true;

      if (file == null || file.Length == 0)
      {
        result.Error = "File is missing";
        return result;
      }

      var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
      if (ext != ".caff")
      {
        result.Error = "Not supported file extension";
        return result;
      }

      if (file.Length > _fileSettings.MaxSizeInMegaBytes * 1024 * 1024)
      {
        result.Error = $"The size of the given file is over the limit ({_fileSettings.MaxSizeInMegaBytes} MB)";
        return result;
      }

      if (file.Length > _fileSettings.MaxSizeInMegaBytes * 1024 * 1024)
      {
        result.Error = $"The size of the given file is over the limit ({_fileSettings.MaxSizeInMegaBytes} MB)";
        return result;
      }

      result.IsSuccessful = true;
      return result;
    }
  }
}


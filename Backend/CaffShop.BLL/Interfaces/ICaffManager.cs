using CaffShop.DAL.Entities;
using CaffShop.Shared.DTOs;
using CaffShop.Shared;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FileInfo = CaffShop.Shared.FileInfo;

namespace CaffShop.BLL.Interfaces
{
  public interface ICaffManager
  {
    Task<List<CaffListItemDto>> GetCaffList(string title);
    Task<CaffDto> GetCaff(int caffId, int userId);
    Task PurchaseCaff(int userId, int caffId);
    Task AddComment(int userId, int caffId, string content);
    Task EditComment(int userId, int commentId, string newContent);
    Task DeleteComment(int userId, int commentId);
    Task AddNewCaff(int userId, CaffForEditingDto newCaffDto);
    Task EditCaff(int userId, int caffId, CaffForEditingDto newCaffDto);
    Task DeleteCaff(int userId, int caffId);
    Task<FileInfo> DownloadCaffFile(int userId, int caffId);
  }
}

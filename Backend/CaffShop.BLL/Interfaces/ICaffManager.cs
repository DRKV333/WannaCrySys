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

namespace CaffShop.BLL.Interfaces
{
  public interface ICaffManager
  {
    Task<List<CaffListItemDto>> GetCaffList(string title);
    Task<CaffDto> GetCaff(int caffId);
    Task<ValidationResult> PurchaseCaff(int userId, int caffId);
    Task<ValidationResult> AddComment(int userId, int caffId, string content);
    Task<ValidationResult> EditComment(int userId, int commentId, string newContent);
    Task<ValidationResult> DeleteComment(int userId, int commentId);
    Task<ValidationResult> AddNewCaff(int userId, CaffForEditingDto newCaffDto);
    Task<ValidationResult> EditCaff(int userId, int caffId, CaffForEditingDto newCaffDto);
    Task<ValidationResult> DeleteCaff(int userId, int caffId);
  }
}

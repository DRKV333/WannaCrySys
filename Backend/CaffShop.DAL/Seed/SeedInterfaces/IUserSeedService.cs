using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace RecipeBook.Dal.SeedInterfaces
{
    public interface IUserSeedService
    {
        Task SeedUserAsync();
    }
}

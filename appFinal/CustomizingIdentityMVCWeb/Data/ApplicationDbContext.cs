using CustomizingIdentityMVCWeb.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace CustomizingIdentityMVCWeb.Data
{
    public class ApplicationDbContext : IdentityDbContext<CustomizingIdentityUser>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }
    }
}
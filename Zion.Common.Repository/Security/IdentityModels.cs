using System.Configuration;
using System.Security.Claims;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Security;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;

namespace HrMaxx.Common.Repository.Security
{
    // You can add profile data for the user by adding more properties to your ApplicationUser class, please visit http://go.microsoft.com/fwlink/?LinkID=317594 to learn more.
    public class ApplicationUser : IdentityUser
    {
			public string FirstName { get; set; }
			public string LastName { get; set; }

        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<ApplicationUser> manager)
        {
            // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
            var userIdentity = await manager.CreateIdentityAsync(this, DefaultAuthenticationTypes.ApplicationCookie);
            // Add custom user claims here
						userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.Version, ConfigurationManager.AppSettings["tokenVersion"]));
						userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.UserID, this.Id));
						userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.Email, this.Email));
						userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.Name, string.Format("{0} {1}", this.FirstName, this.LastName)));
            return userIdentity;
        }
    }

    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext()
            : base("DefaultConnection", throwIfV1Schema: false)
        {
					
        }

        public static ApplicationDbContext Create()
        {
            var context = new ApplicationDbContext();
	        return context;
        }
    }
}
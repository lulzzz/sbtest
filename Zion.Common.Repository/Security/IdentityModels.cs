using System;
using System.Configuration;
using System.Security.Claims;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Security;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;

namespace HrMaxx.Common.Repository.Security
{
    // You can add profile data for the user by adding more properties to your ApplicationUser class, please visit http://go.microsoft.com/fwlink/?LinkID=317594 to learn more.
    public class ApplicationUser : IdentityUser, IOriginator<ApplicationUser>
    {
			public string FirstName { get; set; }
			public string LastName { get; set; }
			public Guid? Host { get; set; }
			public Guid? Company { get; set; }
			public Guid? Employee { get; set; }
			public bool Active { get; set; }
			public int RoleVersion { get; set; }
			public string LastModifiedBy { get; set; }
			public DateTime? LastModified { get; set; }

        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<ApplicationUser> manager)
        {
            // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
            var userIdentity = await manager.CreateIdentityAsync(this, DefaultAuthenticationTypes.ApplicationCookie);
            // Add custom user claims here
						userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.Version, ConfigurationManager.AppSettings["tokenVersion"]));
						userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.UserID, this.Id));
						userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.Email, this.Email));
						userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.Name, string.Format("{0} {1}", this.FirstName, this.LastName)));
						userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.RoleVersion, this.RoleVersion.ToString()));
						if(this.Host.HasValue)
							userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.Host, this.Host.Value.ToString()));
						if(this.Company.HasValue)
							userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.Company, this.Company.Value.ToString()));
						if (this.Employee.HasValue)
							userIdentity.AddClaim(new Claim(HrMaxxClaimTypes.Employee, this.Employee.Value.ToString()));
            return userIdentity;
        }


	    public Guid MementoId
	    {
		    get
		    {
			    return new Guid(Id);
		    }
	    }

	    public void ApplyMemento(Memento<ApplicationUser> memento)
	    {
		    throw new NotImplementedException();
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
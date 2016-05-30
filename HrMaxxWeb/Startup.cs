using System.Data.Entity;
using HrMaxx.Common.Repository.Migrations;
using HrMaxx.Common.Repository.Security;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(HrMaxxWeb.Startup))]
namespace HrMaxxWeb
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
					Database.SetInitializer(new MigrateDatabaseToLatestVersion<ApplicationDbContext, Configuration>());
            ConfigureAuth(app);
        }
    }
}

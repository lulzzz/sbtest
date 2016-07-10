using System.Data.Entity;
using System.Data.Entity.Migrations;
using HrMaxx.Common.Repository.Migrations;
using HrMaxx.Common.Repository.Security;
using HrMaxx.Infrastructure.Exceptions;
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
					var dbMigrator = new DbMigrator(new HrMaxx.Common.Repository.Migrations.Configuration());
					dbMigrator.Update();
            ConfigureAuth(app);
        }
    }
}

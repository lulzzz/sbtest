using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using HrMaxx.Common.Repository.Migrations;
using HrMaxx.Common.Repository.Security;
using HrMaxxWeb.Code.IOC;

namespace HrMaxxWeb
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

						IOCBootstrapper.Bootstrap();
						//Database.SetInitializer(new MigrateDatabaseToLatestVersion<ApplicationDbContext, Configuration>("DefaultConnection"));
						//(new ApplicationDbContext()).Database.Initialize(true);
						//var configuration = new Configuration();
						//var migrator = new System.Data.Entity.Migrations.DbMigrator(configuration);
						//if (migrator.GetPendingMigrations().Any())
						//{
						//	migrator.Update();
						//}
        }
    }
}

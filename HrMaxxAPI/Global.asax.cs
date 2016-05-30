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
using HrMaxx.Common.Repository;

namespace HrMaxxAPI
{
	public class WebApiApplication : System.Web.HttpApplication
	{
		protected void Application_Start()
		{
			AreaRegistration.RegisterAllAreas();
			GlobalConfiguration.Configure(WebApiConfig.Register);
			
		}
	}

}

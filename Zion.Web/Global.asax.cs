using System;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using HrMaxx.Web.Code.IOC;
using Newtonsoft.Json.Serialization;
using StackExchange.Profiling.EntityFramework6;

namespace HrMaxx.Web
{
	public class MvcApplication : HttpApplication
	{
		protected void Application_Start()
		{
			GlobalConfiguration.Configuration
				.Formatters
				.JsonFormatter
				.SerializerSettings
				.ContractResolver = new CamelCasePropertyNamesContractResolver();

			AreaRegistration.RegisterAllAreas();
			RouteConfig.RegisterRoutes(RouteTable.Routes);
			BundleConfig.RegisterBundles(BundleTable.Bundles);

			IOCBootstrapper.Bootstrap();

			MiniProfilerEF6.Initialize();
		}

		protected void Application_BeginRequest(Object sender, EventArgs e)
		{
			Context.Items.Add("HttpResponse", Response);
		}
	}
}
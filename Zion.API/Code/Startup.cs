using System;
using System.Web.Http;
using Autofac;
using Autofac.Integration.WebApi;
using HrMaxx.API.Code;
using HrMaxx.API.Code.IOC;
using HrMaxx.TestSupport;
using Microsoft.Owin;
using Microsoft.Owin.Cors;
using Microsoft.Owin.Security.OAuth;
using Owin;

[assembly: OwinStartup("test", typeof (Startup))]

namespace HrMaxx.API.Code
{
	public class Startup : IOwinStartup
	{
		public void Configuration(IAppBuilder app)
		{
			var config = new HttpConfiguration();

			IContainer container = IOCBootstrapper.Bootstrap();
			app.UseAutofacMiddleware(container);
			app.UseAutofacWebApi(config);

			var resolver = new AutofacWebApiDependencyResolver(container);
			config.DependencyResolver = resolver;
			var authorizationServerProvider = container.Resolve<IOAuthAuthorizationServerProvider>();
			ConfigureOAuth(app, authorizationServerProvider);

			app.UseCors(CorsOptions.AllowAll);
			WebApiConfig.Register(config);

			app.UseWebApi(config);
		}

		public void ConfigureOAuth(IAppBuilder app, IOAuthAuthorizationServerProvider authorisationService)
		{
			var OAuthServerOptions = new OAuthAuthorizationServerOptions
			{
				AllowInsecureHttp = true,
				TokenEndpointPath = new PathString("/token"),
				AccessTokenExpireTimeSpan = TimeSpan.FromDays(30),
				Provider = authorisationService
			};

			// Token Generation
			app.UseOAuthAuthorizationServer(OAuthServerOptions);
			app.UseOAuthBearerAuthentication(new OAuthBearerAuthenticationOptions());
		}
	}
}
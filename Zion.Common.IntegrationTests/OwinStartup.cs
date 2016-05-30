using System;
using System.Web.Http;
using Autofac;
using Autofac.Integration.WebApi;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.TestSupport;
using HrMaxxAPI;
using HrMaxxAPI.Code.IOC;
using HrMaxxAPI.Providers;
using Microsoft.Owin;
using Microsoft.Owin.Security.OAuth;
using Owin;


namespace HrMaxx.Common.IntegrationTests
{
	public class OwinStartup : IOwinStartup
	{
		public void Configuration(IAppBuilder appBuilder)
		{
			var config = new HttpConfiguration();

			IContainer container = IOCBootstrapper.Bootstrap();
			var resolver = new AutofacWebApiDependencyResolver(container);
			config.DependencyResolver = resolver;

			var authService = container.Resolve<IAuthenticationService>();
			ConfigureOAuth(appBuilder, authService);

			WebApiConfig.Register(config);

			appBuilder.UseWebApi(config);
		}

		public void ConfigureOAuth(IAppBuilder app, IAuthenticationService authService)
		{
			var PublicClientId = "self";
			var OAuthServerOptions = new OAuthAuthorizationServerOptions
			{
				TokenEndpointPath = new PathString("/Token"),
				Provider = new ApplicationOAuthProvider(PublicClientId),
				AuthorizeEndpointPath = new PathString("/api/Account/ExternalLogin"),
				AccessTokenExpireTimeSpan = TimeSpan.FromDays(14),
				// In production mode set AllowInsecureHttp = false
				AllowInsecureHttp = true
			};

			// Token Generation
			app.UseOAuthBearerTokens(OAuthServerOptions);
		}
	}
}
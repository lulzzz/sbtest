using Autofac;
using Microsoft.Owin.Security.OAuth;

namespace HrMaxx.API.Code.IOC
{
	public class SecurityModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<TokenAuthorizationServerProvider>()
				.As<IOAuthAuthorizationServerProvider>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();
		}
	}
}
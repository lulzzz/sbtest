using Autofac;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Services.Host;

namespace HrMaxxAPI.Code.IOC.OnlinePayroll
{
	public class ServicesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			
			builder.RegisterType<HostService>()
				.As<IHostService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

		}
	}
}
using System.Reflection;
using Autofac;
using HrMaxx.Bus.Contracts;
using MassTransit;
using Module = Autofac.Module;

namespace HrMaxxAPI.Code.IOC.Common
{
	public class CommandHandlerModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			Assembly servicesAssembly = Assembly.Load("HrMaxx.Common.Services");
			WireHandlersForAssembly(builder, servicesAssembly);
		}

		private static void WireHandlersForAssembly(ContainerBuilder builder, Assembly servicesAssembly)
		{
			//in memory handlers
			builder.RegisterAssemblyTypes(servicesAssembly)
				.Where(t => typeof (IMessageHandler).IsAssignableFrom(t))
				.PropertiesAutowired()
				.AsSelf();

			//masstransit consumers
			builder.RegisterAssemblyTypes(servicesAssembly)
				.Where(t => typeof (IConsumer).IsAssignableFrom(t))
				.PropertiesAutowired()
				.AsSelf();
		}
	}
}
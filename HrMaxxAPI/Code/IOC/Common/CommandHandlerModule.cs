using System.Collections.Generic;
using System.Configuration;
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
			string _baseUrl =
				ConfigurationManager.AppSettings["WebUrl"];
			var namedParameters = new List<NamedParameter>();
			namedParameters.Add(new NamedParameter("baseUrl", _baseUrl));

			//in memory handlers
			builder.RegisterAssemblyTypes(servicesAssembly)
				.Where(t => typeof (IMessageHandler).IsAssignableFrom(t))
				.PropertiesAutowired()
				.AsSelf();

			//masstransit consumers
			builder.RegisterAssemblyTypes(servicesAssembly)
				.WithParameters(namedParameters)
				.Where(t => typeof (IConsumer).IsAssignableFrom(t))
				.PropertiesAutowired()
				.AsSelf();
		}
	}
}
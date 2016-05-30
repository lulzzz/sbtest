using System;
using System.IO;
using System.Web;
using Autofac;
using HrMaxx.API.Code.IOC.Common;
using HrMaxx.Bus;
using HrMaxx.Infrastructure.Mapping;
using log4net.Config;
using MassTransit;

namespace HrMaxx.API.Code.IOC
{
	public class IOCBootstrapper
	{
		public static IContainer Bootstrap()
		{
			XmlConfigurator.ConfigureAndWatch(new FileInfo(AppDomain.CurrentDomain.BaseDirectory + "log4net.xml"));

			var builder = new ContainerBuilder();

			builder.RegisterModule<LoggingModule>();
			builder.RegisterModule<MapperModule>();
			builder.RegisterModule<ControllerModule>();
			builder.RegisterModule<SecurityModule>();
			builder.RegisterModule<BusModule>();

			builder.RegisterModule<RepositoriesModule>();
			builder.RegisterModule<MappingModule>();
			builder.RegisterModule<ServicesModule>();
			builder.RegisterModule<CommandHandlerModule>();

			IContainer container = builder.Build();

			ProbeServiceBus(container);
			return container;
		}

		private static void ProbeServiceBus(IContainer container)
		{
			var bus = container.Resolve<IServiceBus>();
			bus.Probe();
			bus.WriteIntrospectionToFile(String.Join(@"\", HttpContext.Current.Server.MapPath(@"~\logs"), "HrMaxx.API.probe"));
		}

		private static void ConfigureInMemoryBus(IContainer container)
		{
			var routeFactory = container.Resolve<IRouteFactory>();
			routeFactory.RegisterRoutesDynamically();
			routeFactory.TraceRoutes();
		}
	}
}
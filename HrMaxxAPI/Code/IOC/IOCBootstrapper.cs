using System;
using System.IO;
using System.Web;
using Autofac;
using HrMaxx.Bus;
using HrMaxx.Infrastructure.Mapping;
using HrMaxxAPI.Code.IOC.Common;
using log4net.Config;
using MassTransit;

namespace HrMaxxAPI.Code.IOC
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
			builder.RegisterModule<BusModule>();

			builder.RegisterModule<Common.RepositoriesModule>();
			builder.RegisterModule<Common.MappingModule>();
			builder.RegisterModule<Common.ServicesModule>();
			builder.RegisterModule<Common.CommandHandlerModule>();

			builder.RegisterModule<OnlinePayroll.RepositoriesModule>();
			builder.RegisterModule<OnlinePayroll.MappingModule>();
			builder.RegisterModule<OnlinePayroll.ServicesModule>();
			builder.RegisterModule<OnlinePayroll.CommandHandlerModule>();

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
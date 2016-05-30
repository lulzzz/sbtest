using System;
using System.IO;
using System.Web.Mvc;
using Autofac;
using Autofac.Integration.Mvc;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Web.Code.IOC.Common;
using log4net.Config;

namespace HrMaxx.Web.Code.IOC
{
	public class IOCBootstrapper
	{
		public static void Bootstrap()
		{
			XmlConfigurator.ConfigureAndWatch(new FileInfo(AppDomain.CurrentDomain.BaseDirectory + "log4net.xml"));
			var builder = new ContainerBuilder();

			builder.RegisterModule<LoggingModule>();
			builder.RegisterModule<MapperModule>();
			builder.RegisterModule<ControllerModule>();

			builder.RegisterModule<CommandHandlerModule>();
			builder.RegisterModule<RepositoriesModule>();
			builder.RegisterModule<MappingModule>();
			builder.RegisterModule<ServicesModule>();


			builder.RegisterModule<BusModule>();

			IContainer container = builder.Build();

			//ProbeServiceBus(container);

			DependencyResolver.SetResolver(new AutofacDependencyResolver(container));
		}
	}
}
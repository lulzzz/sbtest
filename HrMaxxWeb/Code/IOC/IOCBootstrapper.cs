using System;
using System.IO;
using System.Web;
using Autofac;
using HrMaxx.Bus;
using HrMaxx.Infrastructure.Mapping;
using HrMaxxWeb.Code.IOC.Common;
using log4net.Config;

namespace HrMaxxWeb.Code.IOC
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
			

			builder.RegisterModule<RepositoriesModule>();
			builder.RegisterModule<MappingModule>();
			builder.RegisterModule<ServicesModule>();
			

			IContainer container = builder.Build();

			return container;
		}

	}
}
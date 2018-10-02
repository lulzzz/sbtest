using System;
using System.IO;
using System.Web;
using Autofac;
using HrMaxx.Infrastructure.Mapping;
using HrMaxxAPI.Code.IOC;
using HrMaxxAPI.Code.IOC.OnlinePayroll;
using HrMaxx.TestSupport;
using log4net.Config;
using MassTransit;
using NUnit.Framework;
namespace HrMaxx.OnlinePayroll.IntegrationTests
{
	[SetUpFixture]
	public class LocalSetupFixture : SetupFixture
	{
		protected override void CreateDatabase()
		{
			base.CreateDatabase();
		}

		protected override IContainer ConfigureIOC(ContainerBuilder extBuilder = null)
		{
			XmlConfigurator.ConfigureAndWatch(new FileInfo(AppDomain.CurrentDomain.BaseDirectory + "log4net.xml"));

			var builder = new ContainerBuilder();

			builder.RegisterModule<LoggingModule>();
			builder.RegisterModule<MapperModule>();
			builder.RegisterModule<ControllerModule>();
			builder.RegisterModule<BusModule>();

			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.RepositoriesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.ServicesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.Common.CommandHandlerModule>();

			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.RepositoriesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.MappingModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.ServicesModule>();
			builder.RegisterModule<HrMaxxAPI.Code.IOC.OnlinePayroll.CommandHandlerModule>();
			var container = base.ConfigureIOC(builder);
			ProbeServiceBus(container);
			return container;
		}
		private static void ProbeServiceBus(IContainer container)
		{
			var bus = container.Resolve<IServiceBus>();
			bus.Probe();
			
		}
	}
}
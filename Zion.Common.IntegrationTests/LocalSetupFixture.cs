using Autofac;
using HrMaxxAPI.Code.IOC;
using HrMaxxAPI.Code.IOC.Common;
using HrMaxx.TestSupport;
using NUnit.Framework;

namespace HrMaxx.Common.IntegrationTests
{
	[SetUpFixture]
	public class LocalSetupFixture : SetupFixture
	{
		protected override void CreateDatabase()
		{
			base.CreateDatabase();
		}

		protected override void ConfigureIOC(ContainerBuilder extBuilder = null)
		{
			var builder = new ContainerBuilder();
			builder.RegisterModule<ServicesModule>();
			builder.RegisterModule<RepositoriesModule>();
			builder.RegisterModule<MappingModule>();

			builder.RegisterModule<ControllerModule>();
			builder.RegisterModule<LoggingModule>();
			builder.RegisterModule<BusModule>();

			builder.RegisterModule<BusModule>();

			base.ConfigureIOC(builder);
		}
	}
}
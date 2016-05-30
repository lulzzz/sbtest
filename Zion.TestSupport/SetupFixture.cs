using System.IO;
using Autofac;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Mapping;
using NUnit.Framework;

namespace HrMaxx.TestSupport
{
	[SetUpFixture]
	public abstract class SetupFixture
	{
		[SetUp]
		public void RunBeforeAnyTestsInNamespace()
		{
			PreSetup();
			ConfigureIOC();

			/*
			 * We don't want to nuke our queues for each fixture in CI, we do it once as a build step on CI. Reason being that we need our queues in tact for logging to work.
			 * We don't want to nuke the DB constantly either, we do it once as a build step on CI.
			 */
#if !CI
			CreateDatabase();
#endif
			PostSetup();
		}

		[TearDown]
		public void RunAfterAnyTestsInNamespace()
		{
			PreTeardown();
		}

		protected void CreateHrMaxxDatabase()
		{
			string arguments = "INTEGRATION_TEST";
			TestInfrastructure.RunDatabaseScript(arguments);
		}

		protected virtual void CreateDatabase()
		{
			CreateHrMaxxDatabase();
		}

		protected virtual void PreSetup()
		{
		}

		protected virtual void PreTeardown()
		{
		}

		protected virtual void PostSetup()
		{
		}

		protected virtual void StopIIS()
		{
			TestInfrastructure.StopIIS();
		}

		protected virtual void StartIIS()
		{
			TestInfrastructure.StartIIS();
		}

		protected DirectoryInfo GetSolutionRoot()
		{
			return TestInfrastructure.GetSolutionRoot();
		}

		protected virtual void ConfigureIOC(ContainerBuilder extBuilder = null)
		{
			ContainerBuilder builder = extBuilder ?? new ContainerBuilder();
			builder.RegisterModule<MapperModule>();

			IContainer container = builder.Build();

			TestLifetimeScopeProvider.Init(container, null);
		}
	}
}
using System.Data.SqlClient;
using Autofac;
using NUnit.Framework;

namespace HrMaxx.TestSupport
{
	[Category("Integration")]
	public class BaseIntegrationTestFixture
	{
		private ILifetimeScope _testLifetimeScopeScope;

		protected ILifetimeScope TestLifetimeScope
		{
			get { return _testLifetimeScopeScope; }
		}

		protected SqlConnection Connection
		{
			get { return TestLifetimeScope.ResolveNamed<SqlConnection>("readConnection"); }
		}

		[TestFixtureSetUp]
		protected void BaseFixtureSetUp()
		{
			FixtureSetup(TestLifetimeScopeProvider.GetLifetimeScope());
			_testLifetimeScopeScope = TestLifetimeScopeProvider.GetLifetimeScope().BeginLifetimeScope();
		}

		[SetUp]
		protected void BaseIntegrationSetUp()
		{
		}

		[TearDown]
		protected void BaseTearDown()
		{
		}

		[TestFixtureTearDown]
		protected void BaseFixtureTearDown()
		{
			_testLifetimeScopeScope.Dispose();
		}

		/// <summary>
		///   Override to get a lifetimeScope specifically for creating data
		///   outside of any test scope.
		/// </summary>
		/// <param name="lifetimeScope">Your scope, sir.</param>
		protected virtual void FixtureSetup(ILifetimeScope lifetimeScope)
		{
		}
	}
}
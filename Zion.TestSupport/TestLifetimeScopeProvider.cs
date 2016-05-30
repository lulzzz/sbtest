using System;
using System.Collections.Generic;
using Autofac;

namespace HrMaxx.TestSupport
{
	public class TestLifetimeScopeProvider
	{
		private static IContainer _container;
		private static ILifetimeScope _lifetimeScope;
		private static Action<ContainerBuilder> _configurationAction;

		private TestLifetimeScopeProvider()
		{
		}

		public static void Init(IContainer container, Action<ContainerBuilder> configurationAction)
		{
			_configurationAction = configurationAction;
			_container = container;
		}

		public static ILifetimeScope GetLifetimeScope()
		{
			return _lifetimeScope ?? (_lifetimeScope = BuildLifetimeScope());
		}

		public void EndLifetimeScope()
		{
			if (_lifetimeScope != null)
				_lifetimeScope.Dispose();
		}

		private static ILifetimeScope BuildLifetimeScope()
		{
			return (_configurationAction == null)
				? _container.BeginLifetimeScope()
				: _container.BeginLifetimeScope(_configurationAction);
		}

		public static void UpdateRegistrations<T>(List<T> modules) where T : Module
		{
			var builder = new ContainerBuilder();
			foreach (T module in modules)
			{
				builder.RegisterModule(module);
			}

			builder.Update(_container);
		}
	}
}
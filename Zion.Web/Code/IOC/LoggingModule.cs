﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Autofac.Core;
using log4net;
using Module = Autofac.Module;

namespace HrMaxx.Web.Code.IOC
{
	public class LoggingModule : Module
	{
		private static void InjectLoggerProperties(object instance)
		{
			Type instanceType = instance.GetType();

			// Get all the injectable properties to set.
			// If you wanted to ensure the properties were only UNSET properties,
			// here's where you'd do it.
			IEnumerable<PropertyInfo> properties = instanceType
				.GetProperties(BindingFlags.Public | BindingFlags.Instance)
				.Where(p => p.PropertyType == typeof (ILog) && p.CanWrite && p.GetIndexParameters().Length == 0);

			// Set the properties located.
			foreach (PropertyInfo propToSet in properties)
			{
				propToSet.SetValue(instance, LogManager.GetLogger(instanceType), null);
			}
		}

		private static void OnComponentPreparing(object sender, PreparingEventArgs e)
		{
			Type t = e.Component.Activator.LimitType;
			e.Parameters = e.Parameters.Union(
				new[]
				{
					new ResolvedParameter((p, i) => p.ParameterType == typeof (ILog), (p, i) => LogManager.GetLogger(t))
				});
		}

		protected override void AttachToComponentRegistration(IComponentRegistry componentRegistry,
			IComponentRegistration registration)
		{
			// Handle constructor parameters.
			registration.Preparing += OnComponentPreparing;

			// Handle properties.
			registration.Activated += (sender, e) => InjectLoggerProperties(e.Instance);
		}
	}
}
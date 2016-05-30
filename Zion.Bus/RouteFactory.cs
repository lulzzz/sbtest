using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Reflection;
using HrMaxx.Bus.Contracts;
using HrMaxx.Infrastructure.Tracing;

namespace HrMaxx.Bus
{
	public interface IRouteFactory
	{
		void RegisterHandler<T>(Type handler) where T : IMessage;
		IReadOnlyDictionary<Type, List<Type>> GetRoutes();
		void RegisterRoutesDynamically();
		void TraceRoutes();
	}

	public class RouteFactory : IRouteFactory
	{
		private readonly ConcurrentDictionary<Type, List<Type>> _routes = new ConcurrentDictionary<Type, List<Type>>();

		public void RegisterHandler<T>(Type handler) where T : IMessage
		{
			List<Type> handlers;

			if (!_routes.TryGetValue(typeof (T), out handlers))
			{
				handlers = new List<Type>();
				_routes.TryAdd(typeof (T), handlers);
			}

			handlers.Add(handler);
		}

		public IReadOnlyDictionary<Type, List<Type>> GetRoutes()
		{
			return new ReadOnlyDictionary<Type, List<Type>>(_routes);
		}

		public void RegisterRoutesDynamically()
		{
			if (_routes.Any()) return;

			try
			{
				List<Assembly> assemblies = AppDomain.CurrentDomain.GetAssemblies().ToList();

				List<Type> messageTypes = assemblies
					.SelectMany(a => a.GetTypes())
					.Where(t => t.IsPublic && t.IsClass && t.IsAbstract == false)
					.Where(t => typeof (IMessage).IsAssignableFrom(t))
					.ToList();

				List<Type> handlerTypes = assemblies
					.SelectMany(a => a.GetTypes())
					.Where(t => IsAssignableToGenericType(t, typeof (IHandle<>)))
					.ToList();

				foreach (Type messageType in messageTypes)
				{
					List<Type> messageHandlers = handlerTypes
						.Select(t =>
						{
							MethodInfo[] methodInfos = t.GetMethods();

							if (!methodInfos.Any()) return null;

							foreach (MethodInfo methodInfo in methodInfos)
							{
								if (methodInfo.Name != "Handle") continue;

								ParameterInfo parameterInfo = methodInfo.GetParameters()[0];

								if (parameterInfo.ParameterType == messageType) return t;
							}

							return null;
						}).ToList();

					messageHandlers.Where(mh => mh != null).ToList()
						.ForEach(handlerType => RegisterHandler(messageType, handlerType));
				}
			}
			catch (Exception ex)
			{
				if (ex is ReflectionTypeLoadException)
				{
					HrMaxxTrace.TraceError("Failed to register routes for memory bus!");

					var typeLoadException = ex as ReflectionTypeLoadException;
					Exception[] loaderExceptions = typeLoadException.LoaderExceptions;
					foreach (Exception loaderException in loaderExceptions)
					{
						HrMaxxTrace.TraceException(loaderException);
						Console.WriteLine(loaderException);
					}
				}

				throw;
			}
		}

		public void TraceRoutes()
		{
			foreach (var route in _routes)
				HrMaxxTrace.TraceInformation("{0} ======> {1}", route.Key, route.Value.Aggregate((type, type1) => type1).Name);
		}

		public void RegisterHandler(Type messageType, Type handlerType)
		{
			List<Type> handlers;

			if (!_routes.TryGetValue(messageType, out handlers))
			{
				handlers = new List<Type>();
				_routes.TryAdd(messageType, handlers);
			}

			handlers.Add(handlerType);
		}

		private bool IsAssignableToGenericType(Type givenType, Type genericType)
		{
			Type[] interfaceTypes = givenType.GetInterfaces();

			foreach (Type it in interfaceTypes)
				if (it.IsGenericType) if (it.GetGenericTypeDefinition() == genericType) return true;

			Type baseType = givenType.BaseType;
			if (baseType == null) return false;

			return baseType.IsGenericType &&
			       baseType.GetGenericTypeDefinition() == genericType ||
			       IsAssignableToGenericType(baseType, genericType);
		}
	}
}
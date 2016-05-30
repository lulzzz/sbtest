using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Autofac;
using StackExchange.Profiling;

namespace HrMaxx.Bus.Contracts
{
	public class InMemoryBus : IInMemoryBus
	{
		private readonly IRouteFactory _routeFactory;
		private readonly IReadOnlyDictionary<Type, List<Type>> _routes;
		private readonly ILifetimeScope _scope;

		public InMemoryBus(IRouteFactory routeFactory, ILifetimeScope scope)
		{
			_routeFactory = routeFactory;
			_scope = scope;
			_routes = _routeFactory.GetRoutes();
		}

		public void Send<T>(T command) where T : Command
		{
			List<Type> handlers;

			if (!_routes.TryGetValue(typeof (T), out handlers))
				throw new InvalidOperationException("No handler registered for " + command.GetType().Name);

			if (handlers.Count != 1) throw new InvalidOperationException("Can't send a command more than one handler.");

			IHandle<T> handler;
			using (MiniProfiler.Current.Step("Resolving command handler: " + handlers[0].Name))
			{
				handler = _scope.Resolve(handlers[0]) as IHandle<T>;
			}

			handler.Handle(command);
		}

		public void Publish<T>(T @event) where T : Event
		{
			List<Type> handlers;

			if (!_routes.TryGetValue(@event.GetType(), out handlers)) return;

			using (MiniProfiler.Current.Step("Dispatching " + @event.GetType().Name + " to event handlers"))
			{
				List<IHandle<T>> resolvedHandlers = handlers.Select(handler => _scope.Resolve(handler) as IHandle<T>).ToList();

				if (resolvedHandlers.Count > 1) Parallel.ForEach(resolvedHandlers, handler => handler.Handle(@event));
				else resolvedHandlers[0].Handle(@event);
			}
		}
	}
}
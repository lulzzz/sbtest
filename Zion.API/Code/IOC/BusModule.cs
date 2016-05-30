using Autofac;
using HrMaxx.Bus;
using HrMaxx.Bus.Contracts;
using MassTransit;
using MassTransit.Log4NetIntegration;

namespace HrMaxx.API.Code.IOC
{
	public class BusModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.Register(c => ServiceBusFactory.New(sbc =>
			{
				//sbc.UseRabbitMq();
				sbc.ReceiveFrom("loopback://localhost/HRMAXX-API");
				sbc.SetDefaultRetryLimit(0);
				sbc.UseJsonSerializer();
				sbc.DisablePerformanceCounters();
				sbc.UseLog4Net();

				/*
					* At this point, the command handlers are alrady registered with this lifetimescope 
					* in the CommandHandlersModule. 
					* The LoadFrom extension method below belongs to the MassTransit.AutofacIntegration lib
					* and will search the component registery and load all IConsumers found.
					*/

				sbc.Subscribe(x => x.LoadFrom(c.Resolve<ILifetimeScope>()));
			})).As<IServiceBus>().SingleInstance();

			builder.RegisterType<RouteFactory>()
				.As<IRouteFactory>()
				.SingleInstance();

			builder.RegisterType<InMemoryBus>()
				.As<IInMemoryBus>()
				.InstancePerLifetimeScope();

			builder.RegisterType<HrMaxx.Bus.Bus>().As<IBus>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();
		}
	}
}
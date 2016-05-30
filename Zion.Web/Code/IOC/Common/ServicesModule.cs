using System.Configuration;
using Autofac;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Services.Document;
using HrMaxx.Common.Services.Mementos;
using HrMaxx.Common.Services.Notifications;
using HrMaxx.Common.Services.Security;

namespace HrMaxx.Web.Code.IOC.Common
{
	public class ServicesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			string tokenVersion = ConfigurationManager.AppSettings["TokenVersion"];
			builder.RegisterType<StagingDataService>()
				.As<IStagingDataService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<DocumentService>()
				.As<IDocumentService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();


			builder.RegisterType<AuthenticationService>()
				.WithParameter(new NamedParameter("tokenVersion", tokenVersion))
				.As<IAuthenticationService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<MementoDataService>()
				.As<IMementoDataService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<NotificationService>()
				.As<INotificationService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();
		}
	}
}
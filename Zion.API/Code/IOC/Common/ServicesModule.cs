using System.Configuration;
using Autofac;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Services.Document;
using HrMaxx.Common.Services.Email;
using HrMaxx.Common.Services.Mementos;
using HrMaxx.Common.Services.Notifications;
using HrMaxx.Common.Services.Security;
using EmailService = HrMaxx.Common.Services.Email.EmailService;

namespace HrMaxx.API.Code.IOC.Common
{
	public class ServicesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			bool _emailServiceSwitch = ConfigurationManager.AppSettings["EmailServiceSwitch"].Equals("1");
			string _smtpServer = ConfigurationManager.AppSettings["SMTPServer"];
			string webUrl = ConfigurationManager.AppSettings["WebURL"];
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


			builder.RegisterType<EmailService>()
				.WithParameter(new NamedParameter("emailService", _emailServiceSwitch))
				.WithParameter(new NamedParameter("smtpServer", _smtpServer))
				.WithParameter(new NamedParameter("webUrl", webUrl))
				.As<IEmailService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();
		}
	}
}
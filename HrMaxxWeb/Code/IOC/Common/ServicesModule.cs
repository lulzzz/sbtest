using System.Configuration;
using Autofac;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Services.Document;
using HrMaxx.Common.Services.Mementos;
using HrMaxx.Common.Services.Notifications;
using HrMaxx.Common.Services.Security;
using EmailService = HrMaxx.Common.Services.Email.EmailService;

namespace HrMaxxWeb.Code.IOC.Common
{
	public class ServicesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			//bool _emailServiceSwitch = ConfigurationManager.AppSettings["EmailServiceSwitch"].Equals("1");
			//string _smtpServer = ConfigurationManager.AppSettings["SMTPServer"];
			//string webUrl = ConfigurationManager.AppSettings["WebURL"];
			
			

			//builder.RegisterType<EmailService>()
			//	.WithParameter(new NamedParameter("emailService", _emailServiceSwitch))
			//	.WithParameter(new NamedParameter("smtpServer", _smtpServer))
			//	.WithParameter(new NamedParameter("webUrl", webUrl))
			//	.As<IEmailService>()
			//	.InstancePerLifetimeScope()
			//	.PropertiesAutowired();
		}
	}
}
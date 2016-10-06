using System.Configuration;
using System.Web;
using Autofac;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Services.Common;
using HrMaxx.Common.Services.Document;
using HrMaxx.Common.Services.Excel;
using HrMaxx.Common.Services.Mementos;
using HrMaxx.Common.Services.Notifications;
using HrMaxx.Common.Services.PDF;
using HrMaxx.Common.Services.Security;
using EmailService = HrMaxx.Common.Services.Email.EmailService;

namespace HrMaxxAPI.Code.IOC.Common
{
	public class ServicesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			bool _emailServiceSwitch = ConfigurationManager.AppSettings["EmailServiceSwitch"].Equals("1");
			string _smtpServer = ConfigurationManager.AppSettings["SMTPServer"];
			string webUrl = ConfigurationManager.AppSettings["WebURL"];
			string tokenVersion = ConfigurationManager.AppSettings["TokenVersion"];
			string _pdfPath = ConfigurationManager.AppSettings["FilePath"] + "PDFTemp/";
			string _templatePath = HttpContext.Current==null? string.Empty : HttpContext.Current.Server.MapPath("~/Templates/");


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

			builder.RegisterType<UserService>()
				.As<IUserService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<CommonService>()
				.As<ICommonService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<PDFService>()
				.WithParameter(new NamedParameter("filePath", _pdfPath))
				.WithParameter(new NamedParameter("templatePath", _templatePath))
				.As<IPDFService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<ExcelService>()
				.As<IExcelService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();
		}
	}
}
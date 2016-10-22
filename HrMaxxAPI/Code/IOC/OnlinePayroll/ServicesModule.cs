using System;
using System.Configuration;
using System.Web;
using Autofac;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Services;
using HrMaxx.OnlinePayroll.Services.Dashboard;
using HrMaxx.OnlinePayroll.Services.Host;
using HrMaxx.OnlinePayroll.Services.Journals;
using HrMaxx.OnlinePayroll.Services.Payroll;
using HrMaxx.OnlinePayroll.Services.Reports;
using HrMaxx.OnlinePayroll.Services.ScheduledJobs;
using HrMaxx.OnlinePayroll.Services.USTax;

namespace HrMaxxAPI.Code.IOC.OnlinePayroll
{
	public class ServicesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			string _pdfPath = ConfigurationManager.AppSettings["FilePath"] + "PDFTemp/";
			string _templatePath = HttpContext.Current.Server.MapPath("~/Templates/");
			
			builder.RegisterType<HostService>()
				.As<IHostService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<MetaDataService>()
				.As<IMetaDataService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<CompanyService>()
				.As<ICompanyService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<USTaxationService>()
				.As<ITaxationService>()
				.SingleInstance()
				.PropertiesAutowired();

			builder.RegisterType<JournalService>()
				.As<IJournalService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<PayrollService>()
				.As<IPayrollService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<DashboardService>()
				.As<IDashboardService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<ReportService>()
				.WithParameter(new NamedParameter("filePath", _pdfPath))
				.WithParameter(new NamedParameter("templatePath", _templatePath))
				.As<IReportService>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<ScheduledJobService>()
				.As<IScheduledJobService>()
				.SingleInstance()
				.PropertiesAutowired();

		}
	}
}
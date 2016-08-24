using Autofac;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Services;
using HrMaxx.OnlinePayroll.Services.Dashboard;
using HrMaxx.OnlinePayroll.Services.Host;
using HrMaxx.OnlinePayroll.Services.Journals;
using HrMaxx.OnlinePayroll.Services.Payroll;
using HrMaxx.OnlinePayroll.Services.USTax;

namespace HrMaxxAPI.Code.IOC.OnlinePayroll
{
	public class ServicesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			
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

		}
	}
}
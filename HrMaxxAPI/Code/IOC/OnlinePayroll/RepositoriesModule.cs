using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using Autofac;
using HrMaxx.Infrastructure.Extensions;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.ReadRepository;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Repository.Dashboard;
using HrMaxx.OnlinePayroll.Repository.Host;
using HrMaxx.OnlinePayroll.Repository.Journals;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using HrMaxx.OnlinePayroll.Repository.Reports;
using HrMaxx.OnlinePayroll.Repository.Taxation;

namespace HrMaxxAPI.Code.IOC.OnlinePayroll
{
	public class RepositoriesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			string _connectionString =
				ConfigurationManager.ConnectionStrings["HrMaxx"].ConnectionString.ConvertToTestConnectionStringAsRequired();
			string _connectionStringArchive =
				ConfigurationManager.ConnectionStrings["Archive"].ConnectionString.ConvertToTestConnectionStringAsRequired();

			string _onlinePayrollConnectionString =
				ConfigurationManager.ConnectionStrings["OnlinePayrollEntities"].ConnectionString.ConvertToTestConnectionStringAsRequired();
			string _usTaxTablesConnectionString =
				ConfigurationManager.ConnectionStrings["USTaxTableEntities"].ConnectionString.ConvertToTestConnectionStringAsRequired();

			builder.RegisterType<OnlinePayrollEntities>()
				.WithParameter(new NamedParameter("nameOrConnectionString", _onlinePayrollConnectionString))
				.InstancePerLifetimeScope();

			builder.RegisterType<USTaxTableEntities>()
				.WithParameter(new NamedParameter("nameOrConnectionString", _usTaxTablesConnectionString))
				.InstancePerLifetimeScope();

			var namedParameters = new List<NamedParameter>();
			namedParameters.Add(new NamedParameter("domain", ConfigurationManager.AppSettings["Domain"]));

			var sqlCon = new NamedParameter("sqlCon", _connectionString);

			builder.Register(cont =>
			{
				var archiveConnection = new SqlConnection(_connectionStringArchive);
				return archiveConnection;
			})
				.Named<SqlConnection>("archiveConnection")
				.InstancePerLifetimeScope();

			builder.Register(cont =>
			{
				var connection = new SqlConnection(_connectionString);
				return connection;
			})
				.Named<SqlConnection>("connection")
				.InstancePerLifetimeScope();

			builder.RegisterType<HostRepository>()
				.WithParameters(namedParameters)
				.As<IHostRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<MetaDataRepository>()
				.WithParameter((param, cont) => param.Name == "connection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("connection"))
				.As<IMetaDataRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<UtilRepository>()
				.As<IUtilRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<CompanyRepository>()
				.WithParameter((param, cont) => param.Name == "connection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("connection"))
				.WithParameter(sqlCon)
				.As<ICompanyRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<TaxationRepository>()
				.WithParameter((param, cont) => param.Name == "connection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("connection"))
				.As<ITaxationRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<PayrollRepository>()
				.WithParameter((param, cont) => param.Name == "connection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("connection"))
				.As<IPayrollRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<JournalRepository>()
				.WithParameter((param, cont) => param.Name == "connection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("connection"))
				.As<IJournalRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<DashboardRepository>()
				.WithParameter((param, cont) => param.Name == "connection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("archiveConnection"))
				.As<IDashboardRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<ReportRepository>()
				.WithParameter(sqlCon)
				.WithParameter((param, cont) => param.Name == "connection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("archiveConnection"))
				.As<IReportRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<ReadRepository>()
				.WithParameter(sqlCon)
				.As<IReadRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();
		}
	}
}
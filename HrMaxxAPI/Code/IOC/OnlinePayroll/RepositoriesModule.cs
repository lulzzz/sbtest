using System.Collections.Generic;
using System.Configuration;
using Autofac;
using HrMaxx.Infrastructure.Extensions;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Repository.Host;

namespace HrMaxxAPI.Code.IOC.OnlinePayroll
{
	public class RepositoriesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			string _connectionString =
				ConfigurationManager.ConnectionStrings["HrMaxx"].ConnectionString.ConvertToTestConnectionStringAsRequired();

			string _onlinePayrollConnectionString =
				ConfigurationManager.ConnectionStrings["OnlinePayrollEntities"].ConnectionString.ConvertToTestConnectionStringAsRequired();

			builder.RegisterType<OnlinePayrollEntities>()
				.WithParameter(new NamedParameter("nameOrConnectionString", _onlinePayrollConnectionString))
				.InstancePerLifetimeScope();

			var namedParameters = new List<NamedParameter>();
			namedParameters.Add(new NamedParameter("domain", ConfigurationManager.AppSettings["Domain"]));

			builder.RegisterType<HostRepository>()
				.WithParameters(namedParameters)
				.As<IHostRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();
		}
	}
}
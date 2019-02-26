using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autofac;
using HrMaxx.Infrastructure.Extensions;

namespace OPImportUtility
{
	public class RepositoriesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			string connectionString =
				ConfigurationManager.ConnectionStrings["OP"].ConnectionString.ConvertToTestConnectionStringAsRequired();
			string paxol =
				ConfigurationManager.ConnectionStrings["HrMaxx"].ConnectionString.ConvertToTestConnectionStringAsRequired();
			builder.Register(cont =>
			{
				var connection = new SqlConnection(connectionString);
				return connection;
			})
				.Named<SqlConnection>("opconnection")
				.InstancePerLifetimeScope();

			builder.Register(cont =>
			{
				var connection = new SqlConnection(paxol);
				return connection;
			})
				.Named<SqlConnection>("wConnection")
				.InstancePerLifetimeScope();

			builder.RegisterType<OPReadRepository>()
				.WithParameter((param, cont) => param.Name == "opconnection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("opconnection"))
				.As<IOPReadRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<WriteRepository>()
				.WithParameter((param, cont) => param.Name == "wConnection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("wConnection"))
				.As<IWriteRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();
		}
	}
}

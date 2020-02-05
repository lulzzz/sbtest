using System.Configuration;
using System.Data.SqlClient;
using Autofac;
using HrMaxx.Infrastructure.Extensions;

namespace SiteInspectionStatus_Utility
{
	public class RepositoriesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			
			string paxol =
				ConfigurationManager.ConnectionStrings["HrMaxx"].ConnectionString.ConvertToTestConnectionStringAsRequired();
			
			builder.Register(cont =>
			{
				var connection = new SqlConnection(paxol);
				return connection;
			})
				.Named<SqlConnection>("wConnection")
				.InstancePerLifetimeScope();

			

			builder.RegisterType<WriteRepository>()
				.WithParameter((param, cont) => param.Name == "wConnection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("wConnection"))
				.As<IWriteRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();
		}
	}
}

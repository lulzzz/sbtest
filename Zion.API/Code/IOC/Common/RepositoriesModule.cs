using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using Autofac;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Repository.Documents;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Common.Repository.Mementos;
using HrMaxx.Common.Repository.Notifications;
using HrMaxx.Infrastructure.Extensions;


namespace HrMaxx.API.Code.IOC.Common
{
	public class RepositoriesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			string _connectionString =
				ConfigurationManager.ConnectionStrings["HrMaxx"].ConnectionString.ConvertToTestConnectionStringAsRequired();
			string _commonConnectionString =
				ConfigurationManager.ConnectionStrings["CommonEntities"].ConnectionString.ConvertToTestConnectionStringAsRequired();
			

			string _fileDestinationPath = ConfigurationManager.AppSettings["FilePath"];
			string _fileSourcePath = ConfigurationManager.AppSettings["TmpUploadPath"];

			string _uamUrl = ConfigurationManager.AppSettings["UAMUrl"];


			_fileSourcePath = HttpContext.Current == null ? _fileSourcePath : HttpContext.Current.Server.MapPath(_fileSourcePath);

			builder.RegisterType<CommonEntities>()
				.WithParameter(new NamedParameter("nameOrConnectionString", _commonConnectionString))
				.InstancePerLifetimeScope();


			builder.Register(cont =>
			{
				var readConnection = new SqlConnection(_connectionString);
				return readConnection;
			})
				.Named<SqlConnection>("readConnection")
				.InstancePerLifetimeScope();

			builder.RegisterType<StagingDataRepository>()
				.As<IStagingDataRepository>()
				.WithParameter((param, cont) => param.Name == "connection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("readConnection"))
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<MementoDataRepository>()
				.As<IMementoDataRepository>()
				.WithParameter((param, cont) => param.Name == "connection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("readConnection"))
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			var namedParameters = new List<NamedParameter>();
			namedParameters.Add(new NamedParameter("destinationPath", _fileDestinationPath));
			namedParameters.Add(new NamedParameter("sourcePath", _fileSourcePath));
			namedParameters.Add(new NamedParameter("userimagepath", string.Empty));

			var uamNamedParameters = new List<NamedParameter>();
			uamNamedParameters.Add(new NamedParameter("UAMUrl", _uamUrl));


			builder.RegisterType<FileRepository>()
				.WithParameters(namedParameters)
				.As<IFileRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<DocumentRepository>()
				.As<IDocumentRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();


			builder.RegisterType<NotificationRepository>()
				.As<INotificationRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();
		}
	}
}
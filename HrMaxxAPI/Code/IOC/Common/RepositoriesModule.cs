﻿using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using Autofac;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Repository.Common;
using HrMaxx.Common.Repository.Excel;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Common.Repository.Mementos;
using HrMaxx.Common.Repository.Notifications;
using HrMaxx.Common.Repository.Security;
using HrMaxx.Infrastructure.Extensions;

namespace HrMaxxAPI.Code.IOC.Common
{
	public class RepositoriesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			string _connectionString =
				ConfigurationManager.ConnectionStrings["HrMaxx"].ConnectionString.ConvertToTestConnectionStringAsRequired();
			string _connectionStringArchive =
				ConfigurationManager.ConnectionStrings["Archive"].ConnectionString.ConvertToTestConnectionStringAsRequired();
			string _commonConnectionString =
				ConfigurationManager.ConnectionStrings["CommonEntities"].ConnectionString.ConvertToTestConnectionStringAsRequired();
			string _userConnectionString =
				ConfigurationManager.ConnectionStrings["UserEntities"].ConnectionString.ConvertToTestConnectionStringAsRequired();
			

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

			builder.Register(cont =>
			{
				var archiveConnection = new SqlConnection(_connectionStringArchive);
				return archiveConnection;
			})
				.Named<SqlConnection>("archiveConnection")
				.InstancePerLifetimeScope();

			builder.RegisterType<StagingDataRepository>()
				.As<IStagingDataRepository>()
				.WithParameter((param, cont) => param.Name == "connection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("archiveConnection"))
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<MementoDataRepository>()
				.As<IMementoDataRepository>()
				.WithParameter((param, cont) => param.Name == "connection",
					(param, cont) => cont.ResolveNamed<SqlConnection>("archiveConnection"))
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
			
			builder.RegisterType<NotificationRepository>()
				.As<INotificationRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<UserEntities>()
				.WithParameter(new NamedParameter("nameOrConnectionString", _userConnectionString))
				.InstancePerLifetimeScope();

			builder.RegisterType<UserRepository>()
				.As<IUserRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();

			builder.RegisterType<CommonRepository>()
			.As<ICommonRepository>()
			.InstancePerLifetimeScope()
			.PropertiesAutowired();
			string _pdfPath = ConfigurationManager.AppSettings["FilePath"] + "PDFTemp/";
			builder.RegisterType<ExcelRepository>()
				.WithParameter(new NamedParameter("filePath", _pdfPath))
				.As<IExcelRepository>()
				.InstancePerLifetimeScope()
				.PropertiesAutowired();
		}
	}
}
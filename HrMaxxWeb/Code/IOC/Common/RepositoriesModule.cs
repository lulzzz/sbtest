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

namespace HrMaxxWeb.Code.IOC.Common
{
	public class RepositoriesModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			
		}
	}
}
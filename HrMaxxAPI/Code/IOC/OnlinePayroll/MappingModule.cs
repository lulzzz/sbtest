using Autofac;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Services.Mappers;
using HrMaxxAPI.Code.Mappers;

namespace HrMaxxAPI.Code.IOC.OnlinePayroll
{
	public class MappingModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<OnlinePayrollResourceMapperProfile>().As<ProfileLazy>();
			builder.RegisterType<OnlinePayrollModelMapperProfile>().As<ProfileLazy>();
			builder.RegisterType<CompanyModelMapperProfile>().As<ProfileLazy>();
			builder.RegisterType<USTaxTablesModelMapperProfile>().As<ProfileLazy>();
		}
	}
}
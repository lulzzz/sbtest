using Autofac;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Services.Mappers;
using HrMaxxAPI.Code.Mappers;

namespace SiteInspectionStatus_Utility
{
	public class MappingModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<ImportMapperProfile>().As<ProfileLazy>();
			
		}
	}
}
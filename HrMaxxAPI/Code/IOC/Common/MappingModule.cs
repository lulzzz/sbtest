using Autofac;
using HrMaxx.Common.Services.Mappers;
using HrMaxx.Infrastructure.Mapping;
using HrMaxxAPI.Code.Mappers;

namespace HrMaxxAPI.Code.IOC.Common
{
	public class MappingModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<CommonResourceMapperProfile>().As<ProfileLazy>();
			builder.RegisterType<CommonModelMapperProfile>().As<ProfileLazy>();
		}
	}
}
using Autofac;
using HrMaxx.API.Code.Mappers;
using HrMaxx.Common.Services.Mappers;
using HrMaxx.Infrastructure.Mapping;

namespace HrMaxx.API.Code.IOC.Common
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
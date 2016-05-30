using Autofac;
using HrMaxx.Common.Services.Mappers;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Web.Code.Mappers;

namespace HrMaxx.Web.Code.IOC.Common
{
	public class MappingModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<CommonViewModelMapperProfile>().As<ProfileLazy>();
			builder.RegisterType<CommonModelMapperProfile>().As<ProfileLazy>();
		}
	}
}
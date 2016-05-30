using System.Collections.Generic;
using Autofac;
using Autofac.Core;
using AutoMapper;
using AutoMapper.Mappers;

namespace HrMaxx.Infrastructure.Mapping
{
	public class MapperModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<MappingEngine>().As<IMappingEngine>().SingleInstance();
			builder.RegisterType<TypeMapFactory>().As<ITypeMapFactory>();
			builder.RegisterInstance(MapperRegistry.Mappers).As<IEnumerable<IObjectMapper>>();
			builder.RegisterType<ConfigurationStore>().As<IConfigurationProvider>()
				.OnActivating(ConfigureConfigurationStore).SingleInstance();

			builder.RegisterType<Mapper>().As<IMapper>();
		}

		private void ConfigureConfigurationStore(IActivatingEventArgs<ConfigurationStore> obj)
		{
			var profiles = obj.Context.Resolve<IEnumerable<ProfileLazy>>();
			foreach (ProfileLazy profile in profiles)
			{
				profile.ConfigurationProvider = obj.Instance;
					//Dodgy side-load hack to get the IConfigurationProvider available in the profile, since AutoMapper has it but doesn't expose it
				obj.Instance.AddProfile(profile);
			}
		}
	}
}
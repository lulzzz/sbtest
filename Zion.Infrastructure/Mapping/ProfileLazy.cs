using System;
using AutoMapper;

namespace HrMaxx.Infrastructure.Mapping
{
	public class ProfileLazy : Profile
	{
		public ProfileLazy(Lazy<IMappingEngine> mapper)
		{
			Mapper = mapper;
		}

		public IConfigurationProvider ConfigurationProvider { get; set; }
		public Lazy<IMappingEngine> Mapper { get; private set; }
	}
}
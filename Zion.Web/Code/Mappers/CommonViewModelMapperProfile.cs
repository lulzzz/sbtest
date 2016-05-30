using System;
using AutoMapper;
using HrMaxx.Infrastructure.Mapping;

namespace HrMaxx.Web.Code.Mappers
{
	public class CommonViewModelMapperProfile : ProfileLazy
	{
		public CommonViewModelMapperProfile(Lazy<IMappingEngine> mapper) : base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();
		}
	}
}
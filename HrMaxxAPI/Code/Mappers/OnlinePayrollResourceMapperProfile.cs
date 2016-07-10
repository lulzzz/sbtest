using System;
using System.IO;
using AutoMapper;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Resources.Common;
using HrMaxxAPI.Resources.OnlinePayroll;
using Magnum;

namespace HrMaxxAPI.Code.Mappers
{
	public class  OnlinePayrollResourceMapperProfile : ProfileLazy
	{
		public OnlinePayrollResourceMapperProfile(Lazy<IMappingEngine> mapper)
			: base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();

			CreateMap<HostResource, Host>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));

			CreateMap<HomePageResource, HostHomePage>();
			CreateMap<HostHomePage, HomePageResource>()
				.ForMember(dest => dest.StagingId, opt => opt.MapFrom(src => CombGuid.Generate()));

			CreateMap<HostHomePageDocumentResource, HostHomePageDocument>()
				.ForMember(dest => dest.SourceFileName, opt => opt.MapFrom(src => src.file.Name))
				.ForMember(dest => dest.OriginalFileName, opt => opt.MapFrom(src => src.FileName.Replace(Path.GetExtension(src.FileName), string.Empty)))
				.ForMember(dest => dest.FileExtension, opt => opt.MapFrom(src => Path.GetExtension(src.FileName).Replace(".", "")));

		}
	}
}
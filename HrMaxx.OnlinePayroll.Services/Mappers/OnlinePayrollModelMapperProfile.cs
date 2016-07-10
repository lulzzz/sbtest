using System;
using AutoMapper;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using Magnum;
using Magnum.Extensions;

namespace HrMaxx.OnlinePayroll.Services.Mappers
{
	public class OnlinePayrollModelMapperProfile : ProfileLazy
	{
		public OnlinePayrollModelMapperProfile(Lazy<IMappingEngine> mapper) : base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();

			CreateMap<Models.Host, Models.DataModel.Host>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.FirmName, opt => opt.MapFrom(src=>src.FirmName))
				.ForMember(dest => dest.Url, opt => opt.MapFrom(src => src.Url))
				.ForMember(dest => dest.EffectiveDate, opt => opt.MapFrom(src => src.EffectiveDate))
				.ForMember(dest => dest.TerminationDate, opt => opt.MapFrom(src => src.TerminationDate))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => src.StatusId))
				.ForMember(dest => dest.Status, opt => opt.Ignore())
				.ForMember(dest=>dest.HomePage, opt=>opt.Ignore())
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src => src.UserName));

			CreateMap<Models.DataModel.Host, Models.Host>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.FirmName, opt => opt.MapFrom(src => src.FirmName))
				.ForMember(dest => dest.Url, opt => opt.MapFrom(src => src.Url))
				.ForMember(dest => dest.EffectiveDate, opt => opt.MapFrom(src => src.EffectiveDate))
				.ForMember(dest => dest.TerminationDate, opt => opt.MapFrom(src => src.TerminationDate))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => src.StatusId))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy));

			CreateMap<HostHomePageDocument, DocumentDto>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => CombGuid.Generate()))
				.ForMember(dest => dest.DocumentPath, opt => opt.Ignore())
				.ForMember(dest => dest.DocumentName, opt => opt.MapFrom(src => src.OriginalFileName))
				.ForMember(dest => dest.MimeType, opt => opt.MapFrom(src => src.MimeType))
				.ForMember(dest => dest.DocumentExtension, opt => opt.MapFrom(src => src.FileExtension));

		}
	}
}
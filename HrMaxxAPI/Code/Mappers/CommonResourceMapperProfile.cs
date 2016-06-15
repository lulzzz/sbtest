using System;
using System.IO;
using AutoMapper;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Mapping;
using HrMaxxAPI.Resources.Common;
using Magnum;

namespace HrMaxxAPI.Code.Mappers
{
	public class CommonResourceMapperProfile : ProfileLazy
	{
		public CommonResourceMapperProfile(Lazy<IMappingEngine> mapper) : base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();

			CreateMap<NotificationDto, NotificationsResource>()
				.ForMember(n => n.CreatedOn,
					opt =>
						opt.MapFrom(
							src =>
								new DateTime(src.CreatedOn.Year, src.CreatedOn.Month, src.CreatedOn.Day, src.CreatedOn.Hour,
									src.CreatedOn.Minute, src.CreatedOn.Second, src.CreatedOn.Kind)))
				.ForMember(n => n.Type,
					opt =>
						opt.MapFrom(
							src => ((NotificationTypeEnum) Enum.Parse(typeof (NotificationTypeEnum), src.Type)).GetEnumDescription()));

			CreateMap<EntityDocumentResource, EntityDocumentAttachment>()
				.ForMember(dest => dest.SourceFileName, opt => opt.MapFrom(src => src.file.Name))
				.ForMember(dest => dest.OriginalFileName, opt => opt.MapFrom(src => src.FileName.Replace(Path.GetExtension(src.FileName), string.Empty)))
				.ForMember(dest => dest.FileExtension, opt => opt.MapFrom(src => Path.GetExtension(src.FileName).Replace(".", "")));

			CreateMap<CommentResource, Comment>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ?  src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.TimeStamp, opt => opt.MapFrom(src => DateTime.Now))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));

			CreateMap<ContactResource, Contact>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));
		}
	}
}
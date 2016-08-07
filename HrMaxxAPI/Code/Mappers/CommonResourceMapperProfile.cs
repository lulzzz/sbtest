using System;
using System.Collections.Generic;
using System.IO;
using AutoMapper;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Mapping;
using HrMaxxAPI.Resources.Common;
using Magnum;
using Newtonsoft.Json;

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
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.NotificationId))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.UserName, opt => opt.Ignore())
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

			CreateMap<AddressResource, Address>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));

			CreateMap<Address, AddressResource>()
				.ForMember(dest => dest.SourceId, opt => opt.Ignore())
				.ForMember(dest => dest.SourceTypeId, opt => opt.Ignore())
				.ForMember(dest => dest.TargetTypeId, opt => opt.Ignore());

			CreateMap<NewsResource, News>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now))
				.ForMember(dest => dest.Audience, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Audience)));

			CreateMap<News, NewsResource>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.UserName))
				.ForMember(dest => dest.TimeStamp, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.Audience, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<IdValuePair>>(src.Audience)));

			CreateMap<UserResource, UserModel>()
				.ForMember(dest => dest.UserId, opt => opt.MapFrom(src => src.UserId))
				.ForMember(dest => dest.FirstName, opt => opt.MapFrom(src => src.FirstName))
				.ForMember(dest => dest.LastName, opt => opt.MapFrom(src => src.LastName))
				.ForMember(dest => dest.Phone, opt => opt.MapFrom(src => src.Phone))
				.ForMember(dest => dest.Active, opt => opt.MapFrom(src => src.Active));

			CreateMap<UserModel, UserResource>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.UserId))
				.ForMember(dest => dest.UserId, opt => opt.MapFrom(src => src.UserId))
				.ForMember(dest => dest.FirstName, opt => opt.MapFrom(src => src.FirstName))
				.ForMember(dest => dest.LastName, opt => opt.MapFrom(src => src.LastName))
				.ForMember(dest => dest.Phone, opt => opt.MapFrom(src => src.Phone))
				.ForMember(dest => dest.Active, opt => opt.MapFrom(src => src.Active))
				.ForMember(dest => dest.SourceTypeId, opt => opt.Ignore())
				.ForMember(dest => dest.HostId, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.EmployeeId, opt => opt.Ignore())
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src=>src.UserName));
		}
	}
}
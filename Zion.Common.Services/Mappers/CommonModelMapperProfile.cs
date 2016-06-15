using System;
using System.Linq;
using AutoMapper;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Mapping;
using Magnum;

namespace HrMaxx.Common.Services.Mappers
{
	public class CommonModelMapperProfile : ProfileLazy
	{
		public CommonModelMapperProfile(Lazy<IMappingEngine> mapper) : base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();

			CreateMap<StagingDataDto, StagingData>();
			CreateMap<EntityDocumentAttachment, DocumentDto>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => CombGuid.Generate()))
				.ForMember(dest => dest.DocumentPath, opt => opt.Ignore())
				.ForMember(dest => dest.DocumentName, opt => opt.MapFrom(src => src.OriginalFileName))
				.ForMember(dest => dest.MimeType, opt => opt.MapFrom(src => src.MimeType))
				.ForMember(dest => dest.DocumentExtension, opt => opt.MapFrom(src => src.FileExtension));

			CreateMap<Notification, NotificationDto>();
			CreateMap<NotificationDto, Notification>();


			CreateMap<UserEventLogEntry, UserEventLog>()
				.ForMember(dest => dest.Id, opt => opt.Ignore())
				.ForMember(dest => dest.UserId, opt => opt.MapFrom(src => src.UserId))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.UserName))
				.ForMember(dest => dest.Event, opt => opt.MapFrom(src => (int)src.Event))
				.ForMember(dest => dest.EventObject, opt => opt.MapFrom(src => src.EventObject))
				.ForMember(dest => dest.Timestamp, opt => opt.MapFrom(src => DateTime.Now));

			CreateMap<UserEventLog, UserEventLogModel>()
				.ForMember(dest => dest.Event, opt => opt.MapFrom(src => ((UserEventEnum)src.Event).ToString()));

			CreateMap<User, UserProfile>()
				.ForMember(dest => dest.UserId, opt => opt.MapFrom(src => new Guid(src.Id)))
				.ForMember(dest => dest.FirstName, opt => opt.MapFrom(src => src.FirstName))
				.ForMember(dest => dest.LastName, opt => opt.MapFrom(src => src.LastName))
				.ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.Email))
				.ForMember(dest => dest.Phone, opt => opt.MapFrom(src => src.PhoneNumber))
				.ForMember(dest => dest.RoleId, opt => opt.MapFrom(src => src.Roles.Any() ? Convert.ToInt32(src.Roles.First().Id) : 0))
				.ForMember(dest => dest.Role, opt => opt.Ignore())
				.ForMember(dest => dest.AvailableRoles, opt => opt.Ignore());

			CreateMap<Role, UserRole>()
				.ForMember(dest => dest.RoleId, opt => opt.MapFrom(src => Convert.ToInt32(src.Id)))
				.ForMember(dest => dest.RoleName, opt => opt.MapFrom(src => src.Name));

			CreateMap<UserRole, Role>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.RoleId.ToString()))
				.ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.RoleName));

		}
	}
}
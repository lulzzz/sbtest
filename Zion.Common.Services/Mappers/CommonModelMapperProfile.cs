using System;
using AutoMapper;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Mapping;

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

			CreateMap<Models.DataModel.Document, DocumentDto>()
				.ForMember(dest => dest.DocumentPath, opt => opt.Ignore())
				.ForMember(dest => dest.DocumentExtension, opt => opt.MapFrom(src => src.DocumentExt));


			CreateMap<Notification, NotificationDto>();
			CreateMap<NotificationDto, Notification>();


			CreateMap<UserEventLogEntry, UserEventLog>()
				.ForMember(dest => dest.Id, opt => opt.Ignore())
				.ForMember(dest => dest.UserId, opt => opt.MapFrom(src => src.UserId))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.UserName))
				.ForMember(dest => dest.Event, opt => opt.MapFrom(src => (int) src.Event))
				.ForMember(dest => dest.EventObject, opt => opt.MapFrom(src => src.EventObject))
				.ForMember(dest => dest.Timestamp, opt => opt.MapFrom(src => DateTime.Now));

			CreateMap<UserEventLog, UserEventLogModel>()
				.ForMember(dest => dest.Event, opt => opt.MapFrom(src => ((UserEventEnum) src.Event).ToString()));
		}
	}
}
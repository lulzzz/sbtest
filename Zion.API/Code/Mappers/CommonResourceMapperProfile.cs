using System;
using AutoMapper;
using HrMaxx.API.Resources.Common;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Mapping;

namespace HrMaxx.API.Code.Mappers
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
		}
	}
}
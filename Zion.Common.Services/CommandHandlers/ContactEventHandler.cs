using System;
using System.Collections.Generic;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Services;
using Magnum;
using MassTransit;

namespace HrMaxx.Common.Services.CommandHandlers
{
	public class ContactEventHandler : BaseService, Consumes<ContactEvent>.All
	{
		public readonly INotificationService _NotificationService;
		public readonly IUserService _userService;

		public ContactEventHandler(INotificationService notificationService, IUserService userService)
		{
			_NotificationService = notificationService;
			_userService = userService;
		}
		public void Consume(ContactEvent event1)
		{
			var notificationList = new List<NotificationDto>();
			var notifyUsers = _userService.GetUsersByRoleAndId(RoleTypeEnum.Master, null);
			notifyUsers.ForEach(u => notificationList.Add(new NotificationDto
			{
				CreatedOn = DateTime.Now,
				IsRead = false,
				LoginId = u.ToString(),
				NotificationId = CombGuid.Generate(),
				Text = string.Format("Contact {0} has been updated by {1}", event1.Contact.FullName, event1.Source),
				Type = NotificationTypeEnum.Info.GetEnumDescription()
			}));
			_NotificationService.CreateNotifications(notificationList);
		}
	}
}
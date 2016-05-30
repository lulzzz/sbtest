﻿using System;
using System.Collections.Generic;
using System.Web.Http;
using HrMaxx.API.Resources.Common;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.API.Controllers
{
	public class NotificationsController : BaseApiController
	{
		private readonly INotificationService _notificationService;

		public NotificationsController(INotificationService notificationService)
		{
			_notificationService = notificationService;
		}

		[HttpGet]
		[Route(HrMaxxRoutes.GetNotifications)]
		public List<NotificationsResource> GetNotifications()
		{
			List<NotificationDto> notificationsDto =
				MakeServiceCall(() => _notificationService.GetNotifications(CurrentUser.UserId), "Get Notifications", true);
			List<NotificationsResource> notificationsResource =
				Mapper.Map<List<NotificationDto>, List<NotificationsResource>>(notificationsDto);
			return notificationsResource;
		}


		[HttpGet]
		[Route(HrMaxxRoutes.NotificationRead)]
		public void NotificationRead(Guid NotificationID)
		{
			MakeServiceCall(() => _notificationService.NotificationRead(NotificationID), "Mark Notification as Read");
		}
	}
}
using System;
using System.Collections.Generic;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxxAPI.Resources.Common;

namespace HrMaxxAPI.Controllers
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
		[HttpGet]
		[Route(HrMaxxRoutes.ClearAll)]
		public void ClearAll()
		{
			MakeServiceCall(() => _notificationService.ClearAllUserNotifications(CurrentUser.UserId), "Clear all user notificaitons for " + CurrentUser.UserId);
		}

		[HttpGet]
		[AllowAnonymous]
		[Route(HrMaxxRoutes.DeleteOldNotifications)]
		public void DeleteOldNotifications()
		{
			MakeServiceCall(() => _notificationService.DeleteOldNotifications(), "delete notifications older than 7 days");
		}
	}
}
using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.Common.Repository.Notifications
{
	public interface INotificationRepository
	{
		List<NotificationDto> GetNotifications(string LoginId);
		void CreateNotifications(List<NotificationDto> notificationList);

		void NotificationRead(Guid notificationId);
		void ClearAllNotiifications(string userId);
	}
}
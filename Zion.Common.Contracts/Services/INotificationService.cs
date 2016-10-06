using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.Common.Contracts.Services
{
	public interface INotificationService
	{
		List<NotificationDto> GetNotifications(string LoginId);
		void NotificationRead(Guid NotificationId);
		void CreateNotifications(List<NotificationDto> notificationList);
		void ClearAllUserNotifications(string userId);
	}
}
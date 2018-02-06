using System;
using System.Collections.Generic;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Repository.Notifications;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;

namespace HrMaxx.Common.Services.Notifications
{
	public class NotificationService : BaseService, INotificationService
	{
		private readonly INotificationRepository _notificationRepository;

		public NotificationService(INotificationRepository notificationRepository)
		{
			_notificationRepository = notificationRepository;
		}

		public List<NotificationDto> GetNotifications(string LoginId)
		{
			try
			{
				return _notificationRepository.GetNotifications(LoginId);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, "Notifications for selected user");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void NotificationRead(Guid NotificationId)
		{
			try
			{
				_notificationRepository.NotificationRead(NotificationId);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, "Mark notification as Read");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void CreateNotifications(List<NotificationDto> notificationList)
		{
			try
			{
				_notificationRepository.CreateNotifications(notificationList);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, "Create Notification");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void ClearAllUserNotifications(string userId)
		{
			try
			{
				_notificationRepository.ClearAllNotiifications(userId);
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, "Mark All Notifications for User as Invisiable" + userId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void DeleteOldNotifications()
		{
			try
			{
				_notificationRepository.DeleteOldNotifications();
			}
			catch (Exception e)
			{
				string message = string.Format(CommonStringResources.ERROR_FailedToSaveX, "Delete All notifications older than 7 days");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}
}
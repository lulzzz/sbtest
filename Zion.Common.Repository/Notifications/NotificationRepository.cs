using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Common.Models.DataModel;

namespace HrMaxx.Common.Repository.Notifications
{
	public class NotificationRepository : INotificationRepository
	{
		private readonly CommonEntities _dbContext;
		private readonly IMapper _mapper;
		
		public NotificationRepository(IMapper mapper, CommonEntities commonEntities)
		{
			_mapper = mapper;
			_dbContext = commonEntities;
			
		}

		public List<NotificationDto> GetNotifications(string LoginId)
		{
			DateTime sevenDaysBefore = DateTime.Now.AddDays(-7);
			List<Notification> userNotifications = _dbContext.Notifications
				.Where(notifications => notifications.LoginId.Equals(LoginId)
																&& notifications.IsVisible
				                        && (notifications.IsRead == false || notifications.CreatedOn >= sevenDaysBefore)
				)
				.OrderByDescending(notification => notification.CreatedOn).ToList();
			return _mapper.Map<List<Notification>, List<NotificationDto>>(userNotifications);
		}

		public void CreateNotifications(List<NotificationDto> notificationList)
		{
			var newNotifications =
				_mapper.Map<List<NotificationDto>, List<Notification>>(notificationList);
			foreach (var notification in newNotifications)
			{
				notification.IsVisible = true;
				_dbContext.Notifications.Add(notification);
			}
			_dbContext.SaveChanges();
		}

		public void NotificationRead(Guid notificationId)
		{
			var selectedNotification =
				_dbContext.Notifications.FirstOrDefault(notification => notification.NotificationId.Equals(notificationId));
			if (selectedNotification != null) selectedNotification.IsRead = true;
			_dbContext.SaveChanges();
		}

		public void ClearAllNotiifications(string userId)
		{
			var notifications = _dbContext.Notifications.Where(n => n.LoginId == userId).ToList();
			notifications.ForEach(n=>n.IsVisible=false);
			_dbContext.SaveChanges();
		}

		public void DeleteOldNotifications()
		{
			DateTime sevenDaysBefore = DateTime.Now.AddDays(-7);
			var notifications = _dbContext.Notifications.Where(n => n.CreatedOn <= sevenDaysBefore.Date);
			_dbContext.Notifications.RemoveRange(notifications);
			_dbContext.SaveChanges();
		}
	}
}
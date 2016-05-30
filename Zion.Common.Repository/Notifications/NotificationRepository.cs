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
				                        && (notifications.IsRead == false || notifications.CreatedOn >= sevenDaysBefore)
				)
				.OrderByDescending(notification => notification.CreatedOn).ToList();
			return _mapper.Map<List<Notification>, List<NotificationDto>>(userNotifications);
		}

		public void CreateNotifications(List<NotificationDto> notificationList)
		{
			List<Notification> newNotifications =
				_mapper.Map<List<NotificationDto>, List<Notification>>(notificationList);
			foreach (Notification notification in newNotifications)
			{
				_dbContext.Notifications.Add(notification);
			}
			_dbContext.SaveChanges();
		}

		public void NotificationRead(Guid NotificationId)
		{
			Notification selectedNotification =
				_dbContext.Notifications.Where(notification => notification.NotificationId.Equals(NotificationId)).FirstOrDefault();
			selectedNotification.IsRead = true;
			_dbContext.SaveChanges();
		}
	}
}
using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Infrastructure.Repository;
using System.Data.Common;
using Dapper;

namespace HrMaxx.Common.Repository.Notifications
{
	public class NotificationRepository : BaseDapperRepository, INotificationRepository
	{
		private readonly CommonEntities _dbContext;
		private readonly IMapper _mapper;
		

		public NotificationRepository(IMapper mapper, CommonEntities commonEntities, DbConnection connection) : base(connection)
		{
			_mapper = mapper;
			_dbContext = commonEntities;
			
		}

		public List<NotificationDto> GetNotifications(string LoginId)
		{
			DateTime sevenDaysBefore = DateTime.Now.AddDays(-7).Date;
			const string sql = "select * from Notifications where LoginId=@LoginId and IsVisible=1 and (IsRead=0 or CreatedOn>=@Date) order by CreatedOn desc";
			var result = Query<Notification>(sql, new { LoginId = LoginId, Date = sevenDaysBefore });
			return _mapper.Map<List<Notification>, List<NotificationDto>>(result.ToList());
			
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
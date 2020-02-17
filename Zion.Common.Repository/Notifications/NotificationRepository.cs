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
			const string sql = "insert into Notifications (NotificationId, Type, Text, MetaData, LoginId, IsRead, CreatedOn, IsVisible) value(@NotificationId, @Type, @Text, @MetaData, @LoginId, @IsRead, @CreatedOn, 1)";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, notificationList);
			}
			//foreach (var notification in newNotifications)
			//{
			//	notification.IsVisible = true;
			//	_dbContext.Notifications.Add(notification);
			//}
			//_dbContext.SaveChanges();
		}

		public void NotificationRead(Guid notificationId)
		{
			using (var conn = GetConnection())
			{
				const string sql = "update Notifications set IsRead=1 where NotificationId=@NotificationId";
				conn.Execute(sql, new { NotificationId = notificationId });
			}
			
		}

		public void ClearAllNotiifications(string userId)
		{
			using(var conn = GetConnection())
			{
				const string sql = "update Notifications set IsVisible=0 where LoginId=@LoginId";
				conn.Execute(sql, new { LoginId = userId });
			}
			
		}

		public void DeleteOldNotifications()
		{
			using (var conn = GetConnection())
			{
				DateTime sevenDaysBefore = DateTime.Now.AddDays(-7).Date;
				const string sql = "delete from Notifications set CreatedOn<=@Date";
				conn.Execute(sql, new { Date = sevenDaysBefore });
			}
			
		}
	}
}
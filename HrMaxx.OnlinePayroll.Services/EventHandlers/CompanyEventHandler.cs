using System.Collections.Generic;
using System.Linq;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using MassTransit;
using Notification = HrMaxx.Common.Contracts.Messages.Events.Notification;

namespace HrMaxx.OnlinePayroll.Services.EventHandlers
{
	public class CompanyEventHandler : BaseService, Consumes<CompanyUpdatedEvent>.All, Consumes<EmployeeUpdatedEvent>.All
	{
		public IBus Bus { get; set; }
		private readonly IUserService _userService;

		public CompanyEventHandler(IUserService userService)
		{
			_userService = userService;
		}
		public void Consume(CompanyUpdatedEvent event1)
		{
			var users = _userService.GetUsers(event1.SavedObject.HostId, event1.SavedObject.Id).Select(u=>u.UserId).ToList();
			var adminUsers = _userService.GetUsersByRoleAndId(new List<RoleTypeEnum>() {RoleTypeEnum.CorpStaff, RoleTypeEnum.Master}, null);
			users.AddRange(adminUsers);
			Bus.Publish<Notification>(new Notification
			{
				SavedObject = event1.SavedObject,
				SourceId = event1.SavedObject.Id,
				UserId = event1.UserId,
				Source = event1.UserName,
				TimeStamp = event1.TimeStamp,
				Text = event1.NotificationText,
				ReturnUrl = "#!/Client/Company/?name=" + event1.SavedObject.Name,
				EventType = event1.EventType,
				AffectedUsers = users.Distinct().ToList()
			});


		}
		public void Consume(EmployeeUpdatedEvent event1)
		{
			var users = _userService.GetUsers(event1.SavedObject.CompanyId, event1.SavedObject.Id).Select(u => u.UserId).ToList();
			
			Bus.Publish<Notification>(new Notification
			{
				SavedObject = event1.SavedObject,
				SourceId = event1.SavedObject.Id,
				UserId = event1.UserId,
				Source = event1.UserName,
				TimeStamp = event1.TimeStamp,
				Text = event1.NotificationText,
				ReturnUrl = "#!/Client/Employee/?id=" + event1.SavedObject.Id,
				EventType = event1.EventType,
				AffectedUsers = users.Distinct().ToList()
			});


		}
	}
}
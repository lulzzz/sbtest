using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Contracts.Messages.Events
{
	public class UserEventLogEntry : Event
	{
		public string UserId { get; set; }
		public string UserName { get; set; }
		public UserEventEnum Event { get; set; }
		public string EventAction { get; set; }
		public string EventObject { get; set; }
		public string EventObjectName { get; set; }
		public string Module { get; set; }
	}
}
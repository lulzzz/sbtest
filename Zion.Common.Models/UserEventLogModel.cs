using System;

namespace HrMaxx.Common.Models
{
	public class UserEventLogModel
	{
		public int Id { get; set; }
		public string UserId { get; set; }
		public string UserName { get; set; }
		public string Event { get; set; }
		public string EventObject { get; set; }
		public DateTime Timestamp { get; set; }
		public string EventObjectName { get; set; }
		public string EventAction { get; set; }
		public string Module { get; set; }
	}
}
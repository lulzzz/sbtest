using System;

namespace HrMaxx.API.Resources.Common
{
	public class NotificationsResource : BaseRestResource
	{
		public Guid NotificationID { get; set; }
		public string Type { get; set; }
		public string Text { get; set; }
		public string Metadata { get; set; }
		public Boolean IsRead { get; set; }
		public DateTime CreatedOn { get; set; }
	}
}
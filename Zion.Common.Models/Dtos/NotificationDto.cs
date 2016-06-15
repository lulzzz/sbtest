using System;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Models.Dtos
{
	public class NotificationDto
	{
		public Guid NotificationId { get; set; }
		public string Type { get; set; }
		public string Text { get; set; }
		public string MetaData { get; set; }
		public Boolean IsRead { get; set; }
		public string LoginId { get; set; }
		public DateTime CreatedOn { get; set; }
		public RoleTypeEnum AudienceRole { get; set; }
		public Guid? AudienceId { get; set; }
	}
}
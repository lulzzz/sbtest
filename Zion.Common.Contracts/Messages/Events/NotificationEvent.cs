using System;
using System.Collections.Generic;
using System.Security.Permissions;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Contracts.Messages.Events
{
	public class Notification : Event
	{
		public BaseEntityDto SavedObject { get; set; }
		public Guid UserId { get; set; }
		public string UserName { get; set; }
		public DateTime TimeStamp { get; set; }
		public Guid SourceId { get; set; }
		public EntityTypeEnum SourceTypeId { get; set; }
		public string Source { get; set; }
		public List<RoleTypeEnum> Roles { get; set; }
		public string Text { get; set; }
		public string ReturnUrl { get; set; }
	}
}
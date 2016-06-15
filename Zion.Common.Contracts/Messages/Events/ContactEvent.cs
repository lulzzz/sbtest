using System;
using System.Security.Permissions;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Contracts.Messages.Events
{
	public class ContactEvent : Event
	{
		public Contact Contact { get; set; }
		public Guid UserId { get; set; }
		public string UserName { get; set; }
		public DateTime TimeStamp { get; set; }
		public Guid SourceId { get; set; }
		public EntityTypeEnum SourceTypeId { get; set; }
		public string Source { get; set; }
	}
}
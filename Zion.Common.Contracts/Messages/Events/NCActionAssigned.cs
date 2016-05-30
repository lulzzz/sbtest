using System;
using Zion.Bus.Contracts;

namespace Zion.Common.Contracts.Messages.Events{
	public class NCActionAssigned : Event
	{
		public Guid? ChecklistID{get;set;}
		public Guid? ProjectID { get; set; }
		public string WorkSiteId { get; set; }
		public string CreatedBy { get; set; }
		public DateTime? CreatedOn { get; set; }
		public string AssignedTo { get; set; }
		public DateTime? DueDate { get; set; }
	}
}

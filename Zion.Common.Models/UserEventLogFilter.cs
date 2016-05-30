using System;

namespace HrMaxx.Common.Models
{
	public class UserEventLogFilter
	{
		public string UserId { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public string Module { get; set; }
		public int? Event { get; set; }
	}
}
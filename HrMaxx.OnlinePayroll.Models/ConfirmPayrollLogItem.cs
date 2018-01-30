using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class ConfirmPayrollLogItem
	{
		public Guid PayrollId { get; set; }
		public Guid CompanyId { get; set; }
		public int CompanyIntId { get; set; }
		public DateTime QueuedTime { get; set; }
		public DateTime? ConfirmedTime { get; set; }
	}
}

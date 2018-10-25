using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class InvoiceRecurringCharge
	{
		public Guid InvoiceId { get; set; }
		public Guid CompanyId { get; set; }
		public int InvoiceNumber { get; set; }
		public int RecurringChargeId { get; set; }
		public string Description { get; set; }
		public decimal Amount { get; set; }
		public decimal Rate { get; set; }
		public decimal Claimed { get; set; }
		public int NewRecurringChargeId { get; set; }
	}
}

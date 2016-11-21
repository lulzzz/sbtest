using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class InvoiceDeliveryClaim
	{
		public int Id { get; set; }
		public Guid UserId { get; set; }
		public string UserName { get; set; }
		public List<PayrollInvoice> Invoices { get; set; }
		public DateTime DeliveryClaimedOn { get; set; }
	}
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Bus.Contracts;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Messages.Events
{
	public class InvoiceRecurringChargesHandleEvent : Event
	{
		public PayrollInvoice DbInvoice { get; set; }
		public PayrollInvoice Invoice { get; set; }
	}
}

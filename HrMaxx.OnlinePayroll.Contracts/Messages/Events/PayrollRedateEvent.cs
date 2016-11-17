using System;
using System.Collections.Generic;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Messages.Events
{
	public class PayrollRedateEvent : Event
	{
		public Guid CompanyId { get; set; }
		public Guid UserId { get; set; }
		public string UserName { get; set; }
		public DateTime TimeStamp { get; set; }
		public int Year { get; set; }
		public List<PayCheck> AffectedPayChecks { get; set; }
		public int InvoiceNumber { get; set; }
	}
}
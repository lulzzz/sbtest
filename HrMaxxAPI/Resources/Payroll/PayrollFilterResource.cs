using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxxAPI.Resources.Payroll
{
	public class PayrollFilterResource
	{
		[Required]
		public Guid CompanyId { get; set; }
		
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
	}

	public class PayrollPrintRequest
	{
		public Guid DocumentId { get; set; }
		public int PayCheckId { get; set; }
	}

	public class PayrollInvoiceFilterResource
	{
		public Guid? CompanyId { get; set; }
		public List<InvoiceStatus> Status { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
	}
}
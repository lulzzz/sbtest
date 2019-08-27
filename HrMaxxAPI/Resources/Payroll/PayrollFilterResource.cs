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
		public bool? WithoutInvoice { get; set; }
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
		public List<PaymentStatus> PaymentStatus { get; set; }
		public List<InvoicePaymentMethod> PaymentMethod { get; set; } 
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public bool IncludeDelayedTaxes { get; set; }
		public bool IncludeRedated { get; set; }
	}

	public class MoveCopyPayrollRequest
	{
		public Guid SourceId { get; set; }
		public Guid TargetId { get; set; }
		public bool MoveAll { get; set; }
		public List<Guid> Payrolls { get; set; }
		public bool AsHistory { get; set; }
	}
}
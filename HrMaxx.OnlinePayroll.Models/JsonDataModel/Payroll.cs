using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	public class PayrollJson
	{
		public System.Guid Id { get; set; }
		public System.Guid CompanyId { get; set; }
		public System.DateTime StartDate { get; set; }
		public System.DateTime EndDate { get; set; }
		public System.DateTime PayDay { get; set; }
		public int StartingCheckNumber { get; set; }
		public string Company { get; set; }
		public System.DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
		public int Status { get; set; }
		public Nullable<System.Guid> InvoiceId { get; set; }
		public bool PEOASOCoCheck { get; set; }
		public string Notes { get; set; }
		public virtual List<PayrollInvoiceJson> PayrollInvoices { get; set; }
		public virtual List<PayrollPayCheckJson> PayrollPayChecks { get; set; }
	}
}

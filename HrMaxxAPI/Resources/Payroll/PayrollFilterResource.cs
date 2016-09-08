using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

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
}
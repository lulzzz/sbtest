using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class ReportResponse
	{
		public Company Company { get; set; }
		public PayrollAccumulation CompanyAccumulation { get; set; }
		public List<EmployeeAccumulation> EmployeeAccumulations { get; set; }
		public List<PayCheck> PayChecks;
	}

	public class EmployeeAccumulation
	{
		public Employee Employee { get; set; }
		public List<PayCheck> PayChecks { get; set; } 
		public PayrollAccumulation Accumulation { get; set; }
	}
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Resources.OnlinePayroll;
using HrMaxxAPI.Resources.Payroll;

namespace HrMaxxAPI.Resources.Reports
{
	public class ReportResponseResource
	{
		public CompanyResource Company { get; set; }
		public PayrollAccumulation CompanyAccumulation { get; set; }
		public List<EmployeePayrollAccumulation> EmployeeAccumulations { get; set; }
		public List<PayCheckResource> PayChecks;
		public List<CoaTypeBalanceDetail> AccountDetails { get; set; } 
	}
}
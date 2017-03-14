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
		public Accumulation CompanyAccumulations { get; set; }
		public List<Accumulation> EmployeeAccumulationList { get; set; } 
		public List<PayCheckResource> PayChecks;
		public List<CoaTypeBalanceDetail> AccountDetails { get; set; } 
	}
}
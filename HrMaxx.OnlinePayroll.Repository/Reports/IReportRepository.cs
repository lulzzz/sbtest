using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Repository.Reports
{
	public interface IReportRepository
	{
		List<PayCheck> GetReportPayChecks(ReportRequest request, bool includeVoids);
		List<EmployeeAccumulation> GetEmployeeGroupedChecks(ReportRequest request, bool includeVoids);
		PayrollAccumulation GetCompanyPayrollCube(ReportRequest request);
	}
}

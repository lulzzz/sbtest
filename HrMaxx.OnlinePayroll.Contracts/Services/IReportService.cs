using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IReportService
	{
		ReportResponse GetReport(ReportRequest request);
		FileDto GetReportDocument(ReportRequest request);
		Extract GetExtractDocument(ReportRequest request);
		FileDto PrintPayrollWithSummary(Payroll payroll, List<Guid> documents );
		DashboardData GetDashboardData(DashboardRequest dashboardRequest);
	}
}

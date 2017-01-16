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
		FileDto PrintPayrollSummary(Payroll payroll );
		List<DashboardData> GetDashboardData(DashboardRequest dashboardRequest);
		List<MasterExtract> GetExtractList(string report);
		List<SearchResult> GetSearchResults(string criteria, string role, Guid host, Guid company);
		ACHExtract GetACHReport(ReportRequest request);
		ACHExtract GetACHExtract(ACHExtract data, string fullName);
		List<ACHMasterExtract> GetACHExtractList();
		FileDto PrintPayrollWithoutSummary(Payroll payroll, List<Guid> documents);
		FileDto PrintPayrollTimesheet(Payroll payroll);
		FileDto PrintPayrollWithoutSummary(Payroll payroll, List<FileDto> documents);
	}
}

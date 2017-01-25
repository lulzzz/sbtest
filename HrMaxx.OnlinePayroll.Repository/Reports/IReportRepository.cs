using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Repository.Reports
{
	public interface IReportRepository
	{
		List<PayCheck> GetReportPayChecks(ReportRequest request, bool includeVoids);
		List<EmployeePayrollAccumulation> GetEmployeeGroupedChecks(ReportRequest request, bool includeVoids);
		PayrollAccumulation GetCompanyPayrollCube(ReportRequest request);
		List<CompanyPayrollCube> GetCompanyCubesForYear(Guid companyId, int year);
		List<DashboardData> GetDashboardData(DashboardRequest dashboardRequest);
		ExtractResponse GetExtractReport(ReportRequest extractReport);
		List<MasterExtract> GetExtractList(string report);
		SearchResults GetSearchResults(string criteria, string role, Guid host, Guid company);
		ACHResponse GetACHReport(ReportRequest extractReport);
		void SaveACHExtract(ACHExtract extract, string fullName);
		List<ACHMasterExtract> GetACHExtractList();
	}
}

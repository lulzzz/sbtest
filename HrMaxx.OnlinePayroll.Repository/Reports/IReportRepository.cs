using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Repository.Reports
{
	public interface IReportRepository
	{
		
		PayrollAccumulation GetCompanyPayrollCube(ReportRequest request);
		List<CompanyPayrollCube> GetCompanyCubesForYear(Guid companyId, int year);
		List<DashboardData> GetDashboardData(DashboardRequest dashboardRequest);
		ExtractResponse GetExtractReport(ReportRequest extractReport);
		
		SearchResults GetSearchResults(string criteria, string role, Guid host, Guid company);
		ACHResponse GetACHReport(ReportRequest extractReport);
		void SaveACHExtract(ACHExtract extract, string fullName);
		
		MasterExtract SaveCommissionExtract(CommissionsExtract extract, string fullName);

		void ConfirmExtract(MasterExtract extract);
	}
}

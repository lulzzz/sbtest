using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Repository.Reports
{
	public interface IReportRepository
	{
		
		List<DashboardData> GetDashboardData(DashboardRequest dashboardRequest);
		ExtractResponse GetExtractReport(ReportRequest extractReport);
		
		SearchResults GetSearchResults(string criteria, string role, Guid host, Guid company);
		ACHResponse GetACHReport(ReportRequest extractReport);
		MasterExtract SaveACHExtract(ACHExtract extract, string fullName);
		
		MasterExtract SaveCommissionExtract(CommissionsExtract extract, string fullName);

		void ConfirmExtract(MasterExtract extract);
	}
}

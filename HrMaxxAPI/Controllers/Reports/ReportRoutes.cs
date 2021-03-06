﻿namespace HrMaxxAPI.Controllers.Journals
{
	public class ReportRoutes
	{
		public const string ACHExtract = "Reports/ACHExtract/{id:int}";
		public const string ACHReport = "Reports/ACHReport";
		public const string ProfitStarsPayrollList = "Reports/ProfitStarsPayrollList";
		public const string MarkFundingSuccessful = "Reports/MarkFundingSuccessful/{fundRequestId:int}";
		public const string ProfitStars1pm = "Reports/ProfitStars1pm";
		public const string ProfitStars9am = "Reports/ProfitStars9am";
		public const string ACHFileAndExtract = "Reports/ACHFileAndExtract";

		public const string Report = "Reports/Report";
		public const string CPAReport = "Reports/CPAReport";

		public const string ReportDocument = "Reports/ReportDocument";
		public const string ExtractDocument = "Reports/ExtractDocument";
		public const string GetDashBoardReport = "Reports/DashboardReport";
		public const string InvoiceStatusList = "Reports/InvoiceStatusList";
		public const string DownloadReport = "Reports/DownloadReport";
		public const string FileTaxes = "Reports/FileTaxes";
		public const string ExtractList = "Reports/ExtractList/{Report}";
		public const string DeleteExtract = "Reports/DeleteExtract/{extractId:int}";
		public const string ConfirmExtract = "Reports/ConfirmExtract";
		
		public const string GetSearchResults = "Reports/SearchResults";
		public const string DownloadExtract = "Reports/DownloadExtract";
		public const string PrintExtractBatch = "Reports/PrintExtractBatch";
		public const string PrintExtractBatchAll = "Reports/PrintExtractBatchAll";
		public const string Extract = "Reports/Extract/{id:int}";
		public const string CommissionExtract = "Reports/CommissionExtract/{id:int}";
		public const string ExtractDocumentReport = "Reports/ExtractDocumentReport";
		public const string PrintChecks = "Reports/PrintExtractChecks";
		public const string EmailExtractClients = "Reports/EmailExtractClients";
		public const string CreateDepositTickets = "Reports/CreateDepositTickets";
		public const string CommissionsReport = "Reports/CommissionsReport";
		public const string PayCommissions = "Reports/PayCommissions";
		public const string MinWageEligibilityReport = "Reports/MinWageEligibilityReport";
		public const string CompanyDashboard = "Reports/CompanyDashboard/{id:guid}";
		public const string ExtractDashboard = "Reports/ExtractDashboard/";
		public const string EmployeeDashboard = "Reports/EmployeeDashboard/{companyId:guid}/{employeeId:guid}";
		public const string StaffDashboard = "Reports/StaffDashboard/{hostId:guid?}";
		public const string StaffDashboardDocuments = "Reports/StaffDashboardDocuments/{hostId:guid?}";
	}
}
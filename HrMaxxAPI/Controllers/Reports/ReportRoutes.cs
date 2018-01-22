namespace HrMaxxAPI.Controllers.Journals
{
	public class ReportRoutes
	{
		public const string ACHExtract = "Reports/ACHExtract/{id:int}";
		public const string ACHReport = "Reports/ACHReport";
		public const string ACHFileAndExtract = "Reports/ACHFileAndExtract";

		public const string Report = "Reports/Report";
		public const string CPAReport = "Reports/CPAReport";

		public const string ReportDocument = "Reports/ReportDocument";
		public const string ExtractDocument = "Reports/ExtractDocument";
		public const string GetDashBoardReport = "Reports/DashboardReport";
		public const string DownloadReport = "Reports/DownloadReport";
		public const string FileTaxes = "Reports/FileTaxes";
		public const string ExtractList = "Reports/ExtractList/{Report}";
		public const string DeleteExtract = "Reports/DeleteExtract/{extractId:int}";
		public const string ConfirmExtract = "Reports/ConfirmExtract";
		
		public const string GetSearchResults = "Reports/SearchResults";
		public const string DownloadExtract = "Reports/DownloadExtract";
		public const string PrintExtractBatch = "Reports/PrintExtractBatch";
		public const string Extract = "Reports/Extract/{id:int}";
		public const string CommissionExtract = "Reports/CommissionExtract/{id:int}";
		public const string ExtractDocumentReport = "Reports/ExtractDocumentReport";
		public const string PrintChecks = "Reports/PrintExtractChecks";
		public const string CreateDepositTickets = "Reports/CreateDepositTickets";
		public const string CommissionsReport = "Reports/CommissionsReport";
		public const string PayCommissions = "Reports/PayCommissions";
	}
}
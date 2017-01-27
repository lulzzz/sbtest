namespace HrMaxxAPI.Controllers.Journals
{
	public class ReportRoutes
	{
		public const string ACHReport = "Reports/ACHReport";
		public const string ACHFileAndExtract = "Reports/ACHFileAndExtract";

		public const string Report = "Reports/Report";

		public const string ReportDocument = "Reports/ReportDocument";
		public const string ExtractDocument = "Reports/ExtractDocument";
		public const string GetDashBoardReport = "Reports/DashboardReport";
		public const string DownloadReport = "Reports/DownloadReport";
		public const string FileTaxes = "Reports/FileTaxes";
		public const string ExtractList = "Reports/ExtractList/{Report}";
		public const string ACHExtractList = "Reports/ACHExtractList";
		public const string GetSearchResults = "Reports/SearchResults/{criteria}";
		public const string DownloadExtract = "Reports/DownloadExtract";
		public const string Extract = "Reports/Extract/{id:int}";
		public const string ExtractDocumentReport = "Reports/ExtractDocumentReport";
		public const string PrintChecks = "Reports/PrintExtractChecks";
	}
}
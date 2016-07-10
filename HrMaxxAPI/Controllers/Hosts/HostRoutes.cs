namespace HrMaxxAPI.Controllers.Hosts
{
	public class HostRoutes
	{
		
		public const string Hosts = "Host/Hosts";
		public const string Save = "Host/Save";
		public const string HostHomePage = "Host/HomePage/{cpaId:guid}";
		public const string HostHomePageForEdit = "Host/HomePageForEdit/{cpaId:guid}";
		public const string SaveHomePage = "Host/HomePage";
		public const string HostLogoUpload = "Document/HomePageImage";
		public const string HostWelcome = "Host/HostWelcome/{url}";
		public const string HostWelcomeByFirmName = "Host/HostWelcomeByFirmName/{firmName}";

		public const string NewsMetaData = "Host/NewsMetaData";
	}
}
namespace HrMaxxAPI.Controllers.Companies
{
	public class CompanyRoutes
	{
		public const string MetaData = "Company/MetaData";
		public const string Companies = "Company/Companies/{hostId:guid}";
		public const string Save = "Company/Save";

		public const string SaveDeduction = "Company/Deduction";
		public const string SaveWorkerCompensation = "Company/WorkerCompensation";
		public const string SaveAccumulatedPayType = "Company/AccumulatedPayType";
		public const string SavePayCode = "Company/PayCode";
	}
}
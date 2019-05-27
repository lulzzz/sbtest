namespace HrMaxxAPI.Controllers
{
	public class HrMaxxRoutes
	{
		
		public const string Document = "Document/{documentId:guid}";
		public const string DocumentById = "DocumentById/{documentId:guid}/{extension}/{filename}";
		public const string DocumentUpload = "Document/UploadEntityDocument";
		public const string Version = "Version";
		public const string Countries = "Countries";
	
		
		public const string GetUserFullName = "GetUserFullName";
	
		public const string GetNotifications = "GetNotifications";
		public const string NotificationRead = "NotificationRead/{NotificationID:guid}";

		public const string DeleteDocument = "Document/DeleteEntityDocument/{entityTypeId:int}/{entityId:guid}/{documentId:guid}";

		public const string Addresses = "Common/Addresses/{sourceTypeId:int}/{sourceId:guid}";
		public const string FirstAddress = "Common/FirstAddress/{sourceTypeId:int}/{sourceId:guid}";
		public const string Documents = "Common/Documents/{sourceTypeId:int}/{sourceId:guid}";
		public const string Contacts = "Common/Contacts/{sourceTypeId:int}/{sourceId:guid}";
		public const string Comments = "Common/Comments/{sourceTypeId:int}/{sourceId:guid}";


		public const string DeleteRelationship =
			"Common/DeleteEntityRelation/{sourceTypeId:int}/{targetTypeId:int}/{sourceId:guid}/{targetId:guid}";

		public const string SaveComment = "Common/SaveComment";

		public const string SaveContact = "Common/SaveContact";
		public const string SaveAddress = "Common/SaveAddress";

		public const string Newsfeed = "Common/Newsfeed/{audienceScope:int}/{audienceId:guid?}";
		public const string SaveNewsfeed = "Common/Newsfeed";

		public const string UserNewsfeed = "Common/UserNewsfeed";
		public const string AccountsMetaData = "AccountsMetaData";
		public const string Configs = "Configurations";
		public const string ClearAll = "ClearAllNotifications";
		public const string DeleteOldNotifications = "DeleteOldNotifications";

		public const string InsuranceGroups = "InsuranceGroups";
		public const string InsuranceGroup = "InsuranceGroup";
		public const string Mementos = "Mementos/{sourceId:guid}/{sourceTypeId:int}";

		public const string FillSearchTable = "FillSearchTable";
		public const string GetHostsAndCompanies = "HostsAndCompanies/{status:int?}";

		public const string GetTaxes = "GetTaxes/{year:int}";
		public const string SaveTaxes = "SaveTaxes";
		public const string CreateTaxes = "CreateTaxes/{year:int}";
		public const string AccessMetaData = "AccessMetaData";
		public const string GetTaxTableYear = "GetTaxTableYears";
		public const string Encrypt = "Encrypt/{data}";
		public const string Decrypt = "Decrypt/{data}";
	}
}
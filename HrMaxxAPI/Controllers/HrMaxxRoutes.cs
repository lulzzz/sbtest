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
	}
}
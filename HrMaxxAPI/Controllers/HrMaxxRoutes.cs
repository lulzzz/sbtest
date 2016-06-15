namespace HrMaxxAPI.Controllers
{
	public class HrMaxxRoutes
	{
		
		public const string Document = "Document/{documentId:guid}";
		public const string DocumentUpload = "Document/UploadEntityDocument";
		public const string Version = "Version";
		public const string Countries = "Countries";
	
		
		public const string GetUserFullName = "GetUserFullName";
	
		public const string GetNotifications = "GetNotifications";
		public const string NotificationRead = "NotificationRead/{NotificationID:guid}";

		public const string DeleteDocument = "Document/DeleteEntityDocument/{entityTypeId:int}/{entityId:guid}/{documentId:guid}";

		public const string GetAddresses = "Common/AddressList/{sourceTypeId:int}/{sourceId:guid}";

		public const string DeleteRelationship =
			"Common/DeleteEntityRelation/{sourceTypeId:int}/{targetTypeId:int}/{sourceId:guid}/{targetId:guid}";

		public const string SaveComment = "Common/SaveComment";

		public const string SaveContact = "Common/SaveContact";
		public const string GetContacts = "Common/ContactList/{sourceTypeId:int}/{sourceId:guid}";

	}
}
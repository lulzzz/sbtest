namespace HrMaxxAPI.Controllers.User
{
	public class UserRoutes
	{

		public const string User = "User/{userId:guid}";
		public const string Users = "Users/{hostId:guid?}/{companyId:guid?}";
		public const string SaveUserProfile = "User";
		public const string SaveUser = "SaveUser";
		public const string ResetPassword = "UserPasswordReset";
	}
}
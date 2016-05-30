using System.Configuration;
using System.Web.Http;
using HrMaxxAPI.Resources;

namespace HrMaxxAPI.Controllers
{
	/// <summary>
	///   HrMaxx Controller is the API for common areas
	/// </summary>
	public class HrMaxxController : BaseApiController
	{
		/// <summary>
		///   Retrieve the current version of the deployed application
		/// </summary>
		/// <returns>Version of application</returns>
		[AllowAnonymous]
		[HttpGet]
		[Route(HrMaxxRoutes.Version)]
		public VersionResource Version()
		{
			return new VersionResource
			{
				Version = ConfigurationManager.AppSettings["TokenVersion"]
			};
		}


		[HttpGet]
		[Route(HrMaxxRoutes.GetUserFullName)]
		public string GetUserFullName()
		{
			return CurrentUser.FullName;
		}
	}
}
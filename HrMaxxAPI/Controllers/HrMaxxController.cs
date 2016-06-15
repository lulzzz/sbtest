using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxxAPI.Resources;

namespace HrMaxxAPI.Controllers
{
	/// <summary>
	///   HrMaxx Controller is the API for common areas
	/// </summary>
	public class HrMaxxController : BaseApiController
	{
		public readonly ICommonService _commonService;
		public HrMaxxController(ICommonService commonService)
		{
			_commonService = commonService;
		}
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

		[HttpGet]
		[Route(HrMaxxRoutes.Countries)]
		public IList<Country> GetCountries()
		{
			return MakeServiceCall(() => _commonService.GetCountries(), "Get Countries in the System", true);
		}
	}
}
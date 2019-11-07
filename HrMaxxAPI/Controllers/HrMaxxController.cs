using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Resources;

namespace HrMaxxAPI.Controllers
{
	/// <summary>
	///   HrMaxx Controller is the API for common areas
	/// </summary>
	public class HrMaxxController : BaseApiController
	{
		public readonly ICommonService _commonService;
		public readonly ITaxationService _taxationService;
		
		public HrMaxxController(ICommonService commonService, ITaxationService taxationService)
		{
			_commonService = commonService;
			_taxationService = taxationService;
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
		

		[HttpGet]
		[Route(HrMaxxRoutes.Configs)]
		public ApplicationConfig Configs()
		{
			return MakeServiceCall(() => _taxationService.GetApplicationConfig(), "Get Application config", true);
		}

		[HttpPost]
		[Route(HrMaxxRoutes.Configs)]
		public ApplicationConfig SaveConfigs(ApplicationConfig configs)
		{
			return MakeServiceCall(() => _taxationService.SaveApplicationConfiguration(configs), "Save Application config", true);
		}

		[HttpGet]
		[Route(HrMaxxRoutes.Encrypt)]
		public string Encrypt(string data)
		{
			return Crypto.Encrypt(data);
		}
		[HttpGet]
		[Route(HrMaxxRoutes.Decrypt)]
		public string Decrypt(string data)
		{
			return Crypto.Decrypt(data);
		}
	}
}
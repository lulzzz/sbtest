using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Mementos;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Code.Helpers;
using HrMaxxAPI.Resources.Common;
using HrMaxxAPI.Resources.OnlinePayroll;

namespace HrMaxxAPI.Controllers.Hosts
{
	public class HostController : BaseApiController
	{
		private readonly IHostService _hostService;
		
		public HostController(IHostService hostService)
		{
			_hostService = hostService;
		}

		[HttpGet]
		[Route(HostRoutes.Host)]
		public Host GetHost()
		{
			return MakeServiceCall(() => _hostService.GetHost(CurrentUser.Host), "Get Current User's host", true);
		}

		[HttpGet]
		[Route(HostRoutes.Hosts)]
		public IList<Host> GetHosts()
		{
			return MakeServiceCall(() => _hostService.GetHostList(), "Get list of all hosts", true);
		}

		[HttpGet]
		[AllowAnonymous]
		[Route(HostRoutes.HostWelcome)]
		public object GetHostWelcome(string url)
		{
			return MakeServiceCall(() => _hostService.GetHostHomePageByUrl(url, CurrentUser.Host), "Get home page for the host", true);
			
		}

		[HttpGet]
		[Route(HostRoutes.HostHomePage)]
		public HostHomePage GetHostHomePage(Guid cpaId)
		{
			return MakeServiceCall(() => _hostService.GetHostHomePage(cpaId), "Get home page for the host", true);
		}
		[HttpGet]
		[Route(HostRoutes.HostWelcomeByFirmName)]
		public object GetHostWelcomeByFirmName(string firmName)
		{
			return MakeServiceCall(() => _hostService.GetHostHomePageByFirmName(firmName, CurrentUser.Host), "Get home page for the host", true);
		}

		[HttpGet]
		[Route(HostRoutes.HostHomePageForEdit)]
		public HomePageResource GetHostHomePageForEdit(Guid cpaId)
		{
			var homepage = MakeServiceCall(() => _hostService.GetHostHomePage(cpaId), "Get home page for the host", true);
			return Mapper.Map<HostHomePage, HomePageResource>(homepage);
		}

		[HttpPost]
		[Route(HostRoutes.Save)]
		public Host SaveUser(HostResource host)
		{
			var mappedHost = Mapper.Map<HostResource, Host>(host);
			MakeServiceCall(() => _hostService.Save(mappedHost), string.Format("Save host details By Host name={0}", host.FirmName));
			return mappedHost;
		}
		[HttpPost]
		[Route(HostRoutes.SaveHomePage)]
		public HomePageResource SaveHomePage(HomePageResource resource)
		{
			var mappedHomePage = Mapper.Map<HomePageResource, HostHomePage>(resource);
			var savedHomePage = MakeServiceCall(() => _hostService.SaveHomePage(resource.StagingId, mappedHomePage.Id, mappedHomePage), string.Format("Save hosthomepage  Host name={0}", resource.Id));
			return Mapper.Map<HostHomePage, HomePageResource>(savedHomePage);
		}

		/// <summary>
		/// Upload Entity Document for a given entity
		/// </summary>
		/// <returns></returns>
		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(HostRoutes.HostLogoUpload)]
		public async Task<HttpResponseMessage> HostLogoUpload()
		{
			try
			{
				HostHomePageDocumentResource fileUploadObj = await ProcessMultipartContent();

				var homepageimage = Mapper.Map<HostHomePageDocumentResource, HostHomePageDocument>(fileUploadObj);
				MakeServiceCall(() => _hostService.AddHomePageImageToStaging(homepageimage),
					"Save Host Home Page Image");

				return this.Request.CreateResponse(HttpStatusCode.OK);
			}
			catch (Exception e)
			{
				Logger.Error("Error uploading file", e);

				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.InternalServerError,
					ReasonPhrase = e.Message
				});
			}
		}
		private async Task<HostHomePageDocumentResource> ProcessMultipartContent()
		{
			if (!Request.Content.IsMimeMultipartContent())
			{
				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.UnsupportedMediaType
				});
			}

			var provider = FileUploadHelpers.GetMultipartProvider();
			var result = await Request.Content.ReadAsMultipartAsync(provider);

			var fileUploadObj = FileUploadHelpers.GetFormData<HostHomePageDocumentResource>(result);

			var originalFileName = FileUploadHelpers.GetDeserializedFileName(result.FileData.First());
			var uploadedFileInfo = new FileInfo(result.FileData.First().LocalFileName);
			fileUploadObj.FileName = originalFileName;
			fileUploadObj.file = uploadedFileInfo;
			return fileUploadObj;
		}

		[HttpGet]
		[Route(HostRoutes.NewsMetaData)]
		public object GetNewsfeedMetaData()
		{
			var role = CurrentUser.Claims.First(c => c.Type == ClaimTypes.Role).Value;
			;
			return MakeServiceCall(() => _hostService.GetNewsfeedMetaData(HrMaaxxSecurity.GetEnumFromDbName<RoleTypeEnum>(role).Value, null), "Get meta data for newsfeed", true);
		}
	}


}
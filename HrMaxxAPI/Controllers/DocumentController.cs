using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Mvc;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxxAPI.Code.Helpers;
using HrMaxxAPI.Resources.Common;

namespace HrMaxxAPI.Controllers
{
	public class DocumentController : BaseApiController
	{
		private readonly IDocumentService _documentService;

		public DocumentController(IDocumentService documentService)
		{
			_documentService = documentService;
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.AllowAnonymous]
		[System.Web.Http.Route(HrMaxxRoutes.Document)]
		public HttpResponseMessage GetDocument(Guid documentId)
		{
			FileDto document = MakeServiceCall(() => _documentService.GetDocument(documentId), "Get Document By ID", true);
			var response = new HttpResponseMessage {Content = new StreamContent(new MemoryStream(document.Data))};
			response.Content.Headers.ContentType = new MediaTypeHeaderValue(document.MimeType);
			
			response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
			{
				FileName = document.Filename
			};
			return response;
		}


		/// <summary>
		/// Upload Entity Document for a given entity
		/// </summary>
		/// <returns></returns>
		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(HrMaxxRoutes.DocumentUpload)]
		public async Task<HttpResponseMessage> Upload()
		{
			try
			{
				EntityDocumentResource fileUploadObj = await ProcessMultipartContent();

				var entityDocument = Mapper.Map<EntityDocumentResource, EntityDocumentAttachment>(fileUploadObj);
				DocumentDto document = MakeServiceCall(() => _documentService.AddEntityDocument(entityDocument),
					"Save Entity Document", true);

				return this.Request.CreateResponse(HttpStatusCode.OK, document);
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
		private async Task<EntityDocumentResource> ProcessMultipartContent()
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

			var fileUploadObj = FileUploadHelpers.GetFormData<EntityDocumentResource>(result);

			var originalFileName = FileUploadHelpers.GetDeserializedFileName(result.FileData.First());
			var uploadedFileInfo = new FileInfo(result.FileData.First().LocalFileName);
			fileUploadObj.FileName = originalFileName;
			fileUploadObj.file = uploadedFileInfo;
			return fileUploadObj;
		}

		[System.Web.Http.HttpGet]
		[System.Web.Http.Route(HrMaxxRoutes.DeleteDocument)]
		public HttpResponseMessage DeleteDocument(int entityTypeId, Guid entityId, Guid documentId)
		{
			MakeServiceCall(() => _documentService.DeleteEntityDocument(entityTypeId, entityId, documentId), "delete Entity Document");
			return this.Request.CreateResponse(HttpStatusCode.OK);
		}
	}

}
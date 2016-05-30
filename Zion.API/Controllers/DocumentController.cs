using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.API.Controllers
{
	public class DocumentController : BaseApiController
	{
		private readonly IDocumentService _documentService;

		public DocumentController(IDocumentService documentService)
		{
			_documentService = documentService;
		}

		[HttpGet]
		[Route(HrMaxxRoutes.Document)]
		[AllowAnonymous]
		public HttpResponseMessage GetDocument(Guid documentId)
		{
			FileDto document = MakeServiceCall(() => _documentService.GetDocument(documentId), "Get Document By ID", true);
			var response = new HttpResponseMessage {Content = new StreamContent(new MemoryStream(document.Data))};
			switch (document.DocumentExtension)
			{
				case "jpg":
					response.Content.Headers.ContentType = new MediaTypeHeaderValue("image/jpg");
					break;
				case "png":
					response.Content.Headers.ContentType = new MediaTypeHeaderValue("image/png");
					break;
				case "gif":
					response.Content.Headers.ContentType = new MediaTypeHeaderValue("image/gif");
					break;
				case "pdf":
					response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
					break;
				default:
					response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
					break;
			}
			response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
			{
				FileName = document.Filename
			};
			return response;
		}
	}
}
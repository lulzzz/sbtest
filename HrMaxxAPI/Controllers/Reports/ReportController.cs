using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using Autofac.Features.Metadata;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Controllers.Journals;
using HrMaxxAPI.Resources;
using HrMaxxAPI.Resources.Journals;
using HrMaxxAPI.Resources.Reports;
using RestSharp;

namespace HrMaxxAPI.Controllers.Reports
{
	/// <summary>
	///   HrMaxx Controller is the API for common areas
	/// </summary>
	public class ReportController : BaseApiController
	{
		public readonly IReportService _reportService;
		public readonly IJournalService _journalService;

		public ReportController(IReportService reportService, IJournalService journalService)
		{
			_reportService = reportService;
			_journalService = journalService;
		}
		
		[HttpPost]
		[Route(ReportRoutes.Report)]
		public ReportResponseResource GetReport(ReportRequestResource resource)
		{
			var request = Mapper.Map<ReportRequestResource, ReportRequest>(resource);
			var response = MakeServiceCall(() => _reportService.GetReport(request), string.Format("getting report for request for company={0}", request.CompanyId));
			return Mapper.Map<ReportResponse, ReportResponseResource>(response);

		}

		[HttpPost]
		[Route(ReportRoutes.ReportDocument)]
		public HttpResponseMessage GetReportDocment(ReportRequestResource resource)
		{
			var request = Mapper.Map<ReportRequestResource, ReportRequest>(resource);
			var response = MakeServiceCall(() => _reportService.GetReportDocument(request), string.Format("getting report for request for company={0}", request.CompanyId));
			return Printed(response);

		}
		[HttpPost]
		[Route(ReportRoutes.ExtractDocument)]
		public Extract GetExtractDocment(ReportRequestResource resource)
		{
			var request = Mapper.Map<ReportRequestResource, ReportRequest>(resource);
			return MakeServiceCall(() => _reportService.GetExtractDocument(request), string.Format("getting extract for request", request.ReportName));
			
		}
		private HttpResponseMessage Printed(FileDto document)
		{
			var response = new HttpResponseMessage { Content = new StreamContent(new MemoryStream(document.Data)) };
			
			response.Content.Headers.ContentType = new MediaTypeHeaderValue(document.MimeType);

			response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
			{
				FileName = document.Filename
			};
			return response;
		}

		[HttpPost]
		[Route(ReportRoutes.DownloadReport)]
		public HttpResponseMessage DownloadReport(FileDto document)
		{
			return Printed(document);
		}

		[HttpPost]
		[Route(ReportRoutes.GetDashBoardReport)]
		public DashboardData GetDashboardData(DashboardRequestResource request)
		{
			var dashboardRequest = Mapper.Map<DashboardRequestResource, DashboardRequest>(request);
			if(CurrentUser.Host!=Guid.Empty)
				dashboardRequest.Host = CurrentUser.Host;
			dashboardRequest.Role = CurrentUser.Role;
			return MakeServiceCall(() => _reportService.GetDashboardData(dashboardRequest), "Get Dashboard Data for a Request", true);

		}

		[HttpPost]
		[Route(ReportRoutes.FileTaxes)]
		public MasterExtract FileTaxes(Extract extract)
		{
			return MakeServiceCall(() => _journalService.FileTaxes(extract, CurrentUser.FullName), "File Taxes for " + extract.Report.Description, true);
			
		}
		[HttpGet]
		[Route(ReportRoutes.ExtractList)]
		public List<MasterExtract> ExtractList(string report)
		{
			return MakeServiceCall(() => _reportService.GetExtractList(report), "Extract list for report " + report, true);

		}

		[HttpGet]
		[Route(ReportRoutes.GetSearchResults)]
		public List<SearchResult> GetSearchResults(string criteria)
		{
			return MakeServiceCall(() => _reportService.GetSearchResults(criteria, CurrentUser.Role, CurrentUser.Host, CurrentUser.Company), "Get search results", true);

		}
	}
}
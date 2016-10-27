using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
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

namespace HrMaxxAPI.Controllers.Reports
{
	/// <summary>
	///   HrMaxx Controller is the API for common areas
	/// </summary>
	public class ReportController : BaseApiController
	{
		public readonly IReportService _reportService;
		

		public ReportController(IReportService reportService)
		{
			_reportService = reportService;
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
		public HttpResponseMessage GetExtractDocment(ReportRequestResource resource)
		{
			var request = Mapper.Map<ReportRequestResource, ReportRequest>(resource);
			var response = MakeServiceCall(() => _reportService.GetExtractDocument(request), string.Format("getting extract for request", request.ReportName));
			return Printed(response);

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
		[Route(ReportRoutes.GetDashBoardReport)]
		public DashboardData GetDashboardData(DashboardRequestResource request)
		{
			var dashboardRequest = Mapper.Map<DashboardRequestResource, DashboardRequest>(request);
			if(CurrentUser.Host!=Guid.Empty)
				dashboardRequest.Host = CurrentUser.Host;
			dashboardRequest.Role = CurrentUser.Role;
			return MakeServiceCall(() => _reportService.GetDashboardData(dashboardRequest), "Get Dashboard Data for a Request", true);

		}
	}
}
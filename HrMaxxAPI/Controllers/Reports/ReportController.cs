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
	}
}
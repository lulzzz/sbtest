using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Http;
using System.Xml.Serialization;
using Autofac.Features.Metadata;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using HrMaxxAPI.Code.Filters;
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
		public readonly IReaderService _readerService;
		public readonly IJournalService _journalService;
		public readonly IACHService _achService;
		public readonly IDocumentService _documentService;

		public ReportController(IReportService reportService, IJournalService journalService, IACHService achService, IDocumentService documentService, IReaderService readerService)
		{
			_reportService = reportService;
			_journalService = journalService;
			_achService = achService;
			_documentService = documentService;
			_readerService = readerService;
		}
		
		[HttpPost]
		[Route(ReportRoutes.Report)]
		[DeflateCompression]
		public ReportResponseResource GetReport(ReportRequestResource resource)
		{
			var request = Mapper.Map<ReportRequestResource, ReportRequest>(resource);
			var response = MakeServiceCall(() => _reportService.GetReport(request), string.Format("getting Report for request for company={0} - {1}", request.CompanyId, request.ReportName));
			return Mapper.Map<ReportResponse, ReportResponseResource>(response);

		}

		[HttpPost]
		[Route(ReportRoutes.CPAReport)]
		[DeflateCompression]
		public CPAReport GetCPAReport(ReportRequestResource resource)
		{
			var request = Mapper.Map<ReportRequestResource, ReportRequest>(resource);
			return MakeServiceCall(() => _reportService.GetCPAReport(request), string.Format("getting CPA Report for request for company={0}", request.CompanyId));
			
		}

		[HttpPost]
		[Route(ReportRoutes.ReportDocument)]
		[DeflateCompression]
		public HttpResponseMessage GetReportDocment(ReportRequestResource resource)
		{
			var request = Mapper.Map<ReportRequestResource, ReportRequest>(resource);
			var response = MakeServiceCall(() => _reportService.GetReportDocument(request), string.Format("getting Report document for request for company={0} - {1}", request.CompanyId, request.ReportName));
			return Printed(response);

		}
		[HttpPost]
		[Route(ReportRoutes.ExtractDocumentReport)]
		[DeflateCompression]
		public HttpResponseMessage GetExtractDocmentReport(ReportRequestResource resource)
		{
			var request = Mapper.Map<ReportRequestResource, ReportRequest>(resource);
			var response = MakeServiceCall(() => _reportService.GetExtractDocument(request), string.Format("getting extract document for request for company={0} - {1}", request.CompanyId, request.ReportName));
			return Printed(response.File);

		}

		[HttpPost]
		[Route(ReportRoutes.ExtractDocument)]
		[DeflateCompression]
		public Extract GetExtractDocment(ReportRequestResource resource)
		{
			var request = Mapper.Map<ReportRequestResource, ReportRequest>(resource);
			return MakeServiceCall(() => _reportService.GetExtractDocument(request), string.Format("getting extract for request", request.ReportName));
			
		}

		[HttpPost]
		[Route(ReportRoutes.ACHReport)]
		[DeflateCompression]
		public ACHExtract GetACHReport(ReportRequestResource resource)
		{
			var request = Mapper.Map<ReportRequestResource, ReportRequest>(resource);
			//_achService.FillACH();
			return MakeServiceCall(() => _reportService.GetACHReport(request), string.Format("getting ACH Report"));

		}

		[HttpPost]
		[Route(ReportRoutes.ACHFileAndExtract)]
		public HttpResponseMessage ACHFileAndExtract(ACHExtract data)
		{
			var extract = MakeServiceCall(() => _reportService.GetACHExtract(data, CurrentUser.FullName), string.Format("getting ACH Extract"));
			return Printed(extract.File);

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
		[DeflateCompression]
		public HttpResponseMessage DownloadReport(FileDto document)
		{
			if(document.Data!=null)
				return Printed(document);
			var doc = _documentService.GetDocument(document.DocumentId);
			return Printed(doc);
		}

		[HttpPost]
		[Route(ReportRoutes.DownloadExtract)]
		[DeflateCompression]
		public HttpResponseMessage DownloadExtract(Extract extract)
		{
			var result = MakeServiceCall(() => _reportService.GetExtractTransformedWithFile(extract), string.Format("getting extract file for {0}", extract.Report.ReportName));
			return Printed(result.File);
		}

		[HttpPost]
		[Route(ReportRoutes.PrintExtractBatch)]
		[DeflateCompression]
		public HttpResponseMessage PrintExtractBatch(Extract extract)
		{
			var file = MakeServiceCall(() => _reportService.GetExtractTransformedAndPrinted(extract), string.Format("getting extract transformed and printed"));
			return Printed(file);
		}

		[HttpPost]
		[Route(ReportRoutes.PrintExtractBatchAll)]
		[DeflateCompression]
		public HttpResponseMessage PrintExtractBatchAll(Extract extract)
		{
			var file = MakeServiceCall(() => _reportService.GetExtractTransformedAndPrintedZip(extract), string.Format("getting extract all transformed and printed"));
			return Printed(file);
		}

		[HttpPost]
		[Route(ReportRoutes.GetDashBoardReport)]
		[DeflateCompression]
		public List<DashboardData> GetDashboardData(DashboardRequestResource request)
		{
			var dashboardRequest = Mapper.Map<DashboardRequestResource, DashboardRequest>(request);
			if(CurrentUser.Host!=Guid.Empty)
				dashboardRequest.Host = CurrentUser.Host;
			dashboardRequest.Role = CurrentUser.Role;
			return MakeServiceCall(() => _reportService.GetDashboardData(dashboardRequest), "Get Dashboard Data for a Request " + request.ReportName, true);

		}
		[HttpPost]
		[Route(ReportRoutes.InvoiceStatusList)]
		[DeflateCompression]
		public List<InvoiceStatusListItem> InvoiceStatusList(DashboardRequestResource request)
		{
			var dashboardRequest = Mapper.Map<DashboardRequestResource, DashboardRequest>(request);
			
			dashboardRequest.Role = CurrentUser.Role;
			var filterParams = new List<FilterParam>();
			filterParams.Add(new FilterParam(){Key="startdate", Value = dashboardRequest.StartDate.ToString()});
			filterParams.Add(new FilterParam() { Key = "enddate", Value = dashboardRequest.EndDate.ToString() });
			if (CurrentUser.Host != Guid.Empty)
				filterParams.Add(new FilterParam() { Key = "host", Value = CurrentUser.Host.ToString() });
			filterParams.Add(new FilterParam() { Key = "role", Value = CurrentUser.Role });
			filterParams.Add(new FilterParam() { Key = "criteria", Value = request.Criteria });
			filterParams.Add(new FilterParam() { Key = "onlyActive", Value = request.OnlyActive.ToString() });

			return MakeServiceCall(() => _readerService.GetDataFromStoredProc<List<InvoiceStatusListItem>>("GetInvoiceStatusList", filterParams, new XmlRootAttribute("InvoiceStatusList")), "Get Dashboard Data for a Request " + request.ReportName, true);

		}

		[HttpPost]
		[Route(ReportRoutes.FileTaxes)]
		[DeflateCompression]
		public MasterExtract FileTaxes(Extract extract)
		{
			if (extract.File == null || extract.File.Data == null)
			{
				extract = _reportService.GetExtractTransformedWithFile(extract);
			}
			var returnExtract = MakeServiceCall(() => _journalService.FileTaxes(extract, CurrentUser.FullName), "File Taxes for " + extract.Report.Description, true);
			returnExtract.Extract = null;
			return returnExtract;
		}
		[HttpPost]
		[Route(ReportRoutes.PayCommissions)]
		[DeflateCompression]
		public MasterExtract PayCommissions(CommissionsExtract extract)
		{
			var returnExtract = MakeServiceCall(() => _reportService.PayCommissions(extract, CurrentUser.FullName), extract.Report.Description, true);
			return returnExtract;
		}

		[HttpPost]
		[Route(ReportRoutes.CreateDepositTickets)]
		[DeflateCompression]
		public HttpStatusCode CreateDepositTickets(ReportRequestResource resource)
		{
			var request = Mapper.Map<ReportRequestResource, ReportRequest>(resource);
			request.AllowExclude = true;
			var extract = MakeServiceCall(() => _reportService.GetExtractDocument(request), string.Format("getting extract for request{0}", request.ReportName));
			MakeServiceCall(() => _journalService.CreateDepositTickets(extract, CurrentUser.FullName, CurrentUser.UserId), string.Format("creating deposit tickets for {0}-{1}-{2}", request.ReportName, request.StartDate, request.EndDate));
			return HttpStatusCode.OK;
		}

		[HttpPost]
		[Route(ReportRoutes.PrintChecks)]
		[DeflateCompression]
		public HttpResponseMessage PrintExtractChecks(ExtractPrintResource resource)
		{
			var returnExtract = MakeServiceCall(() => _journalService.PrintChecks(resource.Journals, resource.Report), "Print Checks for extract" , true);
			return Printed(returnExtract);
		}

		[HttpGet]
		[Route(ReportRoutes.ExtractList)]
		[DeflateCompression]
		public List<MasterExtract> ExtractList(string report)
		{
			return MakeServiceCall(() => _reportService.GetExtractList(report), "Extract list for Report " + report, true);

		}

		[HttpGet]
		[Route(ReportRoutes.DeleteExtract)]
		public void DeleteExtract(int extractId)
		{
			MakeServiceCall(() => _reportService.DeleteExtract(extractId), "delete extract id " + extractId);

		}
		[HttpPost]
		[Route(ReportRoutes.ConfirmExtract)]
		public MasterExtract ConfirmExtract(MasterExtract extract)
		{
			extract.ConfirmationNoUser = CurrentUser.FullName;
			extract.ConfirmationNoTS = DateTime.Now;
			return MakeServiceCall(() => _reportService.ConfirmExtract(extract), "confirm extract id " + extract.Id, true);

		}

		[HttpGet]
		[Route(ReportRoutes.Extract)]
		[DeflateCompression]
		public MasterExtract Extract(int id)
		{
			return MakeServiceCall(() => _reportService.GetExtract(id), "Extract with id " + id, true);

		}
		[HttpGet]
		[Route(ReportRoutes.CommissionExtract)]
		[DeflateCompression]
		public CommissionsExtract CommissionsExtract(int id)
		{
			var extr = MakeServiceCall(() => _reportService.GetCommissionsExtract(id), "Commissions Extract with id " + id, true);
			return extr;
		}
		[HttpGet]
		[Route(ReportRoutes.ACHExtract)]
		[DeflateCompression]
		public ACHMasterExtract ACHExtract(int id)
		{
			return MakeServiceCall(() => _reportService.GetAchReportExtract(id), "Extract with id " + id, true);

		}

		

		[HttpPost]
		[Route(ReportRoutes.GetSearchResults)]
		[DeflateCompression]
		public List<SearchResult> GetSearchResults(SearchRequest request)
		{
			return MakeServiceCall(() => _reportService.GetSearchResults(request.Criteria, CurrentUser.Role, CurrentUser.Host, CurrentUser.Company), "Get search results", true);

		}

		[HttpPost]
		[Route(ReportRoutes.CommissionsReport)]
		[DeflateCompression]
		public CommissionsExtract GetCommissionsReport(CommissionsReportRequestResource resource)
		{
			var request = Mapper.Map<CommissionsReportRequestResource, CommissionsReportRequest>(resource);
			return MakeServiceCall(() => _reportService.GetCommissionsReport(request), string.Format("getting commissions report for request"));

		}

		[HttpPost]
		[Route(ReportRoutes.MinWageEligibilityReport)]
		[DeflateCompression]
		public List<MinWageEligibileCompany> GetCommissionsReport(MinWageEligibilityCriteria criteria)
		{
			
			return MakeServiceCall(() => _reportService.GetMinWageEligibilityReport(criteria), string.Format("getting min wage eligibility report for request"));

		}

		[HttpGet]
		[Route(ReportRoutes.ProfitStarsPayrollList)]
		public List<ProfitStarsPayroll> ProfitStarsPayrollList()
		{
			var data = MakeServiceCall(() => _achService.GetProfitStarsPayrollList(), "Profit Stars Payroll List ", true);
			return data;

		}
		[HttpGet]
		[Route(ReportRoutes.MarkFundingSuccessful)]
		public List<ProfitStarsPayroll> MarkFundingSuccessful(int fundRequestId)
		{
			var data = MakeServiceCall(() => _achService.MarkFundingSuccessful(fundRequestId), "Profit Stars funding manual settle ", true);
			return data;

		}
		[HttpGet]
		[Route(ReportRoutes.ProfitStars1pm)]
		public List<ProfitStarsPayment> ProfitStars1pm()
		{
			return MakeServiceCall(() => _achService.ProfitStarsPayments(), "Profit Stars 1pm  ", true);
		}

		[HttpGet]
		[Route(ReportRoutes.ProfitStars9am)]
		public ProfitStarsReportResponse ProfitStars9am()
		{
			return MakeServiceCall(() => _achService.ProfitStarsStatusUpdate(), "Profit Stars 1pm  ", true);
		}

		[HttpGet]
		[Route(ReportRoutes.CompanyDashboard)]
		public CompanyDashboard CompanyDashboard(Guid id)
		{
			return MakeServiceCall(() => _reportService.GetCompanyDashboard(id), "company dashboard  ", true);
		}
		[HttpGet]
		[Route(ReportRoutes.EmployeeDashboard)]
		public CompanyDashboard EmployeeDashboard(Guid companyId, Guid employeeId)
		{
			return MakeServiceCall(() => _reportService.GetEmployeeDashboard(companyId, employeeId), "employee dashboard  ", true);
		}
		[HttpGet]
		[Route(ReportRoutes.ExtractDashboard)]
		public CompanyDashboard ExtractDashboard()
		{
			return MakeServiceCall(() => _reportService.GetExtractDashboard(), "extract dashboard  ", true);
		}
		[HttpGet]
		[Route(ReportRoutes.StaffDashboard)]
		public StaffDashboard StaffDashboard(Guid? hostId = null)
		{
			return MakeServiceCall(() => _reportService.GetStaffDashboard(hostId), "staff dashboard  ", true);
		}
		[HttpGet]
		[Route(ReportRoutes.StaffDashboardDocuments)]
		public EmployeeDocumentMetaData StaffDashboardDocuments(Guid? hostId = null)
		{
			return MakeServiceCall(() => _reportService.GetStaffDashboardDocuments(hostId), "staff dashboard doicuments ", true);
		}

	}
}
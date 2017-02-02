using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Reflection;
using System.Resources;
using System.Runtime.Remoting.Messaging;
using System.Threading.Tasks;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxxAPI.Code.Filters;
using HrMaxxAPI.Code.Helpers;
using HrMaxxAPI.Controllers.Companies;
using HrMaxxAPI.Resources.OnlinePayroll;
using HrMaxxAPI.Resources.Payroll;

namespace HrMaxxAPI.Controllers.Payrolls
{
	public class PayrollController : BaseApiController
	{
		private readonly IPayrollService _payrollService;
		private readonly IDocumentService _documentService;
		private readonly IDashboardService _dashboardService;
		private readonly ITaxationService _taxationService;
		private readonly ICompanyService _companyService;
		private readonly IExcelService _excelService;
		private readonly IReaderService _readerService;
		
		public PayrollController(IPayrollService payrollService, IDocumentService documentService, IDashboardService dashboardService, ITaxationService taxationService, ICompanyService companyService, IExcelService excelService, IReaderService readerService)
		{
			_payrollService = payrollService;
			_documentService = documentService;
			_dashboardService = dashboardService;
			_taxationService = taxationService;
			_companyService = companyService;
			_excelService = excelService;
			_readerService = readerService;
		}
		

		[HttpGet]
		[Route(PayrollRoutes.FixCompanyCubes)]
		public HttpStatusCode FixCompanyCubes(int year)
		{
			try
			{
				var companies = _readerService.GetCompanies(); //_companyService.GetAllCompanies();
				companies.ForEach(c =>
				{
					var payrolls = _readerService.GetPayrolls(c.Id, new DateTime(year, 1, 1).Date,
					new DateTime(year, 12, 31));
					if (payrolls.Any())
					{
						_dashboardService.FixCompanyCubes(payrolls, c.Id, year);
					}
				});
				return HttpStatusCode.OK;
			}
			catch (Exception)
			{

				return HttpStatusCode.ExpectationFailed;
			}
		}
		[HttpGet]
		[Route(PayrollRoutes.FixInvoices)]
		public List<Guid> FixInvoiceData()
		{
			try
			{
				return _payrollService.FixInvoiceData();
				
			}
			catch (Exception e)
			{

				throw e;
			}
		}

		[HttpGet]
		[Route(PayrollRoutes.FixPayrollDataForCompany)]
		public HttpStatusCode FixPayrollData(Guid companyId)
		{
			var done = MakeServiceCall(() => _payrollService.FixPayrollData(companyId), "Fix payroll data for company id =" + companyId, true);
			if (done != null)
				return HttpStatusCode.OK;
			return HttpStatusCode.ExpectationFailed;
		}
		[HttpGet]
		[Route(PayrollRoutes.FixPayrollData)]
		public HttpStatusCode FixPayrollData()
		{
			var done = MakeServiceCall(() => _payrollService.FixPayrollData(null), "Fix payroll data for all companies", true);
			if (done != null)
				return HttpStatusCode.OK;
			return HttpStatusCode.ExpectationFailed;
		}


		[HttpPost]
		[Route(PayrollRoutes.Print)]
		[DeflateCompression]
		public HttpResponseMessage GetDocument(PayrollPrintRequest request)
		{
			if (_documentService.DocumentExists(request.DocumentId))
			{
				try
				{
					var document = MakeServiceCall(() => _documentService.GetDocument(request.DocumentId), "Get Document By ID",
						true);
					return Printed(document);
				}
				catch (Exception e)
				{
					
				}
			}
			
			var printedCheck = MakeServiceCall(() => _payrollService.PrintPayCheck(request.PayCheckId), "print check by payroll id and check id", true);
			return Printed(printedCheck);	
			
			
		}

		[HttpPost]
		[Route(PayrollRoutes.PrintPayrollReport)]
		[DeflateCompression]
		public HttpResponseMessage PrintPayrollReport(PayrollResource payroll)
		{
			var mapped = Mapper.Map<PayrollResource, Payroll>(payroll);
			var printed = MakeServiceCall(() => _payrollService.PrintPayrollReport(mapped), "print all check for payroll with id " + mapped.Id, true);
			return Printed(printed);
		}
		[HttpPost]
		[Route(PayrollRoutes.PrintPayrollTimesheet)]
		[DeflateCompression]
		public HttpResponseMessage PrintPayrollTimesheet(PayrollResource payroll)
		{
			var mapped = Mapper.Map<PayrollResource, Payroll>(payroll);
			var printed = MakeServiceCall(() => _payrollService.PrintPayrollTimesheet(mapped), "print payroll timesheet", true);
			return Printed(printed);
		}

		[HttpPost]
		[Route(PayrollRoutes.PrintPayrollChecks)]
		[DeflateCompression]
		public HttpResponseMessage PrintPayrollChecks(PayrollResource payroll)
		{
			var mapped = Mapper.Map<PayrollResource, Payroll>(payroll);
			
			var printed = MakeServiceCall(() => _payrollService.PrintPayrollChecks(mapped), "print all check for payroll with id " + mapped.Id, true);
			return Printed(printed);
		}

		[HttpGet]
		[Route(PayrollRoutes.MarkPayCheckPrinted)]
		public void MarkPayCheckPrinted(int payCheckId)
		{
			MakeServiceCall(() => _payrollService.MarkPayCheckPrinted(payCheckId), "mark paycheck printed");
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
		[Route(PayrollRoutes.Payrolls)]
		[DeflateCompression]
		public List<PayrollResource> GetPayrolls(PayrollFilterResource filter)
		{
			var payrolls = MakeServiceCall(() => _readerService.GetPayrolls(filter.CompanyId, filter.StartDate, filter.EndDate, true), string.Format("get list of payrolls for company={0}", filter.CompanyId));
			return Mapper.Map<List<Payroll>, List<PayrollResource>>(payrolls);
		}

		[HttpGet]
		[Route(PayrollRoutes.UnPrintedPayrolls)]
		[DeflateCompression]
		public List<PayrollResource> GetUnPrintedPayrolls()
		{
			var payrolls = MakeServiceCall(() => _readerService.GetPayrolls(null, status:(int)PayrollStatus.Committed, excludeVoids:1), string.Format("get list of un printed payrolls "));
			return Mapper.Map<List<Payroll>, List<PayrollResource>>(payrolls);
		}

		[HttpPost]
		[Route(PayrollRoutes.UpdatePayrollDates)]
		[DeflateCompression]
		public HttpStatusCode UpdatePayrollDates(PayrollResource resource)
		{
			resource.PayChecks.ForEach(p =>
			{
				p.StartDate = resource.StartDate;
				p.EndDate = resource.EndDate;
				p.PayDay = resource.PayDay;
			});
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);

			MakeServiceCall(() => _payrollService.UpdatePayrollDates(mappedResource), string.Format("update payroll dates for id={0}", resource.Id));
			return HttpStatusCode.OK;
		}

		[HttpPost]
		[Route(PayrollRoutes.ProcessPayroll)]
		[DeflateCompression]
		public PayrollResource ProcessPayroll(PayrollResource resource)
		{
			resource.PayChecks.ForEach(p =>
			{
				p.StartDate = resource.StartDate;
				p.EndDate = resource.EndDate;
				p.PayDay = resource.PayDay;
			});
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			
			var processed = MakeServiceCall(() => _payrollService.ProcessPayroll(mappedResource), string.Format("process payrolls for company={0}", resource.Company.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}

		[HttpPost]
		[Route(PayrollRoutes.CommitPayroll)]
		[DeflateCompression]
		public PayrollResource CommitPayroll(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			mappedResource.PayChecks.ForEach(p =>
			{
				p.PayrollId = mappedResource.Id;
				p.LastModified = DateTime.Now;
				p.LastModifiedBy = CurrentUser.FullName;
			});
			var processed = MakeServiceCall(() => _payrollService.ConfirmPayroll(mappedResource), string.Format("commit payrolls for company={0}", resource.Company.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}
		[HttpPost]
		[Route(PayrollRoutes.SaveProcessedPayroll)]
		[DeflateCompression]
		public PayrollResource SaveProcessedPayroll(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			mappedResource.PayChecks.ForEach(p =>
			{
				p.PayrollId = mappedResource.Id;
				p.LastModified = DateTime.Now;
				p.LastModifiedBy = CurrentUser.FullName;
			});
			var processed = MakeServiceCall(() => _payrollService.SaveProcessedPayroll(mappedResource), string.Format("save payroll to staging for company={0}", resource.Company.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}

		[HttpPost]
		[Route(PayrollRoutes.DeletePayroll)]
		public PayrollResource DeletePayroll(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			if(mappedResource.Status!=PayrollStatus.Draft)
				throw new Exception("Only draft payrolls can be deleted from the system");
			var processed = MakeServiceCall(() => _payrollService.DeletePayroll(mappedResource), string.Format("delete draft payroll from staging for company={0}", resource.Company.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}


		[HttpPost]
		[Route(PayrollRoutes.VoidPayroll)]
		[DeflateCompression]
		public PayrollResource VoidPayroll(PayrollResource resource)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(resource);
			var processed = MakeServiceCall(() => _payrollService.VoidPayroll(mappedResource, CurrentUser.FullName, CurrentUser.UserId), string.Format("Void all pay checks and invocie for Payroll={0}", resource.Id));
			return Mapper.Map<Payroll, PayrollResource>(processed);
		}

		[HttpGet]
		[Route(PayrollRoutes.VoidPayCheck)]
		[DeflateCompression]
		public PayrollResource CommitPayroll(Guid payrollId, int payCheckId)
		{
			var voided = MakeServiceCall(() => _payrollService.VoidPayCheck(payrollId, payCheckId, CurrentUser.FullName, CurrentUser.UserId), string.Format("void paycheck in payroll={0} with id={1}",payrollId, payCheckId));
			return Mapper.Map<Payroll, PayrollResource>(voided);
		}

		[HttpGet]
		[Route(PayrollRoutes.PayCheck)]
		[DeflateCompression]
		public PayCheckResource GetPayCheck(int checkId)
		{
			var check = MakeServiceCall(() => _readerService.GetPaycheck(checkId), string.Format("get paycheck with id={0}", checkId));
			return Mapper.Map<PayCheck, PayCheckResource>(check);
		}

		
		[HttpGet]
		[Route(PayrollRoutes.GetInvoicePayroll)]
		[DeflateCompression]
		public List<PayrollResource> GetInvoicePayroll(Guid invoiceId)
		{
			var payrolls = MakeServiceCall(() => _readerService.GetPayrolls(null, invoiceId:invoiceId), string.Format("get payrolls for invoice with id={0}", invoiceId));
			return Mapper.Map<List<Payroll>, List<PayrollResource>>(payrolls);
		}
		[HttpGet]
		[Route(PayrollRoutes.PrintPayCheck)]
		[DeflateCompression]
		public FileDto PrintPayCheck(Guid payrollId, int checkId)
		{
			return MakeServiceCall(() => _payrollService.PrintPayCheck(checkId), string.Format("print paycheck with id={0}", checkId), true);
			
		}

		[HttpPost]
		[Route(PayrollRoutes.CreatePayrollInvoice)]
		[DeflateCompression]
		public PayrollInvoiceResource CreatePayrollInvoice(PayrollResource payroll)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(payroll);
			var processed = MakeServiceCall(() => _payrollService.CreatePayrollInvoice(mappedResource, CurrentUser.FullName, new Guid(CurrentUser.UserId), true), string.Format("create payroll invoice for payroll={0}", payroll.Id));
			var returnInvocie = Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(processed);
			returnInvocie.TaxPaneltyConfig = _taxationService.GetApplicationConfig().InvoiceLateFeeConfigs;
			return returnInvocie;
		}

		[HttpPost]
		[Route(PayrollRoutes.PayrollInvoice)]
		[DeflateCompression]
		public PayrollInvoiceResource SavePayrollInvoice(PayrollInvoiceResource invoice)
		{
			var mappedResource = Mapper.Map<PayrollInvoiceResource, PayrollInvoice>(invoice);
			mappedResource.LastModified = DateTime.Now;
			mappedResource.UserName = CurrentUser.FullName;
			mappedResource.InvoicePayments.Where(ip=>ip.HasChanged).ToList().ForEach(ip =>
			{
				ip.LastModifiedBy = CurrentUser.FullName;
				ip.LastModified = mappedResource.LastModified;

			});

			var processed = MakeServiceCall(() => _payrollService.SavePayrollInvoice(mappedResource), string.Format("save payroll invoice for invoice={0}", invoice.Id));
			var returnInvocie = Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(processed);
			returnInvocie.TaxPaneltyConfig = _taxationService.GetApplicationConfig().InvoiceLateFeeConfigs;
			return returnInvocie;
		}

		[HttpPost]
		[Route(PayrollRoutes.PayrollInvoices)]
		[DeflateCompression]
		public List<PayrollInvoiceResource> GetPayrollInvoices(PayrollInvoiceFilterResource resource)
		{
			
			var invoices = MakeServiceCall(() => _readerService.GetPayrollInvoices(CurrentUser.Host, companyId: resource.CompanyId, status: resource.Status, startDate: resource.StartDate, endDate: resource.EndDate), string.Format("get invoices for host with id={0}", CurrentUser.Host));
			if (CurrentUser.Role == RoleTypeEnum.HostStaff.GetDbName() || CurrentUser.Role == RoleTypeEnum.Host.GetDbName())
			{
				invoices = invoices.Where(i => !i.Company.IsHostCompany && i.Company.IsVisibleToHost).ToList();
			}
			var appConfig = _taxationService.GetApplicationConfig();
			if (CurrentUser.Role == RoleTypeEnum.CorpStaff.GetDbName() && appConfig.RootHostId.HasValue)
			{
				invoices = invoices.Where(i => !(i.Company.HostId == appConfig.RootHostId && i.Company.IsHostCompany)).ToList();
			}
			var result = Mapper.Map<List<PayrollInvoice>, List<PayrollInvoiceResource>>(invoices);
			var ic = _taxationService.GetApplicationConfig().InvoiceLateFeeConfigs;
			result.ForEach(i => i.TaxPaneltyConfig = ic);
			return result;
		}

		[HttpGet]
		[Route(PayrollRoutes.ApprovedInvoices)]
		[DeflateCompression]
		public List<PayrollInvoiceResource> GetApprovedInvoices()
		{
			var invoices = MakeServiceCall(() => _readerService.GetPayrollInvoices(CurrentUser.Host, status: new List<InvoiceStatus>(){InvoiceStatus.Submitted}), string.Format("get invoices for host with id={0}", CurrentUser.Host));
			var result = Mapper.Map<List<PayrollInvoice>, List<PayrollInvoiceResource>>(invoices);
			var ic = _taxationService.GetApplicationConfig().InvoiceLateFeeConfigs;
			result.ForEach(i => i.TaxPaneltyConfig = ic);
			return result;
		}
		[HttpGet]
		[Route(PayrollRoutes.DeletePayrollInvoice)]
		public void DeletePayrollInvoice(Guid invoiceId)
		{
			MakeServiceCall(() => _payrollService.DeletePayrollInvoice(invoiceId), string.Format("delete invoice with id={0}", invoiceId));
			
		}
		[HttpGet]
		[Route(PayrollRoutes.GetInvoiceById)]
		public PayrollInvoiceResource GetInvoiceById(Guid invoiceId)
		{
			var invoice = MakeServiceCall(() => _readerService.GetPayrollInvoice(invoiceId), string.Format("get invoice with id={0}", invoiceId));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(invoice);

		}
		[HttpGet]
		[Route(PayrollRoutes.RecreateInvoice)]
		[DeflateCompression]
		public PayrollInvoiceResource RecreateInvoice(Guid invoiceId)
		{
			var invoice = MakeServiceCall(() => _payrollService.RecreateInvoice(invoiceId, CurrentUser.FullName, new Guid(CurrentUser.UserId)), string.Format("recreate invoice with id={0}", invoiceId));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(invoice);
		}

		[HttpGet]
		[Route(PayrollRoutes.DelayTaxes)]
		[DeflateCompression]
		public PayrollInvoiceResource DelayTaxes(Guid invoiceId)
		{
			var invoice = MakeServiceCall(() => _payrollService.DelayTaxes(invoiceId, CurrentUser.FullName), string.Format("delay taxes on invoice with id={0}", invoiceId));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(invoice);
		}
		[HttpPost]
		[Route(PayrollRoutes.RedateInvoice)]
		[DeflateCompression]
		public PayrollInvoiceResource RedateInvoice(PayrollInvoiceResource resource)
		{
			var mapped = Mapper.Map<PayrollInvoiceResource, PayrollInvoice>(resource);
			mapped.UserName = CurrentUser.FullName;
			var invoice = MakeServiceCall(() => _payrollService.RedateInvoice(mapped), string.Format("redate invoice with id={0}", mapped.Id));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(invoice);
		}

		[HttpPost]
		[Route(PayrollRoutes.ClaimDelivery)]
		[DeflateCompression]
		public InvoiceDeliveryClaim ClaimDelivery(List<Guid> invoiceIds)
		{
			return MakeServiceCall(() => _payrollService.ClaimDelivery(invoiceIds, CurrentUser.FullName, new Guid(CurrentUser.UserId)), string.Format("claim delivery of invoices with ids={0}", invoiceIds));
			
		}

		[HttpGet]
		[Route(PayrollRoutes.InvoiceDeliveryClaims)]
		[DeflateCompression]
		public List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims()
		{
			return MakeServiceCall(() => _payrollService.GetInvoiceDeliveryClaims(), "Get Invoice Delivery Claims");
		}

		[HttpGet]
		[Route(PayrollRoutes.EmployeeChecks)]
		[DeflateCompression]
		public List<PayCheck> GetEmployeeChecks(Guid companyId, Guid employeeId)
		{
			return MakeServiceCall(() => _readerService.GetPayChecks(companyId:companyId, employeeId:employeeId, isvoid:0), "Get Pay Check for employee");
		}
		
		[HttpPost]
		[Route(PayrollRoutes.ImportTimesheetsTemplate)]
		public HttpResponseMessage GetTimesheetImportTemplate(TimesheetImportResource resource)
		{

			var printed = MakeServiceCall(() => _excelService.GetTimesheetImportTemplate(resource.CompanyId, resource.PayTypes.Select(p=>p.Name).ToList()), "get timesheet import template for " + resource.CompanyId, true);
			var response = new HttpResponseMessage { Content = new StreamContent(new MemoryStream(printed.Data)) };
			response.Content.Headers.ContentType = new MediaTypeHeaderValue(printed.MimeType);

			response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
			{
				FileName = printed.Filename
			};
			return response;
		}
		/// <summary>
		/// Upload Entity Document for a given entity
		/// </summary>
		/// <returns></returns>
		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(PayrollRoutes.ImportTimesheets)]
		[DeflateCompression]
		public async Task<HttpResponseMessage> ImportTimesheets()
		{
			var filename = string.Empty;
			try
			{
				var fileUploadObj = await ProcessMultipartContent();
				filename = fileUploadObj.file.FullName;
				var company = Mapper.Map<Company, CompanyResource>(_readerService.GetCompany(fileUploadObj.CompanyId));
				var importedRows = _excelService.ImportFromExcel(fileUploadObj.file, 2);
				var timesheets = new List<TimesheetResource>();
				var error = string.Empty;
				company.PayCodes.Add(new CompanyPayCodeResource
				{
					Code = "Default", Description = "Base Rate", CompanyId = company.Id.Value, Id=0, HourlyRate = 0
				});
				importedRows.ForEach(er =>
				{
					try
					{
						var timesheet = new TimesheetResource();
						timesheet.FillFromImport(er, company, fileUploadObj.PayTypes);
						timesheets.Add(timesheet);
					}
					catch (Exception ex)
					{
						error += ex.Message + "<br>";
					}
				});
				if (!string.IsNullOrWhiteSpace(error))
					throw new Exception(error);
				
				return this.Request.CreateResponse(HttpStatusCode.OK, timesheets);
			}
			catch (Exception e)
			{
				Logger.Error("Error importing timesheets", e);

				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.InternalServerError,
					ReasonPhrase = e.Message
				});
			}
			finally
			{
				if (!string.IsNullOrWhiteSpace(filename))
					File.Delete(filename);
			}
		}

		/// <summary>
		/// Upload Entity Document for a given entity
		/// </summary>
		/// <returns></returns>
		[System.Web.Http.HttpPost]
		[System.Web.Http.Route(PayrollRoutes.ImportTimesheetsWithMap)]
		[DeflateCompression]
		public async Task<HttpResponseMessage> ImportTimesheetsWithMap()
		{
			var filename = string.Empty;
			try
			{
				var fileUploadObj = await ProcessMultipartContentWithMap();
				filename = fileUploadObj.file.FullName;
				var company = Mapper.Map<Company, CompanyResource>(_readerService.GetCompany(fileUploadObj.CompanyId));
				var importedRows = _excelService.ImportWithMap(fileUploadObj.file, fileUploadObj.ImportMap, fileUploadObj.FileName);
				var timesheets = new List<TimesheetResource>();
				var error = string.Empty;
				company.PayCodes.Add(new CompanyPayCodeResource
				{
					Code = "Default",
					Description = "Base Rate",
					CompanyId = company.Id.Value,
					Id = 0,
					HourlyRate = 0
				});
				company.PayCodes.Add(new CompanyPayCodeResource
				{
					Code = "PieceRate",
					Description = "Piece-Rate",
					CompanyId = company.Id.Value,
					Id = -1,
					HourlyRate = 0
				});
				importedRows.ForEach(er =>
				{
					try
					{
						var timesheet = new TimesheetResource();
						timesheet.FillFromImportWithMap(er, company, fileUploadObj.PayTypes, fileUploadObj.ImportMap);
						timesheets.Add(timesheet);
					}
					catch (Exception ex)
					{
						error += ex.Message + "<br>";
					}
				});
				if (!string.IsNullOrWhiteSpace(error))
					throw new Exception(error);
				_companyService.SaveTSImportMap(company.Id.Value, fileUploadObj.ImportMap);
				return this.Request.CreateResponse(HttpStatusCode.OK, timesheets);
			}
			catch (Exception e)
			{
				Logger.Error("Error importing timesheets", e);

				throw new HttpResponseException(new HttpResponseMessage
				{
					StatusCode = HttpStatusCode.InternalServerError,
					ReasonPhrase = e.Message
				});
			}
			finally
			{
				if (!string.IsNullOrWhiteSpace(filename))
					File.Delete(filename);
			}
		}

		private async Task<TimesheetImportResource> ProcessMultipartContent()
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

			var fileUploadObj = FileUploadHelpers.GetFormData<TimesheetImportResource>(result);

			var originalFileName = FileUploadHelpers.GetDeserializedFileName(result.FileData.First());
			var uploadedFileInfo = new FileInfo(result.FileData.First().LocalFileName);
			fileUploadObj.FileName = originalFileName;
			fileUploadObj.file = uploadedFileInfo;
			return fileUploadObj;
		}
		private async Task<TimesheetImportWithMapResource> ProcessMultipartContentWithMap()
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

			var fileUploadObj = FileUploadHelpers.GetFormData<TimesheetImportWithMapResource>(result);

			var originalFileName = FileUploadHelpers.GetDeserializedFileName(result.FileData.First());
			var uploadedFileInfo = new FileInfo(result.FileData.First().LocalFileName);
			fileUploadObj.FileName = originalFileName;
			fileUploadObj.file = uploadedFileInfo;
			return fileUploadObj;
		}

	}


}
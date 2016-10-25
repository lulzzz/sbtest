﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
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
		
		public PayrollController(IPayrollService payrollService, IDocumentService documentService, IDashboardService dashboardService, ITaxationService taxationService, ICompanyService companyService, IExcelService excelService)
		{
			_payrollService = payrollService;
			_documentService = documentService;
			_dashboardService = dashboardService;
			_taxationService = taxationService;
			_companyService = companyService;
			_excelService = excelService;
		}

		[HttpGet]
		[Route(PayrollRoutes.FixCompanyCubes)]
		public HttpStatusCode FixCompanyCubes(Guid companyId, int year)
		{
			var payrolls = _payrollService.GetCompanyPayrolls(companyId, new DateTime(year, 1, 1).Date,
				new DateTime(year, 12, 31));
			var done = MakeServiceCall(() => _dashboardService.FixCompanyCubes(payrolls, companyId, year), "Fix cubes for company", true);
			if (done!=null)
				return HttpStatusCode.OK;
			return HttpStatusCode.ExpectationFailed;
		}

		[HttpGet]
		[Route(PayrollRoutes.FixPayrollData)]
		public HttpStatusCode FixPayrollData()
		{
			var done = MakeServiceCall(() => _payrollService.FixPayrollData(), "Fix payroll data", true);
			if (done != null)
				return HttpStatusCode.OK;
			return HttpStatusCode.ExpectationFailed;
		}


		[HttpPost]
		[Route(PayrollRoutes.Print)]
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
		[Route(PayrollRoutes.PrintPayroll)]
		public HttpResponseMessage GetDocument(PayrollResource payroll)
		{
			var mapped = Mapper.Map<PayrollResource, Payroll>(payroll);
			var printed = MakeServiceCall(() => _payrollService.PrintPayroll(mapped), "print all check for payroll with id " + mapped.Id, true);
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
		public List<PayrollResource> GetPayrolls(PayrollFilterResource filter)
		{
			var payrolls = MakeServiceCall(() => _payrollService.GetCompanyPayrolls(filter.CompanyId, filter.StartDate, filter.EndDate), string.Format("get list of payrolls for company={0}", filter.CompanyId));
			return Mapper.Map<List<Payroll>, List<PayrollResource>>(payrolls);
		}

		[HttpPost]
		[Route(PayrollRoutes.ProcessPayroll)]
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

		[HttpGet]
		[Route(PayrollRoutes.VoidPayCheck)]
		public PayrollResource CommitPayroll(Guid payrollId, int payCheckId)
		{
			var voided = MakeServiceCall(() => _payrollService.VoidPayCheck(payrollId, payCheckId, CurrentUser.FullName, CurrentUser.UserId), string.Format("void paycheck in payroll={0} with id={1}",payrollId, payCheckId));
			return Mapper.Map<Payroll, PayrollResource>(voided);
		}

		[HttpGet]
		[Route(PayrollRoutes.PayCheck)]
		public PayCheckResource GetPayCheck(int checkId)
		{
			var check = MakeServiceCall(() => _payrollService.GetPayCheck(checkId), string.Format("get paycheck with id={0}", checkId));
			return Mapper.Map<PayCheck, PayCheckResource>(check);
		}

		[HttpGet]
		[Route(PayrollRoutes.Invoices)]
		public List<InvoiceResource> GetCompanyInvoices(Guid companyId)
		{
			var invoices = MakeServiceCall(() => _payrollService.GetCompanyInvoices(companyId), string.Format("get invoices for company with id={0}", companyId));
			return Mapper.Map<List<Invoice>, List<InvoiceResource>>(invoices);
		}

		[HttpPost]
		[Route(PayrollRoutes.SaveInvoice)]
		public InvoiceResource SaveInvoice(InvoiceResource resource)
		{
			resource.Payments.ForEach(p =>
			{
				if (p.HasChanged)
				{
					p.LastModified = DateTime.Now;
					p.LastModifiedBy = CurrentUser.FullName;
				}
				
			});
			var mappedResource = Mapper.Map<InvoiceResource, Invoice>(resource);
			
			var processed = MakeServiceCall(() => _payrollService.SaveInvoice(mappedResource), string.Format("save invoice for company={0}", resource.CompanyId));
			return Mapper.Map<Invoice, InvoiceResource>(processed);
		}

		[HttpGet]
		[Route(PayrollRoutes.GetInvoice)]
		public InvoiceResource GetInvoice(Guid invoiceId)
		{
			var invoices = MakeServiceCall(() => _payrollService.GetInvoiceById(invoiceId), string.Format("get invoice with id={0}", invoiceId));
			return Mapper.Map<Invoice, InvoiceResource>(invoices);
		}
		[HttpGet]
		[Route(PayrollRoutes.GetInvoicePayroll)]
		public List<PayrollResource> GetInvoicePayroll(Guid invoiceId)
		{
			var payrolls = MakeServiceCall(() => _payrollService.GetInvoicePayrolls(invoiceId), string.Format("get payrolls for invoice with id={0}", invoiceId));
			return Mapper.Map<List<Payroll>, List<PayrollResource>>(payrolls);
		}
		[HttpGet]
		[Route(PayrollRoutes.PrintPayCheck)]
		public FileDto PrintPayCheck(Guid payrollId, int checkId)
		{
			return MakeServiceCall(() => _payrollService.PrintPayCheck(checkId), string.Format("print paycheck with id={0}", checkId), true);
			
		}

		[HttpPost]
		[Route(PayrollRoutes.CreatePayrollInvoice)]
		public PayrollInvoiceResource CreatePayrollInvoice(PayrollResource payroll)
		{
			var mappedResource = Mapper.Map<PayrollResource, Payroll>(payroll);
			var processed = MakeServiceCall(() => _payrollService.CreatePayrollInvoice(mappedResource, CurrentUser.FullName, true), string.Format("create payroll invoice for payroll={0}", payroll.Id));
			var returnInvocie = Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(processed);
			returnInvocie.TaxPaneltyConfig = _taxationService.GetApplicationConfig().InvoiceLateFeeConfigs;
			return returnInvocie;
		}

		[HttpPost]
		[Route(PayrollRoutes.PayrollInvoice)]
		public PayrollInvoiceResource SavePayrollInvoice(PayrollInvoiceResource invoice)
		{
			var mappedResource = Mapper.Map<PayrollInvoiceResource, PayrollInvoice>(invoice);
			mappedResource.LastModified = DateTime.Now;
			mappedResource.UserName = CurrentUser.FullName;

			var processed = MakeServiceCall(() => _payrollService.SavePayrollInvoice(mappedResource), string.Format("save payroll invoice for invoice={0}", invoice.Id));
			var returnInvocie = Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(processed);
			returnInvocie.TaxPaneltyConfig = _taxationService.GetApplicationConfig().InvoiceLateFeeConfigs;
			return returnInvocie;
		}

		[HttpGet]
		[Route(PayrollRoutes.HostInvoices)]
		public List<PayrollInvoiceResource> GetHostInvoices()
		{
			var invoices = MakeServiceCall(() => _payrollService.GetHostInvoices(CurrentUser.Host), string.Format("get invoices for host with id={0}", CurrentUser.Host));
			var result = Mapper.Map<List<PayrollInvoice>, List<PayrollInvoiceResource>>(invoices);
			var ic =_taxationService.GetApplicationConfig().InvoiceLateFeeConfigs;
			result.ForEach(i=>i.TaxPaneltyConfig = ic);
			return result;
		}
		[HttpGet]
		[Route(PayrollRoutes.DeletePayrollInvoice)]
		public void DeletePayrollInvoice(Guid invoiceId)
		{
			MakeServiceCall(() => _payrollService.DeletePayrollInvoice(invoiceId), string.Format("delete invoice with id={0}", invoiceId));
			
		}
		[HttpGet]
		[Route(PayrollRoutes.RecreateInvoice)]
		public PayrollInvoiceResource RecreateInvoice(Guid invoiceId)
		{
			var invoice = MakeServiceCall(() => _payrollService.RecreateInvoice(invoiceId, CurrentUser.FullName), string.Format("recreate invoice with id={0}", invoiceId));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(invoice);
		}

		[HttpGet]
		[Route(PayrollRoutes.DelayTaxes)]
		public PayrollInvoiceResource DelayTaxes(Guid invoiceId)
		{
			var invoice = MakeServiceCall(() => _payrollService.DelayTaxes(invoiceId, CurrentUser.FullName), string.Format("delay taxes on invoice with id={0}", invoiceId));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(invoice);
		}
		[HttpPost]
		[Route(PayrollRoutes.RedateInvoice)]
		public PayrollInvoiceResource RedateInvoice(PayrollInvoiceResource resource)
		{
			var mapped = Mapper.Map<PayrollInvoiceResource, PayrollInvoice>(resource);
			mapped.UserName = CurrentUser.FullName;
			var invoice = MakeServiceCall(() => _payrollService.RedateInvoice(mapped), string.Format("redate invoice with id={0}", mapped.Id));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(invoice);
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
		public async Task<HttpResponseMessage> ImportTimesheets()
		{
			var filename = string.Empty;
			try
			{
				var fileUploadObj = await ProcessMultipartContent();
				filename = fileUploadObj.file.FullName;
				var company = Mapper.Map<Company, CompanyResource>(_companyService.GetCompanyById(fileUploadObj.CompanyId));
				var importedRows = _excelService.ImportEmployees(fileUploadObj.file);
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

	}


}
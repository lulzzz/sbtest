using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Resources.OnlinePayroll;
using HrMaxxAPI.Resources.Payroll;

namespace HrMaxxAPI.Controllers.Payrolls
{
	public class PayrollController : BaseApiController
	{
		private readonly IPayrollService _payrollService;
		private readonly IDocumentService _documentService;
		private readonly IDashboardService _dashboardService;
		
		public PayrollController(IPayrollService payrollService, IDocumentService documentService, IDashboardService dashboardService)
		{
			_payrollService = payrollService;
			_documentService = documentService;
			_dashboardService = dashboardService;
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
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(processed);
		}

		[HttpPost]
		[Route(PayrollRoutes.PayrollInvoice)]
		public PayrollInvoiceResource SavePayrollInvoice(PayrollInvoiceResource invoice)
		{
			var mappedResource = Mapper.Map<PayrollInvoiceResource, PayrollInvoice>(invoice);
			mappedResource.LastModified = DateTime.Now;
			mappedResource.UserName = CurrentUser.FullName;

			var processed = MakeServiceCall(() => _payrollService.SavePayrollInvoice(mappedResource), string.Format("save payroll invoice for invoice={0}", invoice.Id));
			return Mapper.Map<PayrollInvoice, PayrollInvoiceResource>(processed);
		}

		[HttpGet]
		[Route(PayrollRoutes.HostInvoices)]
		public List<PayrollInvoiceResource> GetHostInvoices(Guid hostId)
		{
			var invoices = MakeServiceCall(() => _payrollService.GetHostInvoices(hostId), string.Format("get invoices for host with id={0}", hostId));
			return Mapper.Map<List<PayrollInvoice>, List<PayrollInvoiceResource>>(invoices);
		}
		[HttpGet]
		[Route(PayrollRoutes.DeletePayrollInvoice)]
		public void DeletePayrollInvoice(Guid invoiceId)
		{
			MakeServiceCall(() => _payrollService.DeletePayrollInvoice(invoiceId), string.Format("delete invoice with id={0}", invoiceId));
			
		}

	}


}
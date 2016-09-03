using System;
using System.Collections.Generic;
using System.Web.Http;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Resources.Payroll;

namespace HrMaxxAPI.Controllers.Payrolls
{
	public class PayrollController : BaseApiController
	{
		private readonly IPayrollService _payrollService;

		public PayrollController(IPayrollService payrollService)
		{
			_payrollService = payrollService;
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
	}


}
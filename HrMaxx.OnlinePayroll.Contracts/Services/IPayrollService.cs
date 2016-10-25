using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IPayrollService
	{
		List<Payroll> GetCompanyPayrolls(Guid companyId, DateTime? startDate, DateTime? endDate);

		Payroll ProcessPayroll(Payroll payroll);
		Payroll ConfirmPayroll(Payroll mappedResource);
		Payroll VoidPayCheck(Guid payrollId, int payCheckId, string name, string fullName);
		PayCheck GetPayCheck(int checkId);
		List<Invoice> GetCompanyInvoices(Guid companyId);
		Invoice SaveInvoice(Invoice mappedResource);
		Invoice GetInvoiceById(Guid invoiceId);
		List<Payroll> GetInvoicePayrolls(Guid invoiceId);
		FileDto PrintPayCheck(int payCheck);
		FileDto PrintPayCheck(PayCheck payCheck);
		void MarkPayCheckPrinted(int payCheckId);
		FileDto PrintPayroll(Payroll payroll);
		PayrollInvoice CreatePayrollInvoice(Payroll payroll, string fullName, bool fetchCompany);
		List<PayrollInvoice> GetHostInvoices(Guid hostId);
		PayrollInvoice SavePayrollInvoice(PayrollInvoice invoice);
		void DeletePayrollInvoice(Guid invoiceId);
		List<Payroll> FixPayrollData();
		PayrollInvoice RecreateInvoice(Guid invoiceId, string fullName);
		List<PayrollInvoice> GetAllPayrollInvoicesWithDeposits();
		PayrollInvoice DelayTaxes(Guid invoiceId, string fullName);
		PayrollInvoice RedateInvoice(PayrollInvoice invoice);
	}
}

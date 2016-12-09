using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IPayrollService
	{
		List<Payroll> GetCompanyPayrolls(Guid companyId, DateTime? startDate, DateTime? endDate, bool includeDrafts = false);

		Payroll ProcessPayroll(Payroll payroll);
		Payroll ConfirmPayroll(Payroll mappedResource);
		Payroll VoidPayCheck(Guid payrollId, int payCheckId, string name, string fullName);
		PayCheck GetPayCheck(int checkId);
		List<Payroll> GetInvoicePayrolls(Guid invoiceId);
		FileDto PrintPayCheck(int payCheck);
		FileDto PrintPayCheck(PayCheck payCheck);
		void MarkPayCheckPrinted(int payCheckId);
		FileDto PrintPayroll(Payroll payroll);
		PayrollInvoice CreatePayrollInvoice(Payroll payroll, string fullName, Guid userId, bool fetchCompany);
		List<PayrollInvoice> GetHostInvoices(Guid hostId, InvoiceStatus submitted = (InvoiceStatus)0);
		PayrollInvoice SavePayrollInvoice(PayrollInvoice invoice);
		void DeletePayrollInvoice(Guid invoiceId);
		List<Payroll> FixPayrollData(Guid? companyId);
		PayrollInvoice RecreateInvoice(Guid invoiceId, string fullName, Guid guid);
		List<PayrollInvoice> GetAllPayrollInvoicesWithDeposits();
		PayrollInvoice DelayTaxes(Guid invoiceId, string fullName);
		PayrollInvoice RedateInvoice(PayrollInvoice invoice);
		Company Copy(Guid companyId, Guid hostId, bool copyEmployees, bool copyPayrolls, DateTime? startDate, DateTime? endDate, string fullName, Guid guid);
		InvoiceDeliveryClaim ClaimDelivery(List<Guid> invoiceIds, string fullName, Guid guid);
		Payroll SaveProcessedPayroll(Payroll mappedResource);
		Payroll DeletePayroll(Payroll mappedResource);
		List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims();
		List<Payroll> GetUnPrintedPayrolls();

		List<PayCheck> GetEmployeePayChecks(Guid companyId, Guid employeeId);
		void FixInvoiceData();
	}
}

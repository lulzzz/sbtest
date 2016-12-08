using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Repository.Payroll
{
	public interface IPayrollRepository
	{
		List<PayCheck> GetPayChecksTillPayDay(Guid day, DateTime payDay);
		Models.Payroll SavePayroll(Models.Payroll payroll);
		List<PayCheck> GetPayChecksPostPayDay(Guid day, DateTime payDay);
		void UpdatePayCheckYTD(PayCheck employeeFutureCheck);
		List<Models.Payroll> GetCompanyPayrolls(Guid companyId, DateTime? startDate, DateTime? endDate);
		List<Models.PayCheck> GetEmployeePayChecks(Guid id, DateTime fiscalStartDate, DateTime fiscalEndDate);
		PayCheck GetPayCheckById(Guid payrollId, int payCheckId);
		PayCheck VoidPayCheck(PayCheck paycheck, string name);
		Models.Payroll GetPayrollById(Guid payrollId);
		PayCheck GetPayCheckById(int payCheckId);
		List<Invoice> GetCompanyInvoices(Guid companyId);
		Invoice SaveInvoice(Invoice invoice);
		Invoice GetInvoiceById(Guid invoiceId);
		List<Models.Payroll> GetInvoicePayrolls(Guid invoiceId);
		void SetPayrollInvoiceId(Invoice savedInvoice);
		void ChangePayCheckStatus(int payCheckId, PaycheckStatus printed);
		void MarkPayrollPrinted(Guid payrollId);
		PayrollInvoice SavePayrollInvoice(PayrollInvoice payrollInvoice);
		List<PayrollInvoice> GetPayrollInvoices(Guid hostId, Guid? companyId, InvoiceStatus status=(InvoiceStatus)0);
		PayrollInvoice GetPayrollInvoiceById(Guid id);
		void DeletePayrollInvoice(Guid invoiceId);
		void SavePayCheck(PayCheck pc);
		List<PayCheck> GetUnclaimedVoidedchecks(Guid companyId);
		List<Models.Payroll> GetAllPayrolls(Guid? companyId);
		List<PayrollInvoice> GetAllPayrollInvoicesWithDeposits();
		void UpdatePayrollPayDay(Guid payrollId, List<int> payChecks, DateTime date);
		List<PayrollInvoice> ClaimDelivery(List<Guid> invoices, string user);
		void SaveInvoiceDeliveryClaim(InvoiceDeliveryClaim invoiceDeliveryClaim);
		List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims();
		List<Models.Payroll> GetAllPayrolls(PayrollStatus companyId);
		List<PayCheck> GetEmployeePayChecks(Guid employeeId);
		List<PayrollInvoice> GetAllPayrollInvoices();
		List<PayCheck> GetACHPayChecks();
		int SaveACHTransactions(List<ACHTransaction> achPayChecks);
		List<PayrollInvoice> GetACHPayrollInvoices();
	}
}

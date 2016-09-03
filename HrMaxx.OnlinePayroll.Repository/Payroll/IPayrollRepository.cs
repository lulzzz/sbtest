using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Repository.Payroll
{
	public interface IPayrollRepository
	{
		List<PayCheck> GetPayChecksTillPayDay(DateTime payDay);
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
	}
}

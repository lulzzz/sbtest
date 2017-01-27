using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Repository.Payroll
{
	public interface IPayrollRepository
	{
		
		List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims();
		
		//Payrolls
		Models.Payroll SavePayroll(Models.Payroll payroll);
		void MarkPayrollPrinted(Guid payrollId);
		void UpdatePayrollPayDay(Guid payrollId, List<int> payChecks, DateTime date);
		//PayChecks
		void SavePayCheck(PayCheck pc);
		void UpdatePayCheckYTD(PayCheck employeeFutureCheck);
		PayCheck VoidPayCheck(PayCheck paycheck, string name);
		void ChangePayCheckStatus(int payCheckId, PaycheckStatus printed);
		//Invoices
		PayrollInvoice SavePayrollInvoice(PayrollInvoice payrollInvoice);
		void DeletePayrollInvoice(Guid invoiceId);
		List<PayrollInvoice> ClaimDelivery(List<Guid> invoices, string user);
		void SaveInvoiceDeliveryClaim(InvoiceDeliveryClaim invoiceDeliveryClaim);


		void UpdatePayCheckSickLeaveAccumulation(PayCheck pc);
		void UpdatePayrollDates(Models.Payroll mappedResource);
	}
}

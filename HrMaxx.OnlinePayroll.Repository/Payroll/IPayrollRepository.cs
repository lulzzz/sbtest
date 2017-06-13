using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;

namespace HrMaxx.OnlinePayroll.Repository.Payroll
{
	public interface IPayrollRepository
	{
		
		List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims(DateTime? startDate, DateTime? endDate);
		
		//Payrolls
		Models.Payroll SavePayroll(Models.Payroll payroll);
		void MarkPayrollPrinted(Guid payrollId);
		void UpdatePayrollPayDay(Guid payrollId, List<int> payChecks, DateTime date);
		//PayChecks
		void SavePayCheck(PayCheck pc);
		void UpdatePayCheckYTD(PayCheck employeeFutureCheck);
		PayCheck VoidPayCheck(PayCheck paycheck, string name);
		PayCheck UnVoidPayCheck(PayCheck paycheck, string name);
		void ChangePayCheckStatus(int payCheckId, PaycheckStatus printed);
		//Invoices
		PayrollInvoice SavePayrollInvoice(PayrollInvoice payrollInvoice);
		void DeletePayrollInvoice(Guid invoiceId);
		List<PayrollInvoice> ClaimDelivery(List<Guid> invoices, string user);
		void SaveInvoiceDeliveryClaim(InvoiceDeliveryClaim invoiceDeliveryClaim);


		void UpdatePayCheckSickLeaveAccumulation(PayCheck payCheck);
		void UpdatePayrollDates(Models.Payroll mappedResource);
		void SavePayrollInvoiceCommission(PayrollInvoice payrollInvoice);
		void SavePayCheckPayTypeAccumulations(List<PayCheckPayTypeAccumulation> ptaccums);
		void SavePayCheckTaxes(List<PayCheckTax> pttaxes);
		void SavePayCheckCompensations(List<PayCheckCompensation> ptcomps);
		void SavePayCheckDeductions(List<PayCheckDeduction> ptdeds);
		void SavePayCheckPayCodes(List<PayCheckPayCode> ptcodes);
		void SavePayCheckWorkerCompensations(List<PayCheckWorkerCompensation> ptwcs);
		void FixPayCheckTaxes(List<PayCheck> taxupdate);
		void FixPayCheckAccumulations(List<PayCheck> accupdate);
		void ReIssueCheck(int payCheckId);
		void MovePayrolls(List<Models.Payroll> payrolls, List<Journal> affectedJournals, List<PayrollInvoice> invoices, Guid guid, Guid source);
		void DeleteAllPayrolls(Guid target);
		void UpdateInvoiceDeliveryData(List<InvoiceDeliveryClaim> claims);
	}
}

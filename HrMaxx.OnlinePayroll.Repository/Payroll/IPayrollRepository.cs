using System;
using System.Collections.Generic;
using System.Text;
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
		void DeletePayroll(Models.Payroll id);
		bool CanUpdateCheckNumbers(Guid id, int startingCheckNumber, int count);
		void UpdatePayrollCheckNumbers(Models.Payroll payroll);
		void VoidPayroll(Models.Payroll id, string userName);
		//PayChecks
		void SavePayCheck(PayCheck pc);
		void UpdatePayCheckYTD(PayCheck employeeFutureCheck);
		void VoidPayChecks(List<PayCheck> payChecks, string userName);
		PayCheck UnVoidPayCheck(PayCheck paycheck, string name);
		void ChangePayCheckStatus(int payCheckId, PaycheckStatus printed);
		//Invoices
		PayrollInvoice SavePayrollInvoice(PayrollInvoice payrollInvoice, ref StringBuilder strLog);
		void DeletePayrollInvoice(Guid invoiceId, List<MiscFee> miscCharges, PayrollInvoice invoice);
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

		void FixPayCheckTaxWages(List<PayCheck> taxupdate, string taxCode);
		void FixPayCheckAccumulations(List<PayCheck> accupdate);
		void ReIssueCheck(int payCheckId);
		void MovePayrolls(List<Models.Payroll> payrolls, List<Models.Journal> affectedJournals, List<PayrollInvoice> invoices, Guid guid, Guid source);
		void DeleteAllPayrolls(Guid target);
		void UpdateInvoiceDeliveryData(List<InvoiceDeliveryClaim> claims);
		void UpdateEmployeeChecksForLeaveCycle(Guid employeeId, DateTime oldHireDate, DateTime newHireDate);


		void UpdatePayroll(Models.Payroll payroll);
		void UpdateLastPayrollDateCompany(Guid id, DateTime payDay);
		void UpdateLastPayrollDateAndPayRateEmployee(List<PayCheck> payChecks );
		void UpdateLastPayrollDateAndPayRateEmployee(Guid id,  decimal rate);
		void UnQueuePayroll(Guid id);
		void ConfirmFailed(Guid id);

		void FixMovedInvoice(Guid id, Guid companyId, string wc);
		List<PayCheckJournal> EnsureCheckNumberIntegrity(Guid payrollId, bool peoasoCoCheck);
		void UpdateInvoiceRecurringCharges(List<Models.PayrollInvoiceMiscCharges> updatedList);
		List<Models.PayrollInvoiceMiscCharges> GetFutureInvoicesMiscCharges(Guid companyId, int invoiceNumber);
		void DelayPayrollInvoice(Guid id, bool taxesDelayed, DateTime lastModified, string userName);

		void UpdateInvoiceMiscCharges(List<PayrollInvoice> invoices );

		void SaveInvoiceRecurringCharge(List<InvoiceRecurringCharge> list);
		List<InvoiceRecurringCharge> GetRecurringChargeToUpdate();
		void FixInvoiceVoidedCredit(PayrollInvoice payrollInvoice);
		void UnVoidPayroll(Guid id, string userName);
		void UpdateCompanyAndEmployeeLastPayrollDate();
	}
}

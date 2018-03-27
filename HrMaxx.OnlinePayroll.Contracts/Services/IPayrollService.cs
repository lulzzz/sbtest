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
using HrMaxx.OnlinePayroll.Models.JsonDataModel;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IPayrollService
	{
		
		List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims(DateTime? startDate, DateTime? endDate);
		
		//Payroll
		Payroll ProcessPayroll(Payroll payroll);
		Payroll ConfirmPayroll(Payroll mappedResource);
		Payroll OldConfirmPayroll(Payroll mappedResource);
		Payroll ReProcessReConfirmPayroll(Payroll payroll);
		FileDto PrintPayrollReport(Payroll payroll);
		List<Payroll> FixPayrollData(Guid? companyId);
		Payroll SaveProcessedPayroll(Payroll mappedResource);
		Payroll DeleteDraftPayroll(Payroll mappedResource);
		FileDto PrintPayrollChecks(Guid payrollId, int companyCheckPrintOrder);
		FileDto PrintAndSavePayroll(Payroll payroll, List<Journal> journals );
		FileDto PrintPayrollPayslips(Guid payrollId);
		FileDto PrintPayrollTimesheet(Payroll mapped);
		Payroll VoidPayroll(Payroll mappedResource, string userName, string userId, bool forceDelete = false);

		//PayCheck
		Payroll VoidPayCheck(Guid payrollId, int payCheckId, string name, string fullName);
		Payroll UnVoidPayCheck(Guid payrollId, int payCheckId, string name, string fullName);
		FileDto PrintPayCheck(int payCheck);
		FileDto PrintPayCheck(PayCheck payCheck);
		void MarkPayCheckPrinted(int payCheckId);

		FileDto PrintPaySlip(int payCheck);
		//Invoice
		PayrollInvoice CreatePayrollInvoice(Payroll payroll, string fullName, Guid userId, bool fetchCompany);
		PayrollInvoice SavePayrollInvoice(PayrollInvoice invoice);
		void DeletePayrollInvoice(Guid invoiceId, Guid userId, string userName, string comment = "Invoice Deleted");
		PayrollInvoice RecreateInvoice(Guid invoiceId, string fullName, Guid guid);
		PayrollInvoice DelayTaxes(Guid invoiceId, string fullName);
		PayrollInvoice RedateInvoice(PayrollInvoice invoice);
		InvoiceDeliveryClaim ClaimDelivery(List<Guid> invoiceIds, string fullName, Guid guid);
		List<Guid> FixInvoiceData();

		Company Copy(Guid companyId, Guid hostId, bool copyEmployees, bool copyPayrolls, DateTime? startDate, DateTime? endDate, string fullName, Guid guid, bool keepEmployeeNumbers);


		void UpdatePayrollDates(Payroll mappedResource);
		void SavePayCheckPayTypeAccumulations(List<PayCheckPayTypeAccumulation> ptaccums);
		void SavePayCheckTaxes(List<PayCheckTax> pttaxes);
		void SavePayCheckCompensations(List<PayCheckCompensation> ptcomps);
		void SavePayCheckDeductions(List<PayCheckDeduction> ptdeds);
		void SavePayCheckPayCodes(List<PayCheckPayCode> ptcodes);
		void SavePayCheckWorkerCompensation(List<PayCheckWorkerCompensation> ptwcs);
		void ReIssuePayCheck(int payCheckId);
		void UpdatePayCheckAccumulation(int payCheckId, PayTypeAccumulation accumulation, string user, string userId);
		void MovePayrolls(Guid source, Guid target, Guid guid, string fullName, bool moveAll, List<Guid> payrolls, bool ashistory );
		void CopyPayrolls(Guid source, Guid target, Guid guid, string fullName, bool moveAll, List<Guid> payrolls, bool ashistory);
		void SaveClaimDelivery(InvoiceDeliveryClaim claim);
		PayCheckPayTypeAccumulation UpdateEmployeeAccumulation(PayCheckPayTypeAccumulation mapped, DateTime newFiscalStart, DateTime newFiscalEnd, Guid employeeId);
		Payroll DeletePayroll(Payroll mappedResource);
		Models.Payroll UpdatePayrollCheckNumbers(Payroll mappedResource);
		void FixPayrollYTD(Guid payrollId);
		Payroll ReQueuePayroll(Payroll mappedResource);
		void MarkPayrollPrinted(Guid payrollId);

		void UpdateLastPayrollDateAndPayRateEmployee(List<PayCheck> payChecks);
	}
}

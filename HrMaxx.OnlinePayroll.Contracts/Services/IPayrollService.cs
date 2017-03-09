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
		
		List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims();
		
		//Payroll
		Payroll ProcessPayroll(Payroll payroll);
		Payroll ConfirmPayroll(Payroll mappedResource);
		FileDto PrintPayrollReport(Payroll payroll);
		List<Payroll> FixPayrollData(Guid? companyId);
		Payroll SaveProcessedPayroll(Payroll mappedResource);
		Payroll DeletePayroll(Payroll mappedResource);
		FileDto PrintPayrollChecks(Payroll payroll);
		FileDto PrintPayrollTimesheet(Payroll mapped);
		Payroll VoidPayroll(Payroll mappedResource, string userName, string userId);

		//PayCheck
		Payroll VoidPayCheck(Guid payrollId, int payCheckId, string name, string fullName);
		FileDto PrintPayCheck(int payCheck);
		FileDto PrintPayCheck(PayCheck payCheck);
		void MarkPayCheckPrinted(int payCheckId);
		
		//Invoice
		PayrollInvoice CreatePayrollInvoice(Payroll payroll, string fullName, Guid userId, bool fetchCompany);
		PayrollInvoice SavePayrollInvoice(PayrollInvoice invoice);
		void DeletePayrollInvoice(Guid invoiceId);
		PayrollInvoice RecreateInvoice(Guid invoiceId, string fullName, Guid guid);
		PayrollInvoice DelayTaxes(Guid invoiceId, string fullName);
		PayrollInvoice RedateInvoice(PayrollInvoice invoice);
		InvoiceDeliveryClaim ClaimDelivery(List<Guid> invoiceIds, string fullName, Guid guid);
		List<Guid> FixInvoiceData();

		Company Copy(Guid companyId, Guid hostId, bool copyEmployees, bool copyPayrolls, DateTime? startDate, DateTime? endDate, string fullName, Guid guid);


		void UpdatePayrollDates(Payroll mappedResource);
		void SavePayCheckPayTypeAccumulations(List<PayCheckPayTypeAccumulation> ptaccums);
	}
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
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
	}
}

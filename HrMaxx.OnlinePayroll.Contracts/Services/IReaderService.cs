using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.Common.Models;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IReaderService
	{
		T GetDataFromStoredProc<T>(string proc, List<FilterParam> paramList);
		T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList);
		T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList, XmlRootAttribute rootAttribute);
		T GetDataFromJsonStoredProc<T, T1>(string proc, List<FilterParam> paramList);
		

		//Invoices
		//List<PayrollInvoice> GetPayrollInvoices(Guid host);
		List<PayrollInvoice> GetPayrollInvoices(Guid host, Guid? companyId = null, InvoiceStatus status = (InvoiceStatus) 0);
		PayrollInvoice GetPayrollInvoice(Guid invoiceId);

		//Payrolls
		List<Payroll> GetPayrolls(Guid? companyId, DateTime? startDate = null, DateTime? endDate = null, bool includeDrafts = false, Guid? invoiceId = null, int status = 0);
		Payroll GetPayroll(Guid payrollId);

		//Paychecks
		List<PayCheck> GetPayChecks(Guid? companyId = null, Guid? employeeId=null, Guid? payrollId = null, DateTime? startDate = null, DateTime? endDate = null, int status = 0, int? isvoid = null, int? year = null);
		PayCheck GetPaycheck(int payCheckId);

		//Companies
		List<Company> GetCompanies(Guid? host = null, Guid? company = null, int? status = null);
		Company GetCompany(Guid companyId);

		//Employees
		List<Employee> GetEmployees(Guid? host = null, Guid? company = null, int? status = null);
		Employee GetEmployee(Guid employeeId);

		//Extracts
		List<MasterExtract> GetExtracts(string extractname = null);
		MasterExtract GetExtract(int id);

		//ExtractData
		ExtractResponse GetExtractResponse(ReportRequest request);

	}
}

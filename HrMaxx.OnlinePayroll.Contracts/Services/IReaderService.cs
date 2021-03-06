﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.Common.Models;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using CompanyRecurringCharge = HrMaxx.OnlinePayroll.Models.CompanyRecurringCharge;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IReaderService
	{
		T GetDataFromStoredProc<T>(string proc, List<FilterParam> paramList);
		T GetDataFromStoredProc<T>(string proc, List<FilterParam> paramList, XmlRootAttribute rootAttribute);
		T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList);
		T GetDataFromStoredProc<T, T1>(string proc, List<FilterParam> paramList, XmlRootAttribute rootAttribute);
		T GetDataFromJsonStoredProc<T, T1>(string proc, List<FilterParam> paramList);

        List<T> GetQueryData<T>(string query);
		List<T1> GetQueryData<T, T1>(string query);


		//Invoices
		//List<PayrollInvoice> GetPayrollInvoices(Guid host);
		List<PayrollInvoiceListItem> GetPayrollInvoiceList(Guid? host = null, Guid? companyId = null, List<InvoiceStatus> status = null, DateTime? startDate = null, DateTime? endDate = null, List<PaymentStatus> paymentStatuses = null, List<InvoicePaymentMethod> paymentMethods = null, bool includeTaxesDelayed = false);
		List<PayrollInvoice> GetPayrollInvoices(Guid? host = null, Guid? companyId = null, List<InvoiceStatus> status = null, DateTime? startDate = null, DateTime? endDate=null, Guid? id=null, List<PaymentStatus> paymentStatuses = null, List<InvoicePaymentMethod> paymentMethods = null, int? invoiceNumber=null, bool byPayDay=false  );
		List<PayrollInvoice> GetCompanyInvoices(Guid companyId, List<InvoiceStatus> status = null, DateTime? startDate = null, DateTime? endDate = null, Guid? id = null);
		List<InvoiceByStatus> GetCompanyPreviousInvoiceNumbers(Guid companyId);
		PayrollInvoice GetPayrollInvoice(Guid invoiceId);
		List<ExtractInvoicePayment> GetInvoicePayments(DateTime? startDate, DateTime? endDate);
		//Payrolls
		List<PayrollMinified> GetMinifiedPayrolls(Guid? companyId, DateTime? startDate = null, DateTime? endDate = null, bool includeDrafts = false, Guid? invoiceId = null, int status = 0, int excludeVoids = 0, bool? isprinted = null);
		List<Payroll> GetPayrolls(Guid? companyId, DateTime? startDate = null, DateTime? endDate = null, bool includeDrafts = false, Guid? invoiceId = null, int status = 0, int excludeVoids=0);
		Payroll GetPayroll(Guid payrollId);

		//Paychecks
		List<PayCheck> GetPayChecks(Guid? companyId = null, Guid? employeeId=null, Guid? payrollId = null, DateTime? startDate = null, DateTime? endDate = null, int status = 0, int? isvoid = null, int? year = null);
		List<VoidedPayCheckInvoiceCredit> GetCompanyPayChecksForInvoiceCredit(Guid companyId);
		List<PayCheck> GetEmployeePayChecks(Guid employeeId);
		PayCheck GetPaycheck(int payCheckId);

		//Journals
		List<Models.Journal> GetJournals(Guid? companyId = null, Guid? payrollId = null, int? payCheckId = null, DateTime? startDate = null, DateTime? endDate = null, int transactionType = 0, int? isvoid = null, int? year = null, int accountId = 0, bool? PEOASOCoCheck = null, int id = 0, bool includePayrolls = false, bool includeDetails = true);
		List<int> GetJournalIds(Guid companyId, int accountId, DateTime startDate, DateTime endDate, int transactionType);
		List<Models.CompanyInvoice> GetVendorInvoices(Guid? companyId = null, DateTime? startDate = null, DateTime? endDate = null, int? isvoid = null, int? year = null, int id = 0);
		//Companies
		List<Company> GetCompanies(Guid? host = null, Guid? company = null, int? status = 1);
		Company GetCompany(Guid companyId);

		//Employees
		List<Employee> GetEmployees(Guid? host = null, Guid? company = null, int? status = 1);
		Employee GetEmployee(Guid employeeId);

		//Extracts
		List<MasterExtract> GetExtracts(string extractname = null);
		MasterExtract GetExtract(int id);

		//ExtractData
		ExtractResponse GetExtractResponse(ReportRequest request);
		ExtractResponse GetExtractResponseSpecial(ReportRequest request);

		ExtractResponse GetExtractAccumulation(string report, DateTime startDate, DateTime endDate, Guid? host = null, 
			DepositSchedule941? depositSchedule941 = null,  bool includeVoids = false, bool includeTaxes = false,
			bool includedDeductions = false, bool includedCompensations = false, bool includeWorkerCompensations = false,
			bool includePayCodes = false, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false, 
			bool includeHistory = false, bool includeC1095 = false, bool checkEFileFormsFlag = true, bool checkTaxPaymentFlag=true,
			string extractDepositName=null, int? state=null);

		ExtractResponse GetExtractDE34(string report, DateTime startDate, DateTime endDate, Guid? host = null,
			DepositSchedule941? depositSchedule941 = null, bool includeVoids = false, bool includeTaxes = false,
			bool includedDeductions = false, bool includedCompensations = false, bool includeWorkerCompensations = false,
			bool includePayCodes = false, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false,
			bool includeHistory = false, bool includeC1095 = false, bool checkEFileFormsFlag = true, bool checkTaxPaymentFlag = true,
			string extractDepositName = null, int? state = null);

		ExtractResponse GetExtractAccumulationReverse(string report, int masterExtractId, Guid? host = null,
			DepositSchedule941? depositSchedule941 = null, bool includeVoids = false, bool includeTaxes = false,
			bool includedDeductions = false, bool includedCompensations = false, bool includeWorkerCompensations = false,
			bool includePayCodes = false, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false,
			bool includeHistory = false, bool includeC1095 = false, bool checkEFileFormsFlag = true, bool checkTaxPaymentFlag = true,
			string extractDepositName = null, int? state = null);

		ExtractResponse GetTaxEligibilityAccumulation(DepositSchedule941? depositSchedule);

		//Companies
		List<JournalPayee> GetJournalPayees(Guid companyId);
		JournalPayee GetPayee(Guid company, Guid id, int payeeType);
        List<Product> GetProducts(Guid? companyId = null);
        ACHMasterExtract GetACHExtract(int id);
		CommissionsResponse GetCommissionsExtractResponse(CommissionsReportRequest request);
		CommissionsExtract GetCommissionsExtract(int id);
		List<Accumulation> GetAccumulations(Guid? company = null, DateTime? startdate = null, DateTime? enddate = null, string ssns = null);

		List<Accumulation> GetTaxAccumulations(Guid? company = null, DateTime? startdate = null, DateTime? enddate = null, AccumulationType type = AccumulationType.Employee,
			bool includeVoids = false, bool includeTaxes = false,
			bool includedDeductions = false, bool includedCompensations = false, bool includeWorkerCompensations = false,
			bool includePayCodes = false, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false, bool includePayTypeAccumulation = false, string report = null, bool includeHistory = false,
			bool includeC1095 = false, bool includeClients = false, bool includeTaxDelayed = false, Guid? employee = null, string extractDepositName = null,
			bool includeClientEmployees = false, bool includeMedicareExtraWages = false, int? state = null);


		List<CompanyRecurringCharge> GetCompanyRecurringCharges(Guid id);
		List<MinWageEligibileCompany> GetMinWageEligibilityReport(MinWageEligibilityCriteria criteria);
		List<Accumulation> GetTaxAccumulationsBulk(string company, DateTime? startdate = null, DateTime? enddate = null, AccumulationType type = AccumulationType.Employee,
			bool includeVoids = false, bool includeTaxes = false,
			bool includedDeductions = false, bool includedCompensations = false, bool includeWorkerCompensations = false,
			bool includePayCodes = false, bool includeDailyAccumulation = false, bool includeMonthlyAccumulation = false, bool includePayTypeAccumulation = false, string report = null, bool includeHistory = false,
			bool includeC1095 = false, bool includeClients = false, bool includeTaxDelayed = false, Guid? employee = null, string extractDepositName = null, int? state = null);
	}
}

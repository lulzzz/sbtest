using System.Web.UI;

namespace HrMaxxAPI.Controllers.Companies
{
	public class CompanyRoutes
	{
		public const string MetaData = "Company/MetaData";
		public const string CompanyList = "Company/Companies";
		public const string Companies = "Company/Companies/{hostId:guid}";
		public const string Company = "Company/Company/{id:guid}";
		public const string Save = "Company/Save";

		public const string SaveDeduction = "Company/Deduction";
		public const string SaveCompanyTaxYearRate = "Company/TaxYearRate";
		public const string SaveWorkerCompensation = "Company/WorkerCompensation";
		public const string SaveAccumulatedPayType = "Company/AccumulatedPayType";
		public const string SavePayCode = "Company/PayCode";
		public const string SaveLocation = "Company/SaveLocation";
		public const string VendorCustomerList = "Company/Vendors/{isVendor:bool}/{companyId:guid?}";
		public const string GlobalVendors = "Company/GlobalVendors";
		public const string VendorCustomer = "Company/VendorCustomer";
		public const string Accounts = "Company/Accounts/{companyId:guid}";
		public const string SaveAccount = "Company/Accounts";
		public const string EmployeeList = "Company/Employees/{companyId:guid}";
		public const string Employee = "Company/Employee";
		public const string EmployeeMetaData = "Company/EmployeeMetaData";
		public const string EmployeeDeduction = "Company/EmployeeDeduction";
		public const string DeleteEmployeeDeduction = "Company/DeleteEmployeeDeduction/{deductionId:int}";
		public const string PayrollMetaData = "Company/PayrollMetaData";
		public const string InvoiceMetaData = "Company/InvoiceMetaData/{companyId:guid}";
		public const string GetEmployeeImportTemplate = "Company/EmployeeImport/{companyId:guid}";
		public const string ImportEmployees = "Company/ImportEmployees";
		public const string CopyCompany = "Company/Copy";
		public const string AllCompanies = "Company/AllCompanies/{year:int}";
		public const string ImportTaxRates = "Company/ImportTaxRates";
		public const string ImportWCRates = "Company/ImportWCRates";
		public const string SaveTaxRates = "Company/SaveTaxRates";
		public const string GetCaliforniaEDDExport = "Company/CaliforniaEDD";
		public const string RaiseMinWage = "Company/RaiseMinWage/{minWage:decimal}";

		public const string PEOCompanies = "Company/AllPEOCompanies";
		public const string AllEmployees = "Company/EmployeeList";
		public const string MinifiedCompanyList = "Company/CompanyListMinified";
		public const string MinifiedEmployeeList = "Company/EmployeeListMinified";
		public const string FixEmployeePayCodes = "Company/FixEmployeePayCodes/{companyId:guid}";
		public const string CopyEmployees = "Company/CopyEmployees"; 
		public const string UpdateWCRates = "Company/UpdateWCRates";
		public const string SSNCheck = "Company/SSNCheck/{ssn}";
	}
}
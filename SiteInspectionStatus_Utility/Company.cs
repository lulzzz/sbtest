using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LinqToExcel.Attributes;

namespace SiteInspectionStatus_Utility
{
	public class EmployeeListItem{
		public string CompanyName { get; set; }
		public string Employee { get; set; }
		public string SSN { get; set; }
		public DateTime HireDate { get; set; }
		public DateTime DateCreated { get; set; }
	}
	public class Company
	{
		[ExcelColumn("CompanyName")]
		public string Name { get; set; }

		[ExcelColumn("CompanyNo")]
		public string CompanyNo { get; set; }

		[ExcelColumn("HostId")]
		public string HostId { get; set; }

		[ExcelColumn("StatusId")]
		public string StatusId { get; set; }

		[ExcelColumn("IsVisibleToHost")]
		public string IsVisibleToHost { get; set; }

		[ExcelColumn("FileUnderHost")]
		public string FileUnderHost { get; set; }

		[ExcelColumn("DirectDebitPayer")]
		public string DirectDebitPayer { get; set; }

		[ExcelColumn("PayrollDaysInPast")]
		public string PayrollDaysInPast { get; set; }

		[ExcelColumn("InsuranceGroupNo")]
		public string InsuranceGroupNo { get; set; }

		[ExcelColumn("TaxFilingName")]
		public string TaxFilingName { get; set; }

		[ExcelColumn("CompanyAddress Line 1")]
		public string AddressLine1 { get; set; }

		[ExcelColumn("Company Address City")]
		public string City { get; set; }

		[ExcelColumn("Company Address State")]
		public string State { get; set; }

		[ExcelColumn("Company Address Zip")]
		public string Zip { get; set; }

		[ExcelColumn("IsAddressSame")]
		public string IsAddressSame { get; set; }

		[ExcelColumn("ManageTaxPayment")]
		public string ManageTaxPayment { get; set; }

		[ExcelColumn("ManageEFileForms")]
		public string ManageEFileForms { get; set; }

		[ExcelColumn("FederalEIN")]
		public string FederalEIN { get; set; }

		[ExcelColumn("FederalPin")]
		public string FederalPIN { get; set; }

		[ExcelColumn("DepositSchedule941")]
		public string DepositSchedule941 { get; set; }

		[ExcelColumn("PayrollSchedule")]
		public string PayrollSchedule { get; set; }

		[ExcelColumn("PayCheckStock")]
		public string PayCheckStock { get; set; }

		[ExcelColumn("IsFiler944")]
		public string IsFiler944 { get; set; }

		[ExcelColumn("MinWage")]
		public string MinWage { get; set; }

		[ExcelColumn("Memo")]
		public string Memo { get; set; }

		[ExcelColumn("InsuranceClientNo")]
		public string InsuranceClientNo { get; set; }

		[ExcelColumn("StateEIN")]
		public string StateEIN { get; set; }

		[ExcelColumn("StatePIN")]
		public string StatePIN { get; set; }

		[ExcelColumn("ParentId")]
		public string ParentId { get; set; }

		[ExcelColumn("InvoiceType")]
		public string InvoiceType { get; set; }

		[ExcelColumn("InvoiceStyle")]
		public string InvoiceStyle { get; set; }

		[ExcelColumn("AdminFeeMethod")]
		public string AdminFeeMethod { get; set; }

		[ExcelColumn("AdminFee")]
		public string AdminFee { get; set; }

		[ExcelColumn("SUIManagementRate")]
		public string SUIManagementRate { get; set; }

		[ExcelColumn("ApplyStatuaryLimits")]
		public string ApplyStatuaryLimits { get; set; }

		[ExcelColumn("ApplyEnvironmentalFee")]
		public string ApplyEnvironmentalFee { get; set; }

		[ExcelColumn("ApplyWCCharge")]
		public string ApplyWCCharge { get; set; }

		[ExcelColumn("PrintCompanyNameOnChecks")]
		public string PrintCompanyNameOnChecks { get; set; }

		[ExcelColumn("IsHostCompany")]
		public string IsHostCompany { get; set; }

	}

	public class CompanyDeduction
	{
		[ExcelColumn("DeductionId")]
		public string DeductionId { get; set; }

		[ExcelColumn("CompanyNo")]
		public string CompanyNo { get; set; }

		[ExcelColumn("Type")]
		public string DeductionType { get; set; }

		[ExcelColumn("DeductionName")]
		public string DeductionName { get; set; }

		[ExcelColumn("Description")]
		public string Description { get; set; }


	}

	public class CompanyWorkerCompensation
	{
		[ExcelColumn("CompanyNo")]
		public string CompanyNo { get; set; }

		[ExcelColumn("Code")]
		public string Code { get; set; }

		[ExcelColumn("Description")]
		public string Description { get; set; }

		[ExcelColumn("Rate")]
		public string Rate { get; set; }

		[ExcelColumn("MinGrossWage")]
		public string MinGrossWage { get; set; }

		[ExcelColumn("WCId")]
		public string WCId { get; set; }


	}

	public class CompanyTaxRate
	{
		[ExcelColumn("CompanyNo")]
		public string CompanyNo { get; set; }

		[ExcelColumn("SUIRate")]
		public string SUIRate { get; set; }

		[ExcelColumn("ETTRate")]
		public string ETTRate { get; set; }

		[ExcelColumn("InvoicePercentage")]
		public string InvoicePercentage { get; set; }

		[ExcelColumn("SUIManagementRate")]
		public string SUIManagementRate { get; set; }

		[ExcelColumn("ApplyStatuaryLimits")]
		public string ApplyStatuaryLimits { get; set; }

		[ExcelColumn("TaxYear")]
		public string TaxYear { get; set; }


	}

	public class CompanyBankAccount
	{
		[ExcelColumn("CompanyNo")]
		public string CompanyNo { get; set; }

		[ExcelColumn("BankName")]
		public string BankName { get; set; }

		[ExcelColumn("AccountName")]
		public string AccountName { get; set; }

		[ExcelColumn("AccountNumber")]
		public string AccountNumber { get; set; }

		[ExcelColumn("RoutingNumber")]
		public string RoutingNumber { get; set; }


	}

	public class Employee
	{
		[ExcelColumn("EmployeeNo")]
		public string EmployeeNo { get; set; }

		[ExcelColumn("CompanyEmployeeNo")]
		public string CompanyEmployeeNo { get; set; }

		[ExcelColumn("CompanyNo")]
		public string CompanyNo { get; set; }

		[ExcelColumn("StatusId")]
		public string StatusId { get; set; }

		[ExcelColumn("FirstName")]
		public string FirstName { get; set; }

		[ExcelColumn("LastName")]
		public string LastName { get; set; }

		[ExcelColumn("MiddleInitial")]
		public string MiddleInitial { get; set; }

		[ExcelColumn("Email")]
		public string Email { get; set; }

		[ExcelColumn("Phone")]
		public string Phone { get; set; }

		[ExcelColumn("Mobile")]
		public string Mobile { get; set; }

		[ExcelColumn("EAddressLine1")]
		public string EAddressLine1 { get; set; }

		[ExcelColumn("ECity")]
		public string ECity { get; set; }

		[ExcelColumn("State")]
		public string State { get; set; }

		[ExcelColumn("EZip")]
		public string EZip { get; set; }

		[ExcelColumn("Gender")]
		public string Gender { get; set; }

		[ExcelColumn("SSN")]
		public string SSN { get; set; }

		[ExcelColumn("BirthDate")]
		public string BirthDate { get; set; }

		[ExcelColumn("HireDate")]
		public string HireDate { get; set; }

		[ExcelColumn("Department")]
		public string Department { get; set; }

		[ExcelColumn("Memo")]
		public string Memo { get; set; }

		[ExcelColumn("PayrollSchedule")]
		public string PayrollSchedule { get; set; }

		[ExcelColumn("PayType")]
		public string PayType { get; set; }

		[ExcelColumn("Rate")]
		public string Rate { get; set; }

		[ExcelColumn("PaymentMethod")]
		public string PaymentMethod { get; set; }

		[ExcelColumn("DirectDebitAuthorized")]
		public string DirectDebitAuthorized { get; set; }

		[ExcelColumn("TaxCategory")]
		public string TaxCategory { get; set; }

		[ExcelColumn("FederalStatus")]
		public string FederalStatus { get; set; }

		[ExcelColumn("FederalExemptions")]
		public string FederalExemptions { get; set; }

		[ExcelColumn("FederalAdditionalAmount")]
		public string FederalAdditionalAmount { get; set; }

		
		[ExcelColumn("WCId")]
		public string WCId { get; set; }

		[ExcelColumn("WCCode")]
		public string WCCode { get; set; }

		[ExcelColumn("StateFilingStatus")]
		public string StateFilingStatus { get; set; }

		[ExcelColumn("StateExemptions")]
		public string StateExemptions { get; set; }

		[ExcelColumn("StateAdditionalAmount")]
		public string StateAdditionalAmount { get; set; }

	}

	public class EmployeeDeduction
	{
		[ExcelColumn("DeductionId")]
		public string DeductionId { get; set; }

		[ExcelColumn("EmployeeNo")]
		public string EmployeeNo { get; set; }

		[ExcelColumn("Method")]
		public string Method { get; set; }

		[ExcelColumn("Rate")]
		public string Rate { get; set; }

		[ExcelColumn("AnnualMax")]
		public string AnnualMax { get; set; }

		[ExcelColumn("CeilingpeCheck")]
		public string CeilingPerCheck { get; set; }

		[ExcelColumn("AccountNo")]
		public string AccountNo { get; set; }

		[ExcelColumn("AgencyId")]
		public string AgencyId { get; set; }

		[ExcelColumn("Priority")]
		public string Priority { get; set; }

		[ExcelColumn("Limit")]
		public string Limit { get; set; }

		[ExcelColumn("CeilingMethod")]
		public string CeilingMethod { get; set; }
	}

	public class VendorCustomer
	{
		[ExcelColumn("AccountNo")]
		public string AccountNo { get; set; }

		[ExcelColumn("AgencyName")]
		public string AgencyName { get; set; }

		[ExcelColumn("FirstName")]
		public string FirstName { get; set; }

		[ExcelColumn("MI")]
		public string MI { get; set; }

		[ExcelColumn("LastName")]
		public string LastName { get; set; }

		[ExcelColumn("AddressLine")]
		public string AddressLine { get; set; }

		[ExcelColumn("AddressCity")]
		public string AddressCity { get; set; }

		[ExcelColumn("AState")]
		public string AState { get; set; }

		[ExcelColumn("AZip")]
		public string AZip { get; set; }

		[ExcelColumn("ZipExtension")]
		public string ZipExtension { get; set; }


	}

	public class EmployeeGarnishments
	{
		[ExcelColumn("EmployeeNo")]
		public string EmployeeNo { get; set; }

		[ExcelColumn("GId")]
		public string GId { get; set; }

		[ExcelColumn("AgencyAccountNo")]
		public string AgencyAccountNo { get; set; }

		[ExcelColumn("AccountNo")]
		public string AccountNo { get; set; }

		[ExcelColumn("Limit")]
		public string Limit { get; set; }

		[ExcelColumn("Debt")]
		public string Debt { get; set; }

		[ExcelColumn("Method")]
		public string Method { get; set; }

		[ExcelColumn("Rate")]
		public string Rate { get; set; }

		[ExcelColumn("CPC")]
		public string CPC { get; set; }

		[ExcelColumn("Priority")]
		public string Priority { get; set; }


	}
	public class EmployeeBankAccount
	{
		[ExcelColumn("EmployeeNo")]
		public string EmployeeNo { get; set; }

		[ExcelColumn("CompanyNo")]
		public string CompanyNo { get; set; }

		[ExcelColumn("BankName")]
		public string BankName { get; set; }

		[ExcelColumn("AccountName")]
		public string AccountName { get; set; }

		[ExcelColumn("AccountNumber")]
		public string AccountNumber { get; set; }

		[ExcelColumn("RoutingNumber")]
		public string RoutingNumber { get; set; }


	}
}

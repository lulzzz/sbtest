﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OPImportUtility
{
	public static class Queries
	{
		public const string pxcompanies = "select * from paxolop.dbo.Company;";
		public const string pxhosts = "select * from paxolop.dbo.host;";

		public const string company = "select * from company;";
		public const string users = "select * from UserAccount";
		public const string contacts = "select * from Contact";
		public const string cpa = "select * from cpa";
		public const string subsscription = "select * from subscriptions";
		public const string billing = "select * from billingdetails";
		public const string banks = "select * from bankaccount where bankname<>''";
		public const string vendors = "select * from vendor_customer where vendorcustomername not in ('IRS', 'CA EDD')";
		public const string employees = "select * from employee";
		public const string employeedeductions = "select * from employee_deduction";
		public const string employeepaytypes = "select * from employeepaytypes";
		public const string employeepayrates = "select * from employeepayrates";
	}
	public class CPA
	{
		public int CPAID { get; set; }
		public string CPAFirmName { get; set; }
		public string URL1 { get; set; }
		public string Status { get; set; }
		public string WebOverview { get; set; }
		public DateTime CPAEffDate { get; set; }
		public string WebNews { get; set; }
		public string OurService { get; set; }
		public DateTime? CPATermDate { get; set; }
		public string LogoImageName { get; set; }
		public string ContactImageName { get; set; }
		public DateTime LastUpdateDate { get; set; }
		public string LastUpdateBy { get; set; }
		public int TemplateID { get; set; }
		public string OfficeHours1From { get; set; }
		public string OfficeHours1To { get; set; }
		public string OfficeHours2From { get; set; }
		public string OfficeHours2To { get; set; }
		public string OfficeHours3From { get; set; }
		public string OfficeHours3To { get; set; }
	}

	public class UserAccount
	{
		public int UserID { get; set; }
		public string UserName { get; set; }
		public string Password { get; set; }
		public int? CPAID { get; set; }
		public int? CompanyID { get; set; }
		public string UserFirstName { get; set; }
		public string UserLastName { get; set; }

		public string UserFullName
		{
			get { return string.Format("{0} {1}", UserFirstName, UserLastName); }
		}

		public string Status { get; set; }
		public int LevelID { get; set; }
		public DateTime? EnteredDate { get; set; }
		public string EnteredBy { get; set; }
		public string LastUpdateBy { get; set; }
		public DateTime LastUpdateDate { get; set; }
		
	}

	public class Contact
	{
		public int ContactID { get; set; }
		public string ContactFirstName { get; set; }
		public string ContactMiddleName { get; set; }
		public string ContactLastName { get; set; }
		public string AddressLine1 { get; set; }
		public string AddressLine2 { get; set; }
		public string City { get; set; }
		public string State { get; set; }
		public string Zip { get; set; }
		public string ZipExtension { get; set; }
		public string Phone1 { get; set; }
		public string Phone2 { get; set; }
		public string Fax { get; set; }
		public string Email1 { get; set; }
		public int EntityID { get; set; }
		public int EntityTypeID { get; set; }
		public int ContactType { get; set; }
	}

	public class Company
	{
		public int CompanyID { get; set; }
		public int CPAID { get; set; }
		public int PayrollPeriodID { get; set; }
		public string CompanyName { get; set; }
		public string TaxFilingName { get; set; }
		public string FEIN { get; set; }
		public string SEIN { get; set; }
		public string FEPIN { get; set; }
		public string STPIN { get; set; }
		public string Status { get; set; }
		public string DepositSchedule941 { get; set; }
		public DateTime EnteredDate { get; set; }
		public string EnteredBy { get; set; }
		public DateTime LastUpdateDate { get; set; }
		public string LastUpdateBy { get; set; }
		public string CompanyNo { get; set; }
		public int PastDays { get; set; }
		public string CheckStock { get; set; }
		public bool ProcessTaxPayments { get; set; }
		public string Memo { get; set; }
		public bool? Depositor944 { get; set; }
		public bool? DirectDebitPayer { get; set; }
		public bool? PreventStaff { get; set; }
		public DateTime? PayDate { get; set; }
		public bool efiler { get; set; }
	}

	public class Subscription
	{
		public int Id { get; set; }
		public int CompanyId { get; set; }
		public int SubscriptionOption { get; set; }
		public int BillingDetailId { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public int employeeLimit { get; set; }

	}

	public class BillingDetail
	{
		public int Id { get; set; }
		public string CardType { get; set; }
		public string CardNumber { get; set; }
		public string CardName { get; set; }
		public string CardExpiryMonth { get; set; }
		public string CardExpiryYear { get; set; }
		public string CardCode { get; set; }
		public string billingAddressLine1 { get; set; }
		public string billingAddressLine2 { get; set; }
		public string billingAddressState { get; set; }
		public string billingAddressZip { get; set; }

	}

	public class BankAccount
	{
		public int AccountId { get; set; }
		public string BankName { get; set; }
		public string AccountType { get; set; }
		public string AccountNumber { get; set; }
		public string RoutingNumber { get; set; }
		public string PayrollFlag { get; set; }
		public int EntityID { get; set; }
		public int EntityTypeID { get; set; }
		public DateTime LastUpdateDate { get; set; }
		public int LastUpdateBy { get; set; }
	}

	public class Vendors
	{
		public int VendorCustomerID { get; set; }
		public int CustomID { get; set; }
		public int CompanyID { get; set; }
		public string VendorCustomerName { get; set; }
		public string VendorCustomerstatus { get; set; }
		public string IndividualSSN { get; set; }
		public string BusinessFIN { get; set; }
		public string Vendor1099 { get; set; }
		public string VendorCustNotes { get; set; }
		public DateTime? LastUpdateDate { get; set; }
		public int LastUpdatedBy { get; set; }
		public string IsCustomer { get; set; }
		public string Acct_No { get; set; }
		public string ContactFirstName { get; set; }
		public string ContactLastName { get; set; }
		public string ContactMiddleInitial { get; set; }
		public string ContactAddress { get; set; }
		public string ContactCity { get; set; }
		public string ContactState { get; set; }
		public string ContactZip { get; set; }
		public string ContactZipExt { get; set; }
		public string Type1099 { get; set; }
		public string SubType1099 { get; set; }
	}

	public class Employee
	{
		public int EmployeeID { get; set; }
		public string PayType { get; set; }
		public int CompanyID { get; set; }
		public int PayRateAmount { get; set; }
		public string FirstName { get; set; }
		public string PayRateDuration { get; set; }
		public string LastName { get; set; }
		public int PayrollPeriodID { get; set; }
		public int WCJobClass { get; set; }
		public string MiddleName { get; set; }
		public int HoursWorked { get; set; }
		public string BirthDate { get; set; }
		public string Gender { get; set; }
		public int DaysWorked { get; set; }
		public string PaymentMethod { get; set; }
		public string EmployeeSSN { get; set; }
		public string FedFilingStatus { get; set; }
		public string Department { get; set; }
		public string Status { get; set; }
		public int FedExemptions { get; set; }
		public decimal FedAdditionalAmount { get; set; }
		public DateTime? HireDate { get; set; }
		public string PayrollType { get; set; }
		public string StateFilingStatus { get; set; }
		public int StateExemptions { get; set; }
		public decimal StateAdditionalAmount { get; set; }
		public DateTime LastUpdateDate { get; set; }
		public int LastUpdatedBy { get; set; }
		public int EmployeeNo { get; set; }
		public int EmployeeType { get; set; }
		public bool DDCert { get; set; }
		public bool MultiplePayRates { get; set; }
		public bool MultipleCompensationTypes { get; set; }
		public bool qhireact { get; set; }
		public string W2Memo { get; set; }
	}

	public class EmployeePayRate
	{
		public int EmployeePayRateId { get; set; }
		public int EmployeeId { get; set; }
		public int PayRateOrder { get; set; }
		public string PayRateDescription { get; set; }
		public decimal PayRateAmount { get; set; }
	}

	public class EmployeePayType
	{
		public int OtherPayTypeEmployeeId { get; set; }
		public int OtherTypeId { get; set; }
		public int EmployeeId { get; set; }
		public decimal Amount { get; set; }
	}

	public class EmployeeDeduction
	{
		public int EmployeeId { get; set; }
		public int DeductionId { get; set; }
		public int DeductionMethod { get; set; }
		public decimal? AnnualMaxAmount { get; set; }
		public decimal DeductionAmount { get; set; }
		
	}

	public class Deduction_Type
	{
		public int ID { get; set; }
		public int DeductionCategoryID { get; set; }
		public string DeductionType { get; set; }

	}
}
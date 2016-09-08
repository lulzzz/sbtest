using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Attributes;

namespace HrMaxx.OnlinePayroll.Models.Enum
{
	public enum DeductionCategory
	{
		[HrMaxxSecurity(DbId = 1, DbName = "Post Tax Deduction")]
		PostTaxDeduction=1,
		[HrMaxxSecurity(DbId = 2, DbName = "Partial Pre Tax Deduction")]
		PartialPreTaxDeduction=2,
		[HrMaxxSecurity(DbId = 3, DbName = "Total Pre Tax Deduction")]
		TotalPreTaxDeduction=3,
		[HrMaxxSecurity(DbId = 4, DbName = "Other")]
		Other=4
	}
	public enum PayCheckStock
	{
		[HrMaxxSecurity(HrMaxxName = "MICRPayCheck.pdf")]
		MICREncodedTop=1,
		[HrMaxxSecurity(HrMaxxName = "LaserMiddlePayCheck.pdf")]
		LaserMiddle=2,
		[HrMaxxSecurity(HrMaxxName = "LaserTopPayCheck.pdf")]
		LaserTop=3,
		[HrMaxxSecurity(HrMaxxName = "MICRQBPayCheck.pdf")]
		MICRQb=4
	}

	public enum DepostiSchedule941
	{
		SemiWeekly=1,
		Monthly=2,
		Quarterly=3
	}

	public enum PayrollSchedule
	{
		Weekly=1,
		BiWeekly=2,
		SemiMonthly=3,
		Monthly=4
	}

	public enum BillingOptions
	{
		None=0,
		CreditCard=1,
		DirectDebit=2,
		Invoice=3
	}

	public enum ContractOption
	{
		PrePaid=1,
		PostPaid=2
	}

	public enum PrePaidSubscriptionOption
	{
		NA=0,
		Free=1,
		Basic=2,
		Premium=3,
		Gold=4
	}

	public enum BankAccountType
	{
		Checking=1,
		Savings=2
	}

	public enum F1099Type
	{
		NA = 0,
		MISC=1,
		INT=2,
		DIV=3
	}

	public enum F1099SubType
	{
		NA = 0,
		NonEmployeeComp = 1,
		OtherIncome = 2,
		Rents = 3,
		InterestIncome = 4,
		OrdinaryDividend = 5,
		QualifiedDividend = 6,
		CaptialGainDist = 7,
		NonDividendDist = 8
	}

	public enum VCIdentifierType
	{
		NA=0,
		IndividualSSN=1,
		BusinessFIN=2
	}

	public enum AccountType
	{
		[HrMaxxSecurity(DbId = 1, DbName = "Asset")]
		Assets=1,
		[HrMaxxSecurity(DbId = 2, DbName = "Equity")]
		Equity=2,
		[HrMaxxSecurity(DbId = 3, DbName = "Expense")]
		Expense=3,
		[HrMaxxSecurity(DbId = 4, DbName = "Income")]
		Income=4,
		[HrMaxxSecurity(DbId = 5, DbName = "Liability")]
		Liability=5
	}

	public enum AccountSubType
	{
		[HrMaxxSecurity(DbId = 1, DbName = "Fixed Asset")]
		FixedAssets=1,
		[HrMaxxSecurity(DbId = 2, DbName = "Bank")]
		Bank=2,
		[HrMaxxSecurity(DbId = 3, DbName = "Inventory")]
		Inventory=3,
		[HrMaxxSecurity(DbId = 4, DbName = "Other")]
		Other=4,
		[HrMaxxSecurity(DbId = 5, DbName = "Opening Balance")]
		OpeningBalance=5,
		[HrMaxxSecurity(DbId = 6, DbName = "Owner Equity")]
		OwnerEquity=6,
		[HrMaxxSecurity(DbId = 7, DbName = "Retained Earnings")]
		RetainedEarnings=7,
		[HrMaxxSecurity(DbId = 8, DbName = "Depreciation")]
		Depreciation=8,
		[HrMaxxSecurity(DbId = 9, DbName = "Insurance")]
		Insurance=9,
		[HrMaxxSecurity(DbId = 10, DbName = "Interest")]
		Interest=10,
		[HrMaxxSecurity(DbId = 11, DbName = "Office Expense")]
		OfficeExpence=11,
		[HrMaxxSecurity(DbId = 12, DbName = "Operation Fees")]
		OperatingFees=12,
		[HrMaxxSecurity(DbId = 13, DbName = "Other")]
		OtherExpense=13,
		[HrMaxxSecurity(DbId = 14, DbName = "Payroll Taxes")]
		PayrollTaxes=14,
		[HrMaxxSecurity(DbId = 15, DbName = "Payroll Wages")]
		PayrollWages=15,
		[HrMaxxSecurity(DbId = 16, DbName = "Rent and Lease")]
		RentAndLease=16,
		[HrMaxxSecurity(DbId = 17, DbName = "Service Fees")]
		ServiceFees=17,
		[HrMaxxSecurity(DbId = 18, DbName = "Taxes")]
		Taxes=18,
		[HrMaxxSecurity(DbId = 19, DbName = "Travel")]
		Travel=19,
		[HrMaxxSecurity(DbId = 20, DbName = "Utilities")]
		Utilities=20,
		[HrMaxxSecurity(DbId = 21, DbName = "Suspense")]
		Suspense=21,
		[HrMaxxSecurity(DbId = 22, DbName = "Interest")]
		InterestIncome=22,
		[HrMaxxSecurity(DbId = 23, DbName = "Other Income")]
		OtherIncome=23,
		[HrMaxxSecurity(DbId = 24, DbName = "Regular Income")]
		RegularIncome=24,
		[HrMaxxSecurity(DbId = 25, DbName = "Long Term")]
		LongTerm=25,
		[HrMaxxSecurity(DbId = 26, DbName = "Short Term")]
		ShortTerm=26


	}

	public enum GenderType
	{
		Male=1,
		Female=2
	}

	public enum EmployeeType
	{
		Hourly=1,
		Salary=2
	}

	public enum EmployeeTaxStatus
	{
		[HrMaxxSecurity(DbName = "Single")]
		Single=1,
		[HrMaxxSecurity(DbName = "Married")]
		Married=2,
		[HrMaxxSecurity(DbName = "U")]
		UnmarriedHeadofHousehold=3
	}

	public enum USFederalFilingStatus
	{
		[HrMaxxSecurity(DbName = "Single")]
		Single=1,
		[HrMaxxSecurity(DbName = "Married")]
		Married=2,
		[HrMaxxSecurity(DbName = "Unmarried Head of Household")]
		HeadofHousehold=3
	}

	public enum CAStateFilingStatus
	{
		[HrMaxxSecurity(DbName = "Single")]
		Single=1,
		[HrMaxxSecurity(DbName = "Married")]
		Married=2,
		[HrMaxxSecurity(DbName = "Headofhousehold")]
		HeadofHousehold=3
	}

	public enum CAStateLowIncomeFilingStatus
	{
		[HrMaxxSecurity(DbName = "Single")]
		Single=1,
		[HrMaxxSecurity(DbName = "DualIncomeMarried")]
		DualIncomeMarried=2,
		[HrMaxxSecurity(DbName = "MarriedWithMultipleEmployers")]
		MarriedWithMultipleEmployers=3,
		[HrMaxxSecurity(DbName = "Married")]
		Married=4,
		[HrMaxxSecurity(DbName = "Headofhousehold")]
		HeadofHousehold=5
	}


	public enum EmployeeTaxCategory
	{
		USWorkerNonVisa=1,
		NonImmigrantAlien=2
	}

	public enum EmployeePaymentMethod
	{
		[HrMaxxSecurity(DbName = "Check")]
		Check=1,
		[HrMaxxSecurity(DbName = "EFT")]
		DirectDebit=2
	}

	public enum DeductionMethod
	{
		Percentage=1,
		FixedRate=2
	}

	public enum PaycheckStatus
	{
		[HrMaxxSecurity(DbName = "Not Processed")]
		NotProcessed = 1,
		[HrMaxxSecurity(DbName = "Processed")]
		Processed = 2,
		[HrMaxxSecurity(DbName = "Committed")]
		Saved = 3,
		[HrMaxxSecurity(DbName = "Printed")]
		Printed = 4,
		[HrMaxxSecurity(DbName = "Paid")]
		Paid = 5,
		[HrMaxxSecurity(DbName = "Printed And Paid")]
		PrintedAndPaid = 6,
		[HrMaxxSecurity(DbName = "Void")]
		Void = 7
	}

	public enum PayrollStatus
	{
		[HrMaxxSecurity(DbName = "Not Processed")]
		Started = 1,
		[HrMaxxSecurity(DbName = "Processed")]
		Processed = 2,
		[HrMaxxSecurity(DbName = "Committed")]
		Committed = 3,
		[HrMaxxSecurity(DbName = "Invoiced")]
		Invoiced = 4,
		[HrMaxxSecurity(DbName = "Printed")]
		Printed = 5

	}

	public enum TransactionType
	{
		[HrMaxxSecurity(DbName = "Payroll Check")]
		PayCheck=1,
		[HrMaxxSecurity(DbName = "Regular Check")]
		RegularCheck=2,
		[HrMaxxSecurity(DbName = "Deposit")]
		Deposit=3,
		[HrMaxxSecurity(DbName = "Adjustment")]
		Adjustment=4

	}

	public enum VendorDepositMethod
	{
		[HrMaxxSecurity(DbName = "Check")]
		Check = 1,
		[HrMaxxSecurity(DbName = "Cash")]
		Cash = 2
	}

	public enum CubeType
	{
		Yearly=1,
		Quarterly=2,
		Monthly=3
	}

	public enum InvoiceStatus
	{
		[HrMaxxSecurity(DbName = "Draft")]
		Draft=1,
		[HrMaxxSecurity(DbName = "Submitted")]
		Submitted=2,
		[HrMaxxSecurity(DbName = "Delivered")]
		Delivered = 3,
		[HrMaxxSecurity(DbName = "Paid")]
		Paid=4,
		[HrMaxxSecurity(DbName = "On Hold")]
		OnHold=5,
		[HrMaxxSecurity(DbName = "Payment Bounced")]
		PaymentBounced = 6,
		[HrMaxxSecurity(DbName = "Partially Paid")]
		PartialPayment = 7
		
	}

	public enum PaymentStatus
	{
		[HrMaxxSecurity(DbName = "Draft")]
		Draft = 1,
		[HrMaxxSecurity(DbName = "Submitted")]
		Submitted = 2,
		[HrMaxxSecurity(DbName = "Paid")]
		Paid = 3,
		[HrMaxxSecurity(DbName = "Payment Bounced")]
		PaymentBounced = 4
	}

	public enum RiskLevel
	{
		[HrMaxxSecurity(DbName = "Low")]
		Low=1,
		[HrMaxxSecurity(DbName = "Medium")]
		Medium=2,
		[HrMaxxSecurity(DbName = "High")]
		High=3,
		[HrMaxxSecurity(DbName = "Critical")]
		Critical=4
	}
}

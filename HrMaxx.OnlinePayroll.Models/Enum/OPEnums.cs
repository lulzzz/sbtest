using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Attributes;

namespace HrMaxx.OnlinePayroll.Models.Enum
{
	public enum AccumulationType
	{
		Company=1,
		Employee=2
	}
	public enum AccumulationMode
	{
		All=0,
		Taxes = 1,
		Deductions = 2,
		Compensations=3,
		WorkerCompensation=4,
		PayTypes=5,
		TaxesDeductionsCompensations=6,
		TaxesDeductionsCompensationsDailyMonthly=7,
		PayCodes=8,
		TaxesDailyMonthly=9,
		TaxesDeductions = 10,
		TaxesCompensationsMonthly=11
	}
	public enum DeductionCategory
	{
		[HrMaxxSecurity(DbId = 4, DbName = "Post Tax Deduction")]
		PostTaxDeduction=1,
		[HrMaxxSecurity(DbId = 2, DbName = "Partial Pre Tax Deduction")]
		PartialPreTaxDeduction=2,
		[HrMaxxSecurity(DbId = 1, DbName = "Total Pre Tax Deduction")]
		TotalPreTaxDeduction=3,
		[HrMaxxSecurity(DbId = 3, DbName = "Other")]
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
		MICRQb=4,
		[HrMaxxSecurity(HrMaxxName = "JobCost.pdf")]
		JobCost = 5
	}

	public enum DepositSchedule941
	{
		[HrMaxxSecurity(DbId = 0, DbName = "Next Day")]
		NextDay=0,
		[HrMaxxSecurity(DbId = 1, DbName = "Semi Weekly")]
		SemiWeekly=1,
		[HrMaxxSecurity(DbId = 2, DbName = "Monthly")]
		Monthly=2,
		[HrMaxxSecurity(DbId = 3, DbName = "Quarterly")]
		Quarterly=3
	}

	public enum PayrollSchedule
	{
		[HrMaxxSecurity(DbId = 1, HrMaxxName = "Weekly")]
		Weekly=1,
		[HrMaxxSecurity(DbId = 2,HrMaxxName = "Bi-Weekly")]
		BiWeekly=2,
		[HrMaxxSecurity(DbId = 3,HrMaxxName = "Semi-Monthly")]
		SemiMonthly=3,
		[HrMaxxSecurity(DbId = 4,HrMaxxName = "Monthly")]
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
		Checking = 1,
		Savings = 2
	}

	public enum F1099Type
	{
		NA = 0,
		[HrMaxxSecurity(DbId = 1, DbName = "1099 MISC")]
		MISC=1,
		[HrMaxxSecurity(DbId = 2, DbName = "1099 INT")]
		INT=2,
		[HrMaxxSecurity(DbId = 3, DbName = "1099 DIV")]
		DIV=3
	}

	public enum F1099SubType
	{
		NA = 0,
		[HrMaxxSecurity(DbId = 1, DbName = "Non Employee Comp")]
		NonEmployeeComp = 1,
		[HrMaxxSecurity(DbId = 2, DbName = "Other Income")]
		OtherIncome = 2,
		[HrMaxxSecurity(DbId = 3, DbName = "Rents")]
		Rents = 3,
		[HrMaxxSecurity(DbId = 4, DbName = "Interest Income")]
		InterestIncome = 4,
		[HrMaxxSecurity(DbId = 5, DbName = "Ordinary Dividend")]
		OrdinaryDividend = 5,
		[HrMaxxSecurity(DbId = 6, DbName = "Qualified Dividend")]
		QualifiedDividend = 6,
		[HrMaxxSecurity(DbId = 7, DbName = "Capital Gains Dist")]
		CaptialGainDist = 7,
		[HrMaxxSecurity(DbId = 8, DbName = "Non Dividend Dist")]
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
		NA=0,
		Male=1,
		Female=2
	}

	public enum EmployeeType
	{
		[HrMaxxSecurity(DbName = "Hourly")]
		Hourly=1,
		[HrMaxxSecurity(DbName = "Salary")]
		Salary=2,
		[HrMaxxSecurity(DbName = "PieceWork")]
		PieceWork=3,
		[HrMaxxSecurity(DbName = "JobCost")]
		JobCost=4
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
		[HrMaxxSecurity(DbName = "HeadofHousehold")]
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
		NonImmigrantAlien=2,
		Clergy = 3
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
		NA=0,
		Percentage=1,
		Amount=2
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
		Printed = 5,
		[HrMaxxSecurity(DbName = "Draft")]
		Draft = 6,

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
		Adjustment=4,
		[HrMaxxSecurity(DbName = "Tax Payment")]
		TaxPayment = 5,
		[HrMaxxSecurity(DbName = "Deduction Payment")]
		DeductionPayment = 6,
		[HrMaxxSecurity(DbName = "Invoice Deposit")]
		InvoiceDeposit = 7,

	}

	public enum VendorDepositMethod
	{
		[HrMaxxSecurity(DbName = "NA")]
		NA = 0,
		[HrMaxxSecurity(DbName = "Check")]
		Check = 1,
		[HrMaxxSecurity(DbName = "Cash")]
		Cash = 2
	}
	public enum InvoicePaymentMethod
	{
		[HrMaxxSecurity(DbName = "NA")]
		NA = 0,
		[HrMaxxSecurity(DbName = "Check")]
		Check = 1,
		[HrMaxxSecurity(DbName = "Cash")]
		Cash = 2,
		[HrMaxxSecurity(DbName = "Cert Fund")]
		CertFund = 3,
		[HrMaxxSecurity(DbName = "Corp Check")]
		CorpCheck = 4,
		[HrMaxxSecurity(DbName = "ACH")]
		ACH = 5
	}

	public enum CubeType
	{
		Yearly=1,
		Quarterly=2,
		Monthly=3
	}

	public enum InvoiceStatus
	{
		[HrMaxxSecurity(DbName = "NA")]
		NA = 0,
		[HrMaxxSecurity(DbName = "Draft")]
		Draft=1,
		[HrMaxxSecurity(DbName = "Approved")]
		Submitted=2,
		[HrMaxxSecurity(DbName = "Delivered")]
		Delivered = 3,
		[HrMaxxSecurity(DbName = "Closed")]
		Paid=4,
		[HrMaxxSecurity(DbName = "Taxes Delayed")]
		OnHold=5,
		[HrMaxxSecurity(DbName = "Bounced")]
		PaymentBounced = 6,
		[HrMaxxSecurity(DbName = "Partial Payment")]
		PartialPayment = 7,
		[HrMaxxSecurity(DbName = "Deposited")]
		Deposited = 8,
		[HrMaxxSecurity(DbName = "Not Deposited")]
		NotDeposited = 9,
		[HrMaxxSecurity(DbName = "ACH Pending")]
		ACHPending = 10
		
	}

	public enum PaymentStatus
	{
		[HrMaxxSecurity(DbName = "Draft")]
		Draft = 1,
		[HrMaxxSecurity(DbName = "Submitted")]
		Submitted = 2,
		[HrMaxxSecurity(DbName = "Paid")]
		Paid = 3,
		[HrMaxxSecurity(DbName = "Bounced")]
		PaymentBounced = 4,
		[HrMaxxSecurity(DbName = "Deposited")]
		Deposited = 5
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

	public enum CompanyInvoiceType
	{
		[HrMaxxSecurity(DbName = "Host's Checks")]
		PEOASOCoCheck = 1,
		[HrMaxxSecurity(DbName = "Client Checks")]
		PEOASOClientCheck = 2,
		[HrMaxxSecurity(DbName = "Straight and Conventional Payroll")]
		ConventionalPayroll = 3,
		[HrMaxxSecurity(DbName = "Straight and Conventional Payroll with WC")]
		ConventioanlPayrollWC = 4,
		[HrMaxxSecurity(DbName = "WC Only")]
		WC = 5
	}

	public enum CompanyInvoiceStyle
	{
		NA=0,
		Summary=1,
		Detailed=2
	}

	public enum ExtractType
	{
		Federal940=1,
		Federal941=2,
		CAPITSDI=3,
		CAETTUI=4,
		Garnishment=5,
		NA=0
	}

	public enum ACHTransactionType
	{
		[HrMaxxSecurity(DbName = "PPD")]
		PPD=1,
		[HrMaxxSecurity(DbName = "CCD")]
		CCD=2
	}

	public enum ExtractAccumulationMode
	{
		All=0,
		WC=1,
		Garnishment=2
	}

}

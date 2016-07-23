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
		MICREncodedTop=1,
		LaserMiddle=2,
		LaserTop=3,
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
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class ReportResponse
	{
		public Host Host { get; set; }
		public Company Company { get; set; }
		public List<Employee> Employees { get; set; } 
		public Contact Contact { get; set; }
		public Contact CompanyContact { get; set; }
		
		public List<CompanyPayrollCube> Cubes { get; set; }

		public Accumulation CompanyAccumulations { get; set; } 
		public List<Accumulation> EmployeeAccumulationList { get; set; } 
		
		public List<CompanyVendor> VendorList { get; set; } 
		public List<PayCheck> PayChecks;
		public List<CoaTypeBalanceDetail> AccountDetails { get; set; } 
	}

	public class EmployeeAccumulation
	{
		public Employee Employee { get; set; }
		public List<PayCheck> PayChecks { get; set; } 
		public ExtractAccumulation Accumulation { get; set; }
	}

	public class EmployeePayrollAccumulation
	{
		public Employee Employee { get; set; }
		public List<PayCheck> PayChecks { get; set; }
		public PayrollAccumulation Accumulation { get; set; }
	}

	public class CompanyVendor
	{
		public VendorCustomer Vendor { get; set; }
		public decimal Amount { get; set; }
	}

	public class DailyAccumulation
	{
		public int Month { get; set; }
		public int Day { get; set; }
		public decimal Value { get; set; }
	}
	public class MonthlyAccumulation
	{
		public int Month { get; set; }
		public decimal IRS941 { get; set; }
		public decimal IRS940 { get; set; }
		public decimal EDD { get; set; }
		
	}

	public class C1095Month
	{
		public int Month { get; set; }
		public bool IsFullTime { get; set; }
		public bool IsNonNewHire { get; set; }
		public decimal Value { get; set; }
		public int Checks { get; set; }
		public string Code14 { get; set; }
		public string Code16 { get; set; }
		public bool IsEnrolled { get; set; }
	}

	public class GarnishmentAgency
	{
		public VendorCustomer Agency { get; set; }
		public List<GarnishmentAgencyAccount>  Accounts{ get; set; }
		public List<int> PayCheckIds { get; set; } 
		public decimal Total
		{
			get { return Accounts.Sum(a => a.Amount); }
		}
	}

	public class GarnishmentAgencyAccount
	{
		public string Deduction { get; set; }
		public string AccountNo { get; set; }
		public decimal Amount { get; set; }
	}

	public class CoaTypeBalanceDetail
	{
		public AccountType Type { get; set; }

		public string Text
		{
			get { return Type.GetDbName(); }
		}
		public List<CoaSubTypeBalanceDetail> SubTypeDetails { get; set; }

		public decimal Balance
		{
			get { return SubTypeDetails.Sum(st => st.Balance); }
		}
	}

	public class CoaSubTypeBalanceDetail
	{
		public AccountSubType SubType { get; set; }
		public string Text
		{
			get { return SubType.GetDbName(); }
		}
		public List<CoaBalanceDetail> AccountDetails { get; set; }

		public decimal Balance
		{
			get { return AccountDetails.Sum(ac => ac.Balance); }
		}
	}

	public class CoaBalanceDetail
	{
		public string Name { get; set; }
		public Decimal Balance { get; set; }
		
	}

}

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class ReportResponse
	{
		public Company Company { get; set; }
		public PayrollAccumulation CompanyAccumulation { get; set; }
		public List<EmployeeAccumulation> EmployeeAccumulations { get; set; }
		public List<PayCheck> PayChecks;
		public List<CoaTypeBalanceDetail> AccountDetails { get; set; } 
	}

	public class EmployeeAccumulation
	{
		public Employee Employee { get; set; }
		public List<PayCheck> PayChecks { get; set; } 
		public PayrollAccumulation Accumulation { get; set; }
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

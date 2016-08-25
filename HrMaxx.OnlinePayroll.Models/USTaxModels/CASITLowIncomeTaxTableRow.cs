﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models.USTaxModels
{
	public class CASITLowIncomeTaxTableRow
	{
		public int Id { get; set; }
		public PayrollSchedule PayrollSchedule { get; set; }
		public CAStateLowIncomeFilingStatus FilingStatus { get; set; }
		public decimal Amount { get; set; }
		public decimal? AmountIfExemptGreaterThan2 { get; set; }
		public int Year { get; set; }
	}
}
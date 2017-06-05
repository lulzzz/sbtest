﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models.USTaxModels
{
	public class CAStandardDeductionTableRow : IEquatable<CAStandardDeductionTableRow>
	{
		public int Id { get; set; }
		public PayrollSchedule PayrollSchedule { get; set; }
		public CAStateLowIncomeFilingStatus FilingStatus { get; set; }
		public decimal Amount { get; set; }
		public decimal AmountIfExemptGreaterThan1 { get; set; }
		public int Year { get; set; }
		public bool HasChanged { get; set; }

		public string PayrollScheduleText { get { return PayrollSchedule.GetHrMaxxName(); } }
		public string FilingStatusText { get { return FilingStatus.GetDbName(); } }

		public bool Equals(CAStandardDeductionTableRow other)
		{
			return this.Id == other.Id && this.PayrollSchedule == other.PayrollSchedule &&
						 this.FilingStatus == other.FilingStatus && this.Amount == other.Amount &&
						 this.AmountIfExemptGreaterThan1 == other.AmountIfExemptGreaterThan1 && this.Year == other.Year;
		}
	}
}

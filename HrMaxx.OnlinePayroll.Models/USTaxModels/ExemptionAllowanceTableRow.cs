using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models.USTaxModels
{
	public class ExemptionAllowanceTableRow : IEquatable<ExemptionAllowanceTableRow>
	{
		public int Id { get; set; }
		public PayrollSchedule PayrollSchedule { get; set; }
		public int Allowances { get; set; }
		public decimal Amount { get; set; }
		public int Year { get; set; }
		public bool HasChanged { get; set; }

		public string PayrollScheduleText { get { return PayrollSchedule.GetHrMaxxName(); } }
		public bool Equals(ExemptionAllowanceTableRow other)
		{
			return this.Id == other.Id && this.PayrollSchedule == other.PayrollSchedule && this.Allowances == other.Allowances &&
						 this.Amount == other.Amount && this.Year == other.Year;
		}
	}
}

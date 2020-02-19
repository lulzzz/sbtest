using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models.USTaxModels
{
	public class MTSITExemptionConstantTableRow : IEquatable<MTSITExemptionConstantTableRow>
	{
		public int Id { get; set; }
		public PayrollSchedule PayrollSchedule { get; set; }
		public decimal Amount { get; set; }
		public int Year { get; set; }
		public bool HasChanged { get; set; }

		public string PayrollScheduleText { get { return PayrollSchedule.GetHrMaxxName(); } }

		public bool Equals(MTSITExemptionConstantTableRow other)
		{
			return this.Id == other.Id && this.PayrollSchedule == other.PayrollSchedule && this.Year == other.Year &&
			       this.Amount == other.Amount;
		}
	}
}

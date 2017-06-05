using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models.USTaxModels
{
	public class CASITTaxTableRow : IEquatable<CASITTaxTableRow>
	{
		public int Id { get; set; }
		public PayrollSchedule PayrollSchedule { get; set; }
		public CAStateFilingStatus FilingStatus { get; set; }
		public decimal RangeStart { get; set; }
		public decimal RangeEnd { get; set; }
		public decimal FlatRate { get; set; }
		public decimal AdditionalPercentage { get; set; }
		public decimal ExcessOverAmoutt { get; set; }
		public int Year { get; set; }
		public bool HasChanged { get; set; }

		public string PayrollScheduleText { get { return PayrollSchedule.GetHrMaxxName(); } }
		public string FilingStatusText { get { return FilingStatus.GetDbName(); } }

		public bool Equals(CASITTaxTableRow other)
		{
			if (this.Id == other.Id && this.PayrollSchedule == other.PayrollSchedule && this.FilingStatus == other.FilingStatus &&
					this.RangeEnd == other.RangeEnd && this.RangeStart == other.RangeStart && this.FlatRate == other.FlatRate &&
					this.ExcessOverAmoutt == other.ExcessOverAmoutt && this.AdditionalPercentage == other.AdditionalPercentage && this.Year==other.Year)
				return true;
			return false;

		}
	}
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models.USTaxModels
{
	public class FITTaxTableRow
	{
		public int Id { get; set; }
		public PayrollSchedule PayrollSchedule { get; set; }
		public USFederalFilingStatus FilingStatus { get; set; }
		public decimal RangeStart { get; set; }
		public decimal RangeEnd { get; set; }
		public decimal FlatRate { get; set; }
		public decimal AdditionalPercentage { get; set; }
		public decimal ExcessOverAmoutt { get; set; }
		public int Year { get; set; }
	}
}

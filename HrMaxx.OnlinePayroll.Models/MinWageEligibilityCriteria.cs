using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class MinWageEligibilityCriteria
	{
		public int ContractType { get; set; }
		public int? MinEmployeeCount { get; set; }
		public int? MaxEmployeeCount { get; set; }
		public decimal? MinWage { get; set; }
		public int StatusId { get; set; }
		public string City { get; set; }
		public int PayrollYear { get; set; }
		public bool FilterHourlyEmployeeCompanies { get; set; }
	}
}

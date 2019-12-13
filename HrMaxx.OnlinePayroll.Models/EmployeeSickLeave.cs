using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class EmployeeSickLeave
	{
		public int? CompanyEmployeeNo { get; set; }
		public Guid Id { get; set; }
		public string Name { get; set; }
		public string HireDate { get; set; }
		public string SickLeaveHireDate { get; set; }
		public decimal CarryOver { get; set; }

		public List<SickLeaveAccumulation> Accumulations { get; set; } 
	}

	public class SickLeaveAccumulation
	{
		public int Id { get; set; }
		
		public int CheckNumber { get; set; }
		public string PayDay { get; set; }
        public string PayTypeName { get; set; }
		public string FiscalStart { get; set; }
		public string FiscalEnd { get; set; }
		public decimal AccumulatedValue { get; set; }
		public decimal YTDFiscal { get; set; }
		public decimal Used { get; set; }
		public decimal YTDUsed { get; set; }
		public decimal CarryOver { get; set; }
		public decimal Available { get; set; }
	}
	
}

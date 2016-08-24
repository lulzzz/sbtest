using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class CompanyPayrollCube
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public int Year { get; set; }
		public int? Quarter { get; set; }
		public int? Month { get; set; }
		public PayrollAccumulation Accumulation { get; set; }
	}
}

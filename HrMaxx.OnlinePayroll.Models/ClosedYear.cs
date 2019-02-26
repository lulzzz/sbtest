using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class ClosedYear
	{
		public int Id { get; set; }
		public int Year { get; set; }
		public string ClosedBy { get; set; }
		public DateTime ClosedOn { get; set; }
	}
}

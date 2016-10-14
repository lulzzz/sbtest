using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class DashboardData
	{
		public List<object> Data { get; set; }
	}

	public class DashboardRequest
	{
		public string Report { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public string Criteria { get; set; }
		public Guid? Host { get; set; }
		public string Role { get; set; }
	}
}

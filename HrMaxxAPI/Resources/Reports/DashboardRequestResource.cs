using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HrMaxxAPI.Resources.Reports
{
	public class DashboardRequestResource
	{
		public string Report { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public string Criteria { get; set; }
		public string ReportName { get; set; }
		
	}
}
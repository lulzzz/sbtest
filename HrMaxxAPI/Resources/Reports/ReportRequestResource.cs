using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace HrMaxxAPI.Resources.Reports
{
	public class ReportRequestResource
	{
		public string ReportName { get; set; }
		public Guid HostId { get; set; }
		public Guid CompanyId { get; set; }
		public int Year { get; set; }
		public int? Quarter { get; set; }
		public int? Month { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
	}
}
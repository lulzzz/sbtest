﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class ReportRequest
	{
		public string ReportName { get; set; }
		public Guid HostId { get; set; }
		public Guid CompanyId { get; set; }
		public int Year { get; set; }
		public int Quarter { get; set; }
		public int Month { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
	}

}
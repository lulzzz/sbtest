using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxxAPI.Resources.Journals
{
	public class ExtractPrintResource
	{
		public List<int> Journals { get; set; }
		public ReportRequest Report { get; set; }
	}
}
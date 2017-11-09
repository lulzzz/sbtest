using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.OnlinePayroll.Models.Enum;

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
		public DepositSchedule941? DepositSchedule { get; set; }
		public DateTime? DepositDate { get; set; }
		public decimal YearlyLimit { get; set; }
		public decimal QuarterlyLimit { get; set; }
		public bool IncludeHistory { get; set; }
		public bool IncludeClients { get; set; }
		public bool IncludeTaxDelayed { get; set; }
		public bool IsBatchPrinting { get; set; }
	}

	public class CommissionsReportRequestResource
	{
		public string ReportName { get; set; }
		public Guid? UserId { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public bool IncludeInactive { get; set; }
	}

	public class SearchRequest
	{
		public string Criteria { get; set; }
	}
}
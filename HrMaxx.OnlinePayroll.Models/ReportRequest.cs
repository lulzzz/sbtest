﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models.Enum;

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
		public DepositSchedule941? DepositSchedule { get; set; }
		public DateTime? DepositDate { get; set; }
		public string Description { get; set; }
		public bool AllowFiling { get; set; }
		public bool AllowExclude { get; set; }
		public bool IsBatchPrinting { get; set; }
		public bool IncludeVoids { get; set; }
		public decimal YearlyLimit { get; set; }
		public decimal QuarterlyLimit { get; set; }
		public bool IncludeHistory { get; set; }
		public bool IncludeClients { get; set; }

		public ExtractType ExtractType
		{
			get
			{
				if (ReportName.Equals("Federal940") || ReportName.Equals("Paperless940"))
					return ExtractType.Federal940;
				if (ReportName.Equals("Federal941") || ReportName.Equals("Paperless941"))
					return ExtractType.Federal941;
				if (ReportName.Equals("StateCAPIT"))
					return ExtractType.CAPITSDI;
				if (ReportName.Equals("StateCAUI"))
					return ExtractType.CAETTUI;

				return ExtractType.NA;
			}
		}
	}
	public class CommissionsReportRequest
	{
		public string ReportName { get; set; }
		public Guid? UserId { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public string Description { get; set; }
		public bool AllowFiling { get; set; }
		public bool IncludeInactive { get; set; }
	}

}

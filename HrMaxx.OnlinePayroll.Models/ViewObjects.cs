﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class HostListItem
	{
		public Guid Id { get; set; }
		public string FirmName { get; set; }
		public string Url { get; set; }
		public DateTime EffectiveDate { get; set; }
		public Guid? CompanyId { get; set; }
	}

	public class CompanyListItem
	{
		public Guid Id { get; set; }
		public Guid HostId { get; set; }
		public int CompanyNumber { get; set; }
		public string Name { get; set; }
		public string CompanyNo { get; set; }
		public DateTime? LastPayrollDate { get; set; }
		public DateTime Created { get; set; }
		public bool FileUnderHost { get; set; }
		public bool IsHostCompany { get; set; }
		public string InvoiceSetup { get; set; }
		public StatusOption StatusId { get; set; }
	}

	public class HostAndCompanies
	{
		public List<HostListItem> Hosts { get; set; }
		public List<CompanyListItem> Companies { get; set; }
	}
}
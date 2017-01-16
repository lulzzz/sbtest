using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Resources.OnlinePayroll;

namespace HrMaxxAPI.Resources.Common
{
	public class HostListItemResource
	{
		public Guid Id { get; set; }
		public string FirmName { get; set; }
		public string Url { get; set; }
		public DateTime EffectiveDate { get; set; }
		public Guid? CompanyId { get; set; }
	}

	public class CompanyListItemResource
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
		public InvoiceSetup InvoiceSetup { get; set; }
		public StatusOption StatusId { get; set; }

		public string ContractType
		{
			get { return InvoiceSetup == null ? string.Empty : InvoiceSetup.InvoiceType.GetDbName(); }
		}
		public string GetTextForStatus
		{
			get { return StatusId.GetDbName(); }
		}
	}

	public class HostAndCompaniesResource
	{
		public List<HostListItemResource> Hosts { get; set; }
		public List<CompanyListItemResource> Companies { get; set; }
	}
}
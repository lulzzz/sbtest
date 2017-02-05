﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models;
using HrMaxxAPI.Resources.Common;
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
		public Address CompanyAddress { get; set; }
		public string FederalEIN { get; set; }
		public StatusOption StatusId { get; set; }
		public List<CompanyTaxState> CompanyTaxStates { get; set; }
		public InsuranceGroupDto InsuranceGroup { get; set; }

		public string ContractType
		{
			get { return InvoiceSetup == null ? string.Empty : InvoiceSetup.InvoiceType.GetDbName(); }
		}
		public string GetTextForStatus
		{
			get { return StatusId.GetDbName(); }
		}
		public string Address
		{
			get { return CompanyAddress.AddressLine2; }
		}
		public string EIN
		{
			get { return !string.IsNullOrWhiteSpace(FederalEIN) ? string.Format("{0}-{1}", FederalEIN.Substring(0,2), FederalEIN.Substring(2)) : string.Empty; }
		}

		public string StateEIN
		{
			get { return CompanyTaxStates.Any() ? !string.IsNullOrWhiteSpace(CompanyTaxStates.First().StateEIN) ? string.Format("{0}-{1}-{2}", CompanyTaxStates.First().StateEIN.Substring(0,3), CompanyTaxStates.First().StateEIN.Substring(3,4), CompanyTaxStates.First().StateEIN.Substring(7)) : string.Empty : string.Empty; }
		}

		public string InsuranceInfo
		{
			get { return string.Format("{0} - {1}", InsuranceGroup.GroupNo, InsuranceGroup.GroupName); }

		}
		}
	

	public class HostAndCompaniesResource
	{
		public List<HostListItemResource> Hosts { get; set; }
		public List<CompanyListItemResource> Companies { get; set; }
	}
}
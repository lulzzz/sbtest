using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.DynamicData;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
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
		public int CompanyIntId { get; set; }
		public HostHomePage HomePage { get; set; }
		public Contact Contact { get; set; }
		public bool IsHostAllowsDirectDebit { get; set; }
		public bool IsPeoHost { get; set; }
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
		public DepositSchedule941 DepositSchedule { get; set; }
		public List<CompanyTaxState> CompanyTaxStates { get; set; }
		public InsuranceGroupDto InsuranceGroup { get; set; }
		public Contact Contact { get; set; } 
		public int CompanyIntId { get; set; }
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
			get { return string.Format("{0}, {1}", CompanyAddress.AddressLine1, CompanyAddress.AddressLine2); }
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
		public string SalesRep
		{
			get
			{
				return InvoiceSetup!=null && InvoiceSetup.SalesReps != null
					? InvoiceSetup.SalesReps.Aggregate(string.Empty, (current, m) => current + string.Format("{0} {1}", m.User.FirstName, m.User.LastName) + ", ")
					: string.Empty;
			}
		}

		public string Commission
		{
			get
			{
				return InvoiceSetup!=null && InvoiceSetup.SalesReps != null 
					? InvoiceSetup.SalesReps.Aggregate(string.Empty, (current, m) => current + string.Format("{0}{1}{2}", m.Method == DeductionMethod.Amount ? "$" : "", m.Rate, m.Method == DeductionMethod.Amount ? "" : "%")) :
					 
					string.Empty;
			}
		}

		public string ContactName
		{
			get { return Contact!=null ? string.Format("{0} {1}", Contact.FirstName, Contact.LastName) : string.Empty; }
		}
		public string Phone
		{
			get { return Contact != null ? !string.IsNullOrWhiteSpace(Contact.Phone) && Contact.Phone.Length > 9 ? string.Format("({0}) {1}-{2}", Contact.Phone.Substring(0, 3), Contact.Phone.Substring(3, 3), Contact.Phone.Substring(6, 4)) : !string.IsNullOrWhiteSpace(Contact.Mobile) && Contact.Mobile.Length > 9 ? string.Format("({0}) {1}-{2}", Contact.Mobile.Substring(0, 3), Contact.Mobile.Substring(3, 3), Contact.Mobile.Substring(6, 4)) : string.Empty : string.Empty; }
		}

		public bool PaysAch
		{
			get { return InvoiceSetup.PaysByAch; }
		}
		
		public decimal? UIRate { get; set; }
		public decimal? ETTRate { get; set; }
		public decimal UIRateSort { get { return UIRate.HasValue ? UIRate.Value : 0; } }
		public decimal ETTRateSort { get { return ETTRate.HasValue ? ETTRate.Value : 0; } }

		public string UIRateString { get { return UIRate.HasValue ? UIRate.ToString() : "N.A."; } }
		public string ETTRateString { get { return ETTRate.HasValue ? ETTRate.ToString() : "N.A."; } }

		public string SUIManagementRate
		{
			get { return InvoiceSetup!=null ? InvoiceSetup.SUIManagement.ToString() : "0"; }
		}
	}
	

	public class HostAndCompaniesResource
	{
		public List<HostListItemResource> Hosts { get; set; }
		public List<CompanyListItemResource> Companies { get; set; }
	}
}
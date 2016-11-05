using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Extract
	{
		public ReportRequest Report { get; set; }
		public ExtractResponse Data { get; set; }
		public FileDto File { get; set; }
	}
	public class ExtractResponse
	{
		public List<ExtractHost> Hosts { get; set; } 
	}

	public class ExtractHost
	{
		public Host Host { get; set; }
		public Company HostCompany { get; set; }
		public List<CompanyTaxState> States { get; set; }
		public Contact Contact { get; set; }
		public List<ExtractCompany> Companies { get; set; }

		public ExtractAccumulation Accumulation { get; set; }
		public List<EmployeeAccumulation> EmployeeAccumulations { get; set; }
		public VendorAccumulation VendorAccumulation { get; set; }
	}
	public class ExtractResponseDB
	{
		public List<ExtractHostDB> Hosts { get; set; } 
	}
	public class ExtractHostDB
	{
		public Guid Id { get; set; }
		public string FirmName { get; set; }
		public string PTIN { get; set; }
		public string DesigneeName940941 { get; set; }
		public string PIN940941 { get; set; }

		public ExtractDBCompany HostCompany { get; set; }
		public List<ExtractTaxState> States { get; set; }
		public List<ExtractContact> Contacts { get; set; }
		public List<ExtractDBCompany> Companies { get; set; }

	}

	public class ExtractContact
	{
		public string ContactObject { get; set; }
	}
	public class ExtractTaxState
	{
		public int Id { get; set; }
		public int CountryId { get; set; }
		public int StateId { get; set; }
		public string StateCode { get; set; }
		public string StateName { get; set; }
		public string EIN { get; set; }
		public string Pin { get; set; }
	}
	public class ExtractCompany
	{
		public Company Company { get; set; }
		public List<PayCheck> PayChecks { get; set; }
		public List<PayCheck> VoidedPayChecks { get; set; }
		public List<CompanyVendor> Vendors { get; set; }
		public ExtractAccumulation Accumulation { get; set; }
		public VendorAccumulation VendorAccumulation { get; set; }
	}

	public class VendorAccumulation
	{
		public List<VendorTypeGroup> Groups { get; set; }

		public VendorAccumulation()
		{
			Groups = new List<VendorTypeGroup>();
		}
		public void Add(IEnumerable<CompanyVendor> vendors)
		{
			var typeGroups = vendors.GroupBy(v => v.Vendor.Type1099).ToList();
			foreach (var typeGroup in typeGroups)
			{
				var tg = new VendorTypeGroup {Type = typeGroup.Key, SubTypeGroups = new List<VendorSubTypeGroup>()};
				var subTypeGroups = typeGroup.GroupBy(v => v.Vendor.SubType1099).ToList();
				foreach (var subTypeGroup in subTypeGroups)
				{
					var st = new VendorSubTypeGroup {SubType = subTypeGroup.Key, Vendors = subTypeGroup.ToList()};
					tg.SubTypeGroups.Add(st);
				}
				Groups.Add(tg);
			}

		}
		public decimal Total { get { return Groups.Sum(tg => tg.Total); } }
	}

	public class VendorTypeGroup
	{
		public F1099Type Type { get; set; }
		public List<VendorSubTypeGroup> SubTypeGroups { get; set; }

		public string TypeText
		{
			get { return Type.GetDbName(); }
		}
		public decimal Total
		{
			get { return SubTypeGroups.Sum(st=>st.Total); }
		}
	}

	public class VendorSubTypeGroup
	{
		public F1099SubType SubType { get; set; }
		public List<CompanyVendor> Vendors { get; set; }
		public string SubTypeText
		{
			get { return SubType.GetDbName(); }
		}

		public decimal Total
		{
			get { return Vendors.Sum(v => v.Amount); }
		}
	}
	public class ExtractDBCompany
	{
		public System.Guid Id { get; set; }
		public string CompanyName { get; set; }
		public string CompanyNo { get; set; }
		public int StatusId { get; set; }
		public bool IsVisibleToHost { get; set; }
		public bool FileUnderHost { get; set; }
		public bool DirectDebitPayer { get; set; }
		public int PayrollDaysInPast { get; set; }
		public int InsuranceGroupNo { get; set; }
		public string TaxFilingName { get; set; }
		public string CompanyAddress { get; set; }
		public string BusinessAddress { get; set; }
		public bool IsAddressSame { get; set; }
		public bool ManageTaxPayment { get; set; }
		public bool ManageEFileForms { get; set; }
		public string FederalEIN { get; set; }
		public string FederalPin { get; set; }
		public int DepositSchedule941 { get; set; }
		public int PayrollSchedule { get; set; }
		public int PayCheckStock { get; set; }
		public string LastModifiedBy { get; set; }
		public System.DateTime LastModified { get; set; }
		public bool IsFiler944 { get; set; }
		public bool IsHostCompany { get; set; }
		public string Memo { get; set; }
		public List<ExtractPayCheck> PayChecks { get; set; }
		public List<ExtractPayCheck> VoidedPayChecks { get; set; }
		public List<ExtractVendor> Vendors { get; set; } 
	}

	public class ExtractVendor
	{
		public Guid Id { get; set; }
		public Guid CompanyId { get; set; }
		public int StatusId { get; set; }
		public string Name { get; set; }
		public string AccountNo { get; set; }
		public bool IsVendor { get; set; }
		public string Contact { get; set; }
		public string Note { get; set; }
		public int Type1099 { get; set; }
		public int SubType1099 { get; set; }
		public int IdentifierType { get; set; }
		public string IndividualSSN { get; set; }
		public string BusinessFIN { get; set; }
		public bool IsVendor1099 { get; set; }
		public decimal Amount { get; set; }
	}



	public class ExtractPayCheck
	{
		public int Id { get; set; }
		public string Employee { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public DateTime PayDay { get; set; }

		public string Compensations { get; set; }
		public string Deductions { get; set; }
		public string PayCodes { get; set; }
		public string Taxes { get; set; }
		public int Status { get; set; }
		public bool IsVoid { get; set; }
		public decimal Salary { get; set; }
		public decimal GrossWage { get; set; }
		public decimal NetWage { get; set; }
		public int CheckNumber { get; set; }
		public int PaymentMethod { get; set; }
	}
}

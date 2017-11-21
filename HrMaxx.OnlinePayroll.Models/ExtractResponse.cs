﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using System.Xml.Xsl;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Extract
	{
		public ReportRequest Report { get; set; }
		public ExtractResponse Data { get; set; }
		public string Template { get; set; }
		public string ArgumentList { get; set; }
		public string FileName { get; set; }
		public string Extension { get; set; }
		public FileDto File { get; set; }
		
	}

	public class ACHExtract
	{
		public ReportRequest Report { get; set; }
		public ACHResponse Data { get; set; }
		public FileDto File { get; set; }
	}
	[Serializable()]
	[XmlRoot("ExtractResponse")]
	public class ExtractResponse : IDisposable
	{
		public List<ExtractHost> Hosts { get; set; }
		public List<MasterExtract> History { get; set; }
		public void Dispose()
		{
			GC.WaitForFullGCComplete();
		}

		public List<ExtractCompany> Companies { get; set; } 
	}
	public class ACHResponse
	{
		public List<ExtractHost> Hosts { get; set; }
	}

	public class ExtractHost
	{
		public Host Host { get; set; }
		public Company HostCompany { get; set; }
		public BankAccount HostBank { get; set; }
		public List<CompanyTaxState> States { get; set; }
		public Contact Contact { get; set; }
		public List<ExtractCompany> Companies { get; set; }

		public Accumulation PayCheckAccumulation { get; set; }
		public List<Accumulation> EmployeeAccumulationList { get; set; }
		public ExtractAccumulation Accumulation { get; set; }
		public List<EmployeeAccumulation> EmployeeAccumulations { get; set; }
		public VendorAccumulation VendorAccumulation { get; set; }
		public List<PayCheck> PayChecks { get; set; }
		public List<PayCheck> CredChecks { get; set; } 
		public List<Journal> Journals { get; set; }
		public List<Account> Accounts { get; set; }
		public List<ACHTransaction> ACHTransactions { get; set; }

		public string Title { get { return string.Format("{0}", HostCompany.Name); } }
		public Guid Id { get { return HostCompany.Id; } }

		 
	}
	[Serializable()]
	[XmlRoot("ExtractResponseDB")]
	public class ExtractResponseDB : IDisposable
	{
		public List<ExtractHostDB> Hosts { get; set; }
		public List<MasterExtractDB> History { get; set; }
		public void Dispose()
		{
			GC.WaitForFullGCComplete();
		}
	}
	public class ACHResponseDB
	{
		public List<ExtractHostDB> Hosts { get; set; }
	}

	public class MasterExtractDB
	{
		public string Extract { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public DateTime DepositDate { get; set; }
		
	}
	public class ExtractHostDB
	{
		public Guid Id { get; set; }
		public string FirmName { get; set; }
		public string PTIN { get; set; }
		public string DesigneeName940941 { get; set; }
		public string PIN940941 { get; set; }
		public string BankCustomerId { get; set; }

		public BankAccount HostBank { get; set; }
		public ExtractDBCompany HostCompany { get; set; }
		public List<ExtractTaxState> States { get; set; }
		public List<ExtractContact> Contacts { get; set; }
		public List<ExtractDBCompany> Companies { get; set; }
		public List<ACHTransaction> ACHTransactions { get; set; }
		
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

		public string StateEIN { get { return Crypto.Decrypt(EIN); } }
		public string StatePIN { get { return Crypto.Decrypt(Pin); } }
	}
	public class ExtractCompany
	{
		public Guid HostCompanyId { get; set; }
		public Company Company { get; set; }
		public List<PayCheck> PayChecks { get; set; }
		public List<PayCheck> VoidedPayChecks { get; set; }
		public List<CompanyVendor> Vendors { get; set; }
		public ExtractAccumulation Accumulation { get; set; }
		public List<Accumulation> EmployeeAccumulationList { get; set; } 
		public VendorAccumulation VendorAccumulation { get; set; }
		public List<EmployeeAccumulation> EmployeeAccumulations { get; set; }
		public List<ExtractInvoicePayment> Payments { get; set; }

		public Accumulation PayCheckAccumulation { get; set; }
		public Accumulation VoidedAccumulation { get; set; }

		public string Title { get { return string.Format("{0}", Company.DescriptiveName); } }
		public Guid Id { get { return Company.Id; } }
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
		public System.Guid HostId { get; set; }
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
		public string ClientNo { get; set; }
		public string InsuranceGroup { get; set; }
		public string InsuranceGroupName { get; set; }
		public Guid? ParentId { get; set; }
		public decimal MinWage { get; set; }
		public List<ExtractPayCheck> PayChecks { get; set; }
		public List<ExtractPayCheck> VoidedPayChecks { get; set; }
		public List<Accumulation> Accumulations { get; set; }
		public List<Accumulation> VoidedAccumulations { get; set; } 
		public List<ExtractVendor> Vendors { get; set; }
		public List<CompanyTaxRate> CompanyTaxRates { get; set; }
		public List<CompanyDeduction> Deductions { get; set; }
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
		public bool IsTaxDepartment { get; set; }
		public bool IsAgency { get; set; }
	}



	public class ExtractPayCheck
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public Guid EmployeeId { get; set; }
		public string Employee { get; set; }
		public DateTime StartDate { get; set; }
		public DateTime EndDate { get; set; }
		public DateTime PayDay { get; set; }
		public DateTime TaxPayDay { get; set; }

		public string Compensations { get; set; }
		public string Deductions { get; set; }
		public string PayCodes { get; set; }
		public string WorkerCompensation { get; set; }
		public string Taxes { get; set; }
		public int Status { get; set; }
		public bool IsVoid { get; set; }
		public decimal Salary { get; set; }
		public decimal GrossWage { get; set; }
		public decimal NetWage { get; set; }
		public int CheckNumber { get; set; }
		public int PaymentMethod { get; set; }
		public bool PEOASOCoCheck { get; set; }
		public bool IsReIssued { get; set; }
		public int? OriginalCheckNumber { get; set; }
		public DateTime? ReIssuedDate { get; set; }
	}

	public class ExtractInvoicePayment
	{
		public Guid CompanyId { get; set; }
		public DateTime PaymentDate { get; set; }
		public InvoicePaymentMethod Method { get; set; }
		public PaymentStatus Status { get; set; }
		public int CheckNumber { get; set; }
		public decimal Amount { get; set; }
		public Guid? InvoiceId { get; set; }
		public int PaymentId { get; set; }
	}

	public class CommissionsExtract
	{
		public CommissionsReportRequest Report { get; set; }
		public CommissionsResponse Data { get; set; }
		public FileDto File { get; set; }
	}
	public class CommissionsResponse
	{
		public List<ExtractSalesRep> SalesReps { get; set; }
	}

	public class ExtractSalesRep
	{
		public Guid UserId { get; set; }
		public string Name { get; set; }
		public List<InvoiceCommission> Commissions { get; set; }

		public decimal Commission { get { return Commissions.Sum(c => c.Commission); } }
	}

	public class InvoiceCommission
	{
		public Guid InvoiceId { get; set; }
		public decimal Commission { get; set; }
		public DateTime InvoiceDate { get; set; }
		public string CompanyName { get; set; }
		public int InvoiceNumber { get; set; }
	}
}

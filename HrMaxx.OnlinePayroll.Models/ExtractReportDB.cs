using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Dtos;

namespace HrMaxx.OnlinePayroll.Models
{

	public class ExtractReportDB
	{
		public List<ExtractDBCompany> Companies { get; set; } 
	}

	public class ExtractCompany
	{
		public Company Company { get; set; }
		public Host Host { get; set; }
		public List<Contact> Contacts { get; set; } 
		public List<PayCheck> PayChecks { get; set; }
		public List<PayCheck> VoidedPayChecks { get; set; }
		public ExtractAccumulation Accumulation { get; set; }
		public List<EmployeeAccumulation> EmployeeAccumulations { get; set; } 
	}
	public class ExtractReport
	{
		public List<ExtractCompany> Companies { get; set; } 
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
		public ExtractHost Host { get;set; }
		public List<string> Contacts { get; set; } 
		public List<ExtractPayCheck> PayChecks { get; set; }
		public List<ExtractPayCheck> VoidedPayChecks { get; set; } 
	}

	public class ExtractHost
	{
		public string FirmName { get; set; }
		public string PTIN { get; set; }
		public string DesigneeName940941 { get; set; }
		public string PIN940941 { get; set; }
		
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

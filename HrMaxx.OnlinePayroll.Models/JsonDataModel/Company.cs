using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models.DataModel;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	public class CompanyJson
	{
		public Guid Id { get; set; }
		public string CompanyName { get; set; }
		public string CompanyNo { get; set; }
		public Guid HostId { get; set; }
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
		public DateTime LastModified { get; set; }
		public bool IsFiler944 { get; set; }
		public DateTime? LastPayrollDate { get; set; }
		public decimal MinWage { get; set; }
		public bool IsHostCompany { get; set; }
		public string Memo { get; set; }
		public string ClientNo { get; set; }
		public DateTime Created { get; set; }
		public Guid? ParentId { get; set; }
		public int CompanyNumber { get; set; }
		public string Notes { get; set; }


		public List<CompanyTaxRate> CompanyTaxRates { get; set; }

		public List<CompanyTaxState> CompanyTaxStates { get; set; }

		public CompanyContract CompanyContract { get; set; }

		public List<CompanyDeduction> CompanyDeductions { get; set; }

		public List<CompanyWorkerCompensation> CompanyWorkerCompensations { get; set; }

		public List<CompanyAccumlatedPayType> CompanyAccumlatedPayTypes { get; set; }

		public List<CompanyPayCode> CompanyPayCodes { get; set; }

		public InsuranceGroup InsuranceGroup { get; set; }

		public List<CompanyJson> Locations { get; set; }
		
	}
	public class CompanyTaxRate
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public int TaxId { get; set; }
		public int TaxYear { get; set; }
		public decimal Rate { get; set; }

		public Tax Tax { get; set; }
	}

	public class Tax
	{
		public int Id { get; set; }
		public string Code { get; set; }
		public string Name { get; set; }
		public int CountryId { get; set; }
		public int? StateId { get; set; }
		public bool IsCompanySpecific { get; set; }
		public decimal? DefaultRate { get; set; }
		public string PaidBy { get; set; }
	}
	public class CompanyTaxState
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public int CountryId { get; set; }
		public int StateId { get; set; }
		public string StateCode { get; set; }
		public string StateName { get; set; }
		public string EIN { get; set; }
		public string Pin { get; set; }

		
	}
	public class CompanyContract
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public int Type { get; set; }
		public int? PrePaidSubscriptionType { get; set; }
		public int BillingType { get; set; }
		public string CardDetails { get; set; }
		public string BankDetails { get; set; }
		public decimal InvoiceRate { get; set; }
		public int Method { get; set; }
		public string InvoiceSetup { get; set; }

	}
	public class CompanyDeduction
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public int TypeId { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public decimal? AnnualMax { get; set; }
		public decimal? FloorPerCheck { get; set; }

		public DeductionType DeductionType { get; set; }
		
	}
	public class DeductionType
	{
		public int Id { get; set; }
		public string Name { get; set; }
		public int Category { get; set; }
		public string W2_12 { get; set; }
		public string W2_13R { get; set; }
		public string R940_R { get; set; }

		
	}
	public class CompanyWorkerCompensation
	{
		
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public int Code { get; set; }
		public string Description { get; set; }
		public decimal Rate { get; set; }
		public decimal? MinGrossWage { get; set; }

		
	}
	public class CompanyAccumlatedPayType
	{
		public int Id { get; set; }
		public int PayTypeId { get; set; }
		public Guid CompanyId { get; set; }
		public decimal RatePerHour { get; set; }
		public decimal AnnualLimit { get; set; }
		public bool CompanyManaged { get; set; }

		
		public PayType PayType { get; set; }
	}
	public class PayType
	{
		
		public int Id { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsTaxable { get; set; }
		public bool IsAccumulable { get; set; }

	}
	public class InsuranceGroup
	{
		
		public int Id { get; set; }
		public string GroupNo { get; set; }
		public string GroupName { get; set; }

		
	}

	public class CompanyPayCode
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public decimal HourlyRate { get; set; }

	}
}

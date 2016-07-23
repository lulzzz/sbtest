using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Company : BaseEntityDto
	{
		public Guid HostId { get; set; }
		public string Name { get; set; }
		public string CompanyNo { get; set; }
		public Address CompanyAddress { get; set; }
		public bool IsVisibleToHost { get; set; }
		public StatusOption StatusId { get; set; }
		public bool FileUnderHost { get; set; }

		//Payroll fields
		public int PayrollDaysInPast { get; set; }
		public bool DirectDebitPayer { get; set; }
		public PayCheckStock PayCheckStock { get; set; }
		public int InsuranceGroupNo { get; set; }
		public PayrollSchedule PayrollSchedule { get; set; }
		//Tax Setup
		public string TaxFilingName { get; set; }
		public bool IsAddressSame { get; set; }
		public Address BusinessAddress { get; set; }
		public bool AllowTaxPayments { get; set; }
		public bool AllowEFileFormFiling { get; set; }
		public string FederalEIN { get; set; }
		public string FederalPin { get; set; }
		public DepostiSchedule941 DepositSchedule { get; set; }
		public bool IsFiler944 { get; set; }
		
		public List<CompanyTaxState> States { get; set; }
		public List<AccumulatedPayType> AccumulatedPayTypes { get; set; }
		public List<CompanyDeduction> Deductions { get; set; }
		public List<CompanyWorkerCompensation> WorkerCompensations { get; set; }
		public ContractDetails Contract { get; set; }
		public List<CompanyTaxRate> CompanyTaxRates { get; set; }
		public List<CompanyPayCode> PayCodes { get; set; } 
	}

	public class ContractDetails
	{
		public ContractOption ContractOption { get; set; }
		public PrePaidSubscriptionOption PrePaidSubscriptionOption { get; set; }
		public BankAccount BankDetails { get; set; }
		public BillingOptions BillingOption { get; set; }
		public CreditCard CreditCardDetails { get; set; }
		public decimal InvoiceCharge { get; set; }
	}

	public class CreditCard
	{
		public string CardType { get; set; }
		public string CardNumber { get; set; }
		public string CardName { get; set; }
		public string ExpiryMonth { get; set; }
		public string ExpiryYear { get; set; }
		public string SecurityCode { get; set; }
		public Address BillingAddress { get; set; }
	}

	public class CompanyWorkerCompensation
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public int Code { get; set; }
		public decimal Rate { get; set; }
		public string Description { get; set; }
	}

	public class CompanyDeduction
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public DeductionType Type { get; set; }
		public string DeductionName { get; set; }
		public string Description { get; set; }
		public decimal AnnualMax { get; set; }
		public string W2_12 { get; set; }
		public string W2_13R { get; set; }
		public string R940_R { get; set; }
		
	}

	public class AccumulatedPayType
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public PayType PayType { get; set; }
		public decimal RatePerHour { get; set; }
		public decimal AnnualLimit { get; set; }
	}

	public class CompanyTaxState
	{
		public int Id { get; set; }
		public int CountryId { get; set; }
		public State State { get; set; }
		public string StateEIN { get; set; }
		public string StatePIN { get; set; }
	}

	public class CompanyTaxRate
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public int TaxId { get; set; }
		public string TaxCode { get; set; }
		public int TaxYear { get; set; }
		public Decimal Rate { get; set; }
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

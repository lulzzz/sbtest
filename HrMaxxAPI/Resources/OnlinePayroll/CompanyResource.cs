using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Attributes;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxxAPI.Resources.Common;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class CompanyResource : BaseRestResource
	{
		[Required]
		public Guid HostId { get; set; }
		[Required]
		public string Name { get; set; }
		[Required]
		public string CompanyNo { get; set; }
		[Required]
		public AddressResource CompanyAddress { get; set; }
		public bool IsVisibleToHost { get; set; }
		public StatusOption StatusId { get; set; }
		public bool FileUnderHost { get; set; }

		//Payroll fields
		[Required]
		public int PayrollDaysInPast { get; set; }
		public bool DirectDebitPayer { get; set; }
		public PayCheckStock PayCheckStock { get; set; }
		public int InsuranceGroupNo { get; set; }
		public PayrollSchedule PayrollSchedule { get; set; }
		//Tax Setup
		[Required]
		public string TaxFilingName { get; set; }
		[Required]
		public bool IsAddressSame { get; set; }
		[Required]
		public AddressResource BusinessAddress { get; set; }
		public bool AllowTaxPayments { get; set; }
		public bool AllowEFileFormFiling { get; set; }
		[Required]
		public string FederalEIN { get; set; }
		[Required]
		public string FederalPin { get; set; }
		public bool isFiler944 { get; set; }
		public DepostiSchedule941 DepositSchedule { get; set; }

		public DateTime? LastPayrollDate { get; set; }

		public List<CompanyTaxStateResource> States { get; set; }
		public List<CompanyTaxRateResource> CompanyTaxRates { get; set; } 
		public List<AccumulatedPayTypeResource> AccumulatedPayTypes { get; set; }
		public List<CompanyDeductionResource> Deductions { get; set; }
		public List<CompanyWorkerCompensationResource> WorkerCompensations { get; set; }
		public ContractDetailsResource Contract { get; set; }
		public List<CompanyPayCodeResource> PayCodes { get; set; } 

		public string GetTextForStatus
		{
			get { return StatusId.GetDbName(); }
		}
		
	}
	public class ContractDetailsResource
	{
		[Required]
		public ContractOption ContractOption { get; set; }
		[Required]
		public BillingOptions BillingOption { get; set; }
		public PrePaidSubscriptionOption? PrePaidSubscriptionOption { get; set; }
		public CreditCardResource CreditCardDetails { get; set; }
		public BankAccountResource BankDetails { get; set; }
		public decimal InvoiceCharge { get; set; }
	}

	public class CreditCardResource
	{
		[Required]
		public string CardType { get; set; }
		[Required]
		public string CardNumber { get; set; }
		[Required]
		public string CardName { get; set; }
		[Required]
		public string ExpiryMonth { get; set; }
		[Required]
		public string ExpiryYear { get; set; }
		[Required]
		public string SecurityCode { get; set; }
		[Required]
		public AddressResource BillingAddress { get; set; }
	}

	public class CompanyWorkerCompensationResource 
	{
		public int? Id { get; set; }
		public Guid CompanyId { get; set; }
		public int Code { get; set; }
		public decimal Rate { get; set; }
		public string Description { get; set; }
	}

	public class CompanyDeductionResource
	{
		public int? Id { get; set; }
		public Guid CompanyId { get; set; }
		public DeductionType Type { get; set; }
		public string DeductionName { get; set; }
		public string Description { get; set; }
		public decimal AnnualMax { get; set; }
		public string W2_12 { get; set; }
		public string W2_13R { get; set; }
		public string R940_R { get; set; }

	}

	public class AccumulatedPayTypeResource
	{
		public int? Id { get; set; }
		[Required]
		public Guid CompanyId { get; set; }
		[Required]
		public PayType PayType { get; set; }
		[Required]
		public decimal RatePerHour { get; set; }
		[Required]
		public decimal AnnualLimit { get; set; }
	}

	public class CompanyTaxStateResource
	{
		public int? Id { get; set; }
		[Required]
		public State State { get; set; }
		[Required]
		public string StateEIN { get; set; }
		[Required]
		public string StatePin { get; set; }
	}

	public class CompanyTaxRateResource
	{
		public int? Id { get; set; }
		public int TaxId { get; set; }
		public Guid? CompanyId { get; set; }
		public string TaxCode { get; set; }
		public int TaxYear { get; set; }
		public Decimal Rate { get; set; }
	}

	public class CompanyPayCodeResource
	{
		public int? Id { get; set; }
		[Required]
		public Guid CompanyId { get; set; }
		[Required]
		public string Code { get; set; }
		[Required]
		public string Description { get; set; }
		[Required]
		public decimal HourlyRate { get; set; }

		public string DropDownDisplay
		{
			get { return string.Format("{0}:{1} ({2} per hour)", Code, Description, HourlyRate.ToString("c")); }
		}
	}
}
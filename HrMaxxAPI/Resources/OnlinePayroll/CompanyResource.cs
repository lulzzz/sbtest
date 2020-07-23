using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
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
		public int CompanyIntId { get; set; }
		
		public string CompanyNo { get; set; }
		
		[Required]
		public AddressResource CompanyAddress { get; set; }
		public bool IsVisibleToHost { get; set; }
		public StatusOption StatusId { get; set; }
		public bool FileUnderHost { get; set; }
		public bool IsHostCompany { get; set; }
		//Payroll fields
		[Required]
		public int PayrollDaysInPast { get; set; }
		public bool DirectDebitPayer { get; set; }
		public bool ProfitStarsPayer { get; set; }
		public PayCheckStock PayCheckStock { get; set; }
		public int InsuranceGroupNo { get; set; }
		public PayrollSchedule PayrollSchedule { get; set; }
		public PayrollScheduleSubType PayrollScheduleDay { get; set; }
		public decimal? MinWage { get; set; }
		public string Memo { get; set; }
		public string DashboardNotes { get; set; }
		public string Notes { get; set; }
		public string PayrollMessage { get; set; }
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
		
		public string FederalPin { get; set; }
		public bool isFiler944 { get; set; }
		public bool IsFiler1095 { get; set; }
		public string ControlId { get; set; }
		public DepositSchedule941 DepositSchedule { get; set; }

		public DateTime? LastPayrollDate { get; set; }
		public DateTime? Created { get; set; }
		public bool IsRestaurant { get; set; }
		public decimal SalesTaxRate { get; set; }
		public string InsuranceClientNo { get; set; }
		public InsuranceGroupDto InsuranceGroup { get; set; }
		public Contact Contact { get; set; }

		public List<CompanyRecurringCharge> RecurringCharges { get; set; } 
		public List<CompanyTaxStateResource> States { get; set; }
		public List<CompanyTaxRateResource> CompanyTaxRates { get; set; } 
		public List<AccumulatedPayTypeResource> AccumulatedPayTypes { get; set; }
		public List<CompanyDeductionResource> Deductions { get; set; }
		public List<CompanyWorkerCompensationResource> WorkerCompensations { get; set; }
		public ContractDetailsResource Contract { get; set; }
		public List<CompanyPayCodeResource> PayCodes { get; set; }
		public List<CompanyRenewal> CompanyRenewals { get; set; }
		public List<CompanyProject> CompanyProjects { get; set; }
		public List<CompanyLocation> Locations { get; set; } 
		public Guid? ParentId { get; set; }

		public bool IsLocation { get; set; }
		public bool HasLocations { get; set; }
		public CompanyCheckPrintOrder CompanyCheckPrintOrder { get; set; }

		public string GetTextForStatus
		{
			get { return StatusId.GetDbName(); }
		}

		public bool HasCalifornia
		{
			get { return States.Any(s => s.State.StateId == 1); }
		}

		public string ContractType
		{
			get { return Contract.InvoiceSetup==null ? string.Empty : Contract.InvoiceSetup.InvoiceType.GetDbName(); }
		}

		public string TaxDepositFrequency
		{
			get { return DepositSchedule.GetDbName(); }
		}
		public bool UpdateEmployeeSchedules { get; set; }
		
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
		public int Method { get; set; }
		public InvoiceSetupResource InvoiceSetup { get; set; }
		public bool DirectDeposit { get; set; }
		public bool ProfitStarsPayer { get; set; }
		public bool Timesheets { get; set; }
		public bool CertifiedPayrolls { get; set; }
		public bool RestaurantPayrolls { get; set; }
		public bool Payrolls { get; set; }
		public bool Bookkeeping { get; set; }
		public bool Invoicing { get; set; }
		public bool Taxation { get; set; }
	}

	public class CreditCardResource
	{
		[Required]
		public int CardType { get; set; }
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

		public int CardTypeInt => CardType == null ? 0 : CardType;
	}

	public class CompanyWorkerCompensationResource 
	{
		public int? Id { get; set; }
		public Guid CompanyId { get; set; }
		public int Code { get; set; }
		public decimal Rate { get; set; }
		public string Description { get; set; }
		public decimal? MinGrossWage { get; set; }
	}

	public class CompanyDeductionResource
	{
		public int? Id { get; set; }
		[Required]
		public Guid CompanyId { get; set; }
		[Required]
		public DeductionType Type { get; set; }
		[Required]
		public string DeductionName { get; set; }
		[Required]
		public string Description { get; set; }
		public decimal? FloorPerCheck { get; set; }
		public bool ApplyInvoiceCredit { get; set; }
		public decimal? AnnualMax { get; set; }
		public string W2_12 { get; set; }
		public string W2_13R { get; set; }
		public string R940_R { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public decimal EmployeeWithheld { get; set; }
        public decimal EmployerWithheld { get; set; }
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
        public decimal? GlobalLimit { get; set; }
		public bool CompanyManaged { get; set; }
		public bool IsLumpSum { get; set; }
		public bool IsEmployeeSpecific { get; set; }
		public AccumulatedPayTypeOption Option { get; set; }
		public string Name { get; set; }
	}

	public class CompanyTaxStateResource
	{
		public int? Id { get; set; }
		[Required]
		public State State { get; set; }
		[Required]
		public string StateEIN { get; set; }
		public string StatePin { get; set; }
        public string StateUIAccount { get; set; }
		public DepositSchedule941 DepositSchedule { get; set; }
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
		[Required]
		public PayCodeRateType RateType { get; set; }
		
		public string DropDownDisplay
		{
			get { return $"{Code}:{Description} ({(RateType == PayCodeRateType.Flat ? (HourlyRate.ToString("c") + " per hour") : (HourlyRate.ToString() + " x default rate"))})"; }
				
		}
	}
	
	public class CompanyLocationResource
	{
		public Guid Id { get; set; }
		public string Name { get; set; }
		public Address Address { get; set; }
		public Guid ParentId { get; set; }
	}

	public class InvoiceSetupResource
	{
		[Required]
		public CompanyInvoiceType InvoiceType { get; set; }
		[Required]
		public CompanyInvoiceStyle InvoiceStyle { get; set; }
		[Required]
		public int AdminFeeMethod { get; set; }
		[Required]
		public decimal AdminFee { get; set; }
		public decimal? AdminFeeThreshold { get; set; }
		public decimal SUIManagement { get; set; }
		public bool ApplyStatuaryLimits { get; set; }
		public bool ApplyEnvironmentalFee { get; set; }
		public bool ApplyWCCharge { get; set; }
		public bool PrintClientName { get; set; }
		public bool PaysByAch { get; set; }
		public List<RecurringChargeResource> RecurringCharges { get; set; }
		public List<SalesRepResource> SalesReps { get; set; } 
		public SalesRepResource SalesRep { get; set; }
	}
	

	public class RecurringChargeResource
	{
		public int? Id { get; set; }
		public int TableId { get; set; }
		public int? Year { get; set; }
		[Required]
		public decimal Amount { get; set; }
		public decimal? AnnualLimit { get; set; }
		[Required]
		public string Description { get; set; }
	}
	public class SalesRepResource
	{
		[Required]
		public UserModel User { get; set; }
		[Required]
		public DeductionMethod Method { get; set; }
		[Required]
		public decimal Rate { get; set; }
	}

}
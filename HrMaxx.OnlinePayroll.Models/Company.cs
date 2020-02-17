using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Company : BaseEntityDto, IOriginator<Company>
	{
		public int CompanyIntId { get; set; }
		public Guid HostId { get; set; }
		public string Name { get; set; }
		public string CompanyNo { get; set; }
		
		public Address CompanyAddress { get; set; }
		public bool IsVisibleToHost { get; set; }
		public StatusOption StatusId { get; set; }
		public bool FileUnderHost { get; set; }
		public bool IsHostCompany { get; set; }
		//Payroll fields
		public int PayrollDaysInPast { get; set; }
		public bool DirectDebitPayer { get; set; }
		public bool ProfitStarsPayer { get; set; }
		public PayCheckStock PayCheckStock { get; set; }
		public int InsuranceGroupNo { get; set; }
		public PayrollSchedule PayrollSchedule { get; set; }
		public PayrollScheduleSubType PayrollScheduleDay { get; set; }
		public decimal? MinWage { get; set; }
		public string Memo { get; set; }
		public string Notes { get; set; }
		public string DashboardNotes { get; set; }
		public string PayrollMessage { get; set; }
		//Tax Setup
		public string TaxFilingName { get; set; }
		public bool IsAddressSame { get; set; }
		public Address BusinessAddress { get; set; }
		public bool AllowTaxPayments { get; set; }
		public bool AllowEFileFormFiling { get; set; }
		public string FederalEIN { get; set; }
		public string FederalPin { get; set; }
		public DepositSchedule941 DepositSchedule { get; set; }
		public bool IsFiler944 { get; set; }
		public bool IsFiler1095 { get; set; }
		public string ControlId { get; set; }
		public DateTime? LastPayrollDate { get; set; }
		public CompanyCheckPrintOrder CompanyCheckPrintOrder { get; set; }
		public bool IsRestaurant { get; set; }
		public string InsuranceClientNo { get; set; }
		public InsuranceGroupDto InsuranceGroup { get; set; }
		public Contact Contact { get; set; }

		public List<CompanyRecurringCharge> RecurringCharges { get; set; } 
		public List<CompanyTaxState> States { get; set; }
		public List<AccumulatedPayType> AccumulatedPayTypes { get; set; }
		public List<CompanyDeduction> Deductions { get; set; }
		public List<CompanyWorkerCompensation> WorkerCompensations { get; set; }
		public ContractDetails Contract { get; set; }
		public List<CompanyTaxRate> CompanyTaxRates { get; set; }
		public List<CompanyPayCode> PayCodes { get; set; }
		public DateTime Created { get; set; }
		public Guid? ParentId { get; set; }
		public bool HasLocations { get; set; }
		public string DescriptiveName
		{
			get
			{
				if (FileUnderHost && !IsHostCompany)
					return string.Format("{0} (Leasing)", Name);
				else
				{
					return Name;
				}

			}
		}

		public bool IsLocation
		{
			get { return ParentId.HasValue; }
		}

		public List<CompanyLocation> Locations { get; set; } 

		public Guid MementoId
		{
			get { return Id; }
		}

		public void ApplyMemento(Memento<Company> memento)
		{
			throw new NotImplementedException();
		}

		public string GetSearchText
		{
			get
			{
				var searchText = string.Empty;
				searchText += Name + ", EIN:" + FederalEIN + ". ";
				if (!string.IsNullOrWhiteSpace(CompanyNo))
					searchText += "Company#:" + CompanyNo + ". ";
				if (States != null)
				{
					var sts = States.Aggregate(string.Empty, (current, m) => current + string.Format("{0}:{1}", m.State.Abbreviation, m.StateEIN) + ", ");
					searchText += sts;
				}
				return searchText;
			}
		}
	}

	public class ContractDetails
	{
		public ContractOption ContractOption { get; set; }
		public PrePaidSubscriptionOption PrePaidSubscriptionOption { get; set; }
		public BankAccount BankDetails { get; set; }
		public BillingOptions BillingOption { get; set; }
		public CreditCard CreditCardDetails { get; set; }
		public decimal InvoiceCharge { get; set; }
		public int Method { get; set; }
		public InvoiceSetup InvoiceSetup { get; set; }
	}

	public class CreditCard
	{
		public int? CardType { get; set; }
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
		public decimal? MinGrossWage { get; set; }
	}

	public class CompanyDeduction
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public DeductionType Type { get; set; }
		public DeductionType DeductionType { get; set; }
		public decimal? FloorPerCheck { get; set; }
		public bool ApplyInvoiceCredit { get; set; }
		public string DeductionName { get; set; }
		public string Description { get; set; }
		public decimal? AnnualMax { get; set; }
		public string W2_12 { get; set; }
		public string W2_13R { get; set; }
		public string R940_R { get; set; }

		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public decimal EmployeeWithheld { get; set; }
        public decimal EmployerWithheld { get; set; }

    }

	public class AccumulatedPayType
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public PayType PayType { get; set; }
		public decimal RatePerHour { get; set; }
		public decimal AnnualLimit { get; set; }
        public decimal? GlobalLimit { get; set; }
		public bool CompanyManaged { get; set; }
		public bool IsLumpSum { get; set; }
		public bool IsEmployeeSpecific { get; set; }
		public AccumulatedPayTypeOption Option { get; set; }
	}

	public class CompanyTaxState
	{
		public int Id { get; set; }
		public int CountryId { get; set; }
		public State State { get; set; }
		public string StateEIN { get; set; }
		public string StatePIN { get; set; }
        public string StateUIAccount { get; set; }
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
		public PayCodeRateType RateType { get; set; }
		
	}

	public class CompanyLocation
	{
		public Guid Id { get; set; }
		public string Name { get; set; }
		public Address Address { get; set; }
		public Guid ParentId { get; set; }
	}

	public class InvoiceSetup
	{
		public CompanyInvoiceType InvoiceType { get; set; }
		public CompanyInvoiceStyle InvoiceStyle { get; set; }
		public int AdminFeeMethod { get; set; }
		public decimal? AdminFeeThreshold { get; set; }
		public decimal AdminFee { get; set; }
		public decimal SUIManagement { get; set; }
		public bool ApplyStatuaryLimits { get; set; }
		public bool ApplyEnvironmentalFee { get; set; }
		public bool ApplyWCCharge { get; set; }
		public bool PrintClientName { get; set; }
		public bool PaysByAch { get; set; }
		public List<RecurringCharge> RecurringCharges { get; set; }
		public SalesRep SalesRep { get; set; } 
	}

	public class SalesRep
	{
		public UserModel User { get; set; }
		public DeductionMethod Method { get; set; }
		public decimal Rate { get; set; }
	}

	public class RecurringCharge
	{
		public int Id { get; set; }
		public int TableId { get; set; }
		public int? Year { get; set; }
		public decimal Amount { get; set; }
		public decimal? AnnualLimit { get; set; }
		public string Description { get; set; }
	}
	public class CompanyRecurringCharge
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public int OldId { get; set; }
		public int? Year { get; set; }
		public decimal Amount { get; set; }
		public decimal? AnnualLimit { get; set; }
		public string Description { get; set; }
		public decimal Claimed { get; set; }
		public bool IsPaidInFull { get; set; }
		public string Comments { get; set; }
	}

}

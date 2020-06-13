﻿using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	[Serializable]
	[XmlRoot("CompanyList")]
	public class CompanyJson
	{
		public Guid Id { get; set; }
		public int CompanyIntId { get; set; }
		public string CompanyName { get; set; }
		public string CompanyNo { get; set; }
		public Guid HostId { get; set; }
		public int StatusId { get; set; }
		public bool IsVisibleToHost { get; set; }
		public bool FileUnderHost { get; set; }
		public bool DirectDebitPayer { get; set; }
		public bool ProfitStarsPayer { get; set; }
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
		public int PayrollScheduleDay { get; set; }
		public int PayCheckStock { get; set; }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
		public bool IsFiler944 { get; set; }
		public bool IsFiler1095 { get; set; }
		public string ControlId { get; set; }
		public DateTime? LastPayrollDate { get; set; }
		public decimal? MinWage { get; set; }
		public bool IsHostCompany { get; set; }
		public string Memo { get; set; }
		public string ClientNo { get; set; }
		public DateTime Created { get; set; }
		public Guid? ParentId { get; set; }
		public int CompanyCheckPrintOrder { get; set; }
		
		public string Notes { get; set; }
		
		public string DashboardNotes { get; set; }
		public string PayrollMessage { get; set; }
		public string Contact { get; set; }
		public bool HasLocations { get; set; }

		public bool IsRestaurant { get; set; }

		public List<CompanyTaxRate> CompanyTaxRates { get; set; }

		public List<CompanyRecurringCharge> RecurringCharges { get; set; } 

		public List<CompanyTaxState> CompanyTaxStates { get; set; }

		public CompanyContract CompanyContract { get; set; }

		public List<CompanyDeduction> CompanyDeductions { get; set; }

		public List<CompanyWorkerCompensation> CompanyWorkerCompensations { get; set; }

		public List<CompanyAccumlatedPayType> CompanyAccumlatedPayTypes { get; set; }

		public List<CompanyPayCode> CompanyPayCodes { get; set; }
		public List<CompanyRenewal> CompanyRenewals { get; set; }
		public List<CompanyProject> CompanyProjects { get; set; }
		public InsuranceGroup InsuranceGroup { get; set; }

		public List<CompanyJson> Locations { get; set; }
		
	}

	public class CompanyProject
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public string ProjectId { get; set; }
		public string ProjectName { get; set; }
		public string AwardingBody { get; set; }
		public string RegistrationNo { get; set; }
		public string LicenseNo { get; set; }
		public string LicenseType { get; set; }
		public string PolicyNo { get; set; }
		public string Classification { get; set; }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
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
        public string UIAccountNumber { get; set; }
		public int DepositSchedule { get; set; }
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
		public bool DirectDeposit { get; set; }
		public bool ProfitStarsPayer { get; set; }
		public bool Timesheets { get; set; }
		public bool CertifiedPayrolls { get; set; }
		public bool RestaurantPayrolls { get; set; }
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
		public bool ApplyInvoiceCredit { get; set; }
		public DeductionType DeductionType { get; set; }

		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
		public decimal EmployeeWithheld { get; set; }
        public decimal EmployerWithheld { get; set; }
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
        public decimal GlobalLimit { get; set; }
		public bool CompanyManaged { get; set; }
		public bool IsLumpSum { get; set; }
		public bool IsEmployeeSpecific { get; set; }
		public PayType PayType { get; set; }
		public int Option { get; set; }
		public string Name { get; set; }
	}
	
	public class PayType
	{
		
		public int Id { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsTaxable { get; set; }
		public bool IsAccumulable { get; set; }
		public bool IsTip { get; set; }
		public bool PaidInCash { get; set; }
	}
	public class InsuranceGroup
	{
		
		public int Id { get; set; }
		public string GroupNo { get; set; }
		public string GroupName { get; set; }

		
	}
	public class CompanyRenewal
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public string Description { get; set; }
		public int Month { get; set; }
		public int Day { get; set; }
		public int ReminderDays { get; set; }
		public DateTime? LastRenewed { get; set; }
		public string LastRenewedBy { get; set; }
	}
	
	public class CompanyPayCode
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public decimal HourlyRate { get; set; }
		public int RateType { get; set; }
		
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

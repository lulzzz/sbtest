using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using Newtonsoft.Json;
using BankAccount = HrMaxx.OnlinePayroll.Models.BankAccount;
using CompanyDeduction = HrMaxx.OnlinePayroll.Models.CompanyDeduction;
using CompanyPayCode = HrMaxx.OnlinePayroll.Models.CompanyPayCode;
using CompanyWorkerCompensation = HrMaxx.OnlinePayroll.Models.CompanyWorkerCompensation;
using DeductionType = HrMaxx.OnlinePayroll.Models.DeductionType;
using PayType = HrMaxx.OnlinePayroll.Models.PayType;


namespace HrMaxx.OnlinePayroll.ReadServices.Mappers
{
	public class OnlinePayrollJsonModelMapperProfile : ProfileLazy
	{
		public OnlinePayrollJsonModelMapperProfile(Lazy<IMappingEngine> mapper) : base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();

			CreateMap<Models.JsonDataModel.InsuranceGroup, Common.Models.InsuranceGroupDto>();
			CreateMap<Models.JsonDataModel.Host, Models.Host>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.FirmName, opt => opt.MapFrom(src => src.FirmName))
				.ForMember(dest => dest.Url, opt => opt.MapFrom(src => src.Url))
				.ForMember(dest => dest.EffectiveDate, opt => opt.MapFrom(src => src.EffectiveDate))
				.ForMember(dest => dest.TerminationDate, opt => opt.MapFrom(src => src.TerminationDate))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => src.StatusId))
				.ForMember(dest => dest.CompanyId, opt => opt.MapFrom(src => src.CompanyId))
				.ForMember(dest => dest.Company, opt => opt.MapFrom(src => src.Company))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.HomePage, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.HomePage) ? JsonConvert.DeserializeObject<HostHomePage>(src.HomePage) : null))
				.ForMember(dest => dest.UserId, opt => opt.Ignore());

			CreateMap<Models.JsonDataModel.CompanyContract, Models.ContractDetails>()
				.ForMember(dest => dest.BillingOption, opt => opt.MapFrom(src => src.BillingType))
				.ForMember(dest => dest.ContractOption, opt => opt.MapFrom(src => src.Type))
				.ForMember(dest => dest.CreditCardDetails,
				opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.CardDetails) ? JsonConvert.DeserializeObject<CreditCard>(src.CardDetails) : null))
				.ForMember(dest => dest.InvoiceCharge, opt => opt.MapFrom(src => src.InvoiceRate))
				.ForMember(dest => dest.PrePaidSubscriptionOption, opt => opt.MapFrom(src => src.PrePaidSubscriptionType.HasValue ? (PrePaidSubscriptionOption)src.PrePaidSubscriptionType.Value : PrePaidSubscriptionOption.NA))
				.ForMember(dest => dest.BankDetails,
				opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.BankDetails) ? JsonConvert.DeserializeObject<BankAccount>(src.BankDetails) : null))
				.ForMember(dest => dest.InvoiceSetup,
				opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.InvoiceSetup) ? JsonConvert.DeserializeObject<InvoiceSetup>(src.InvoiceSetup) : null));

			CreateMap<Models.JsonDataModel.CompanyTaxRate, Models.CompanyTaxRate>()
				.ForMember(dest => dest.TaxCode, opt => opt.MapFrom(src => src.Tax.Code));

			CreateMap<Models.JsonDataModel.CompanyJson, Models.CompanyLocation>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.ParentId, opt => opt.MapFrom(src => src.ParentId))
				.ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.CompanyName))
				.ForMember(dest => dest.Address, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Address>(src.CompanyAddress)));

			CreateMap<Models.JsonDataModel.CompanyRecurringCharge, Models.CompanyRecurringCharge>();
			CreateMap<Models.CompanyRecurringCharge, Models.JsonDataModel.CompanyRecurringCharge>();

			CreateMap<Models.JsonDataModel.CompanyTaxState, Models.CompanyTaxState>()
				.ForMember(dest => dest.State, opt => opt.MapFrom(src => src))
				.ForMember(dest => dest.StateEIN, opt => opt.MapFrom(src => Crypto.Decrypt(src.EIN)))
                .ForMember(dest => dest.StateUIAccount, opt => opt.MapFrom(src => src.UIAccountNumber))
                .ForMember(dest => dest.StatePIN, opt => opt.MapFrom(src => Crypto.Decrypt(src.Pin)));


			CreateMap<Models.JsonDataModel.CompanyJson, Models.CompanyLocation>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.ParentId, opt => opt.MapFrom(src => src.ParentId))
				.ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.CompanyName))
				.ForMember(dest => dest.Address, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Address>(src.CompanyAddress)));

			CreateMap<Models.JsonDataModel.CompanyTaxState, State>()
				.ForMember(dest => dest.Abbreviation, opt => opt.MapFrom(src => src.StateCode))
				.ForMember(dest => dest.TaxesEnabled, opt => opt.Ignore())
				.ForMember(dest => dest.HasCounties, opt => opt.Ignore())
                .ForMember(dest => dest.UiFormat, opt => opt.Ignore())
                .ForMember(dest => dest.EinFormat, opt => opt.Ignore())
				.ForMember(dest => dest.StateId, opt => opt.MapFrom(src => src.StateId))
				.ForMember(dest => dest.StateName, opt => opt.MapFrom(src => src.StateName));

			CreateMap<Models.JsonDataModel.DeductionType, DeductionType>()
				.ForMember(dest => dest.W2_13rVal, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.W2_13R) && src.W2_13R == "1")); 
			CreateMap<DeductionType, Models.DataModel.DeductionType>()
				.ForMember(dest => dest.W2_13R, opt => opt.MapFrom(src => src.W2_13rVal ? "1" : "0"))
				.ForMember(dest => dest.CompanyDeductions, opt => opt.Ignore());

			CreateMap<Models.JsonDataModel.CompanyDeduction, CompanyDeduction>()
				.ForMember(dest => dest.AnnualMax, opt => opt.MapFrom(src => src.AnnualMax))
				.ForMember(dest => dest.DeductionName, opt => opt.MapFrom(src => src.Name))
				.ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Description))
				.ForMember(dest => dest.Type, opt => opt.MapFrom(src => src.DeductionType))
				.ForMember(dest => dest.W2_12, opt => opt.MapFrom(src => src.DeductionType.W2_12))
				.ForMember(dest => dest.W2_13R, opt => opt.MapFrom(src => src.DeductionType.W2_13R))
				.ForMember(dest => dest.R940_R, opt => opt.MapFrom(src => src.DeductionType.R940_R));

			
			CreateMap<Models.JsonDataModel.CompanyWorkerCompensation, CompanyWorkerCompensation>();
			CreateMap<Models.JsonDataModel.PayType, PayType>();

			CreateMap<Models.JsonDataModel.CompanyAccumlatedPayType, AccumulatedPayType>()
				.ForMember(dest => dest.PayType, opt => opt.MapFrom(src => src.PayType));

			CreateMap<Models.JsonDataModel.CompanyPayCode, CompanyPayCode>();
			CreateMap<Models.JsonDataModel.CompanyRenewal, Models.CompanyRenewal>();

			CreateMap<Models.JsonDataModel.PayrollInvoiceJson, Models.PayrollInvoice>()
				.ForMember(dest => dest.EmployerTaxes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollTax>>(src.EmployerTaxes)))
				.ForMember(dest => dest.EmployeeTaxes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollTax>>(src.EmployeeTaxes)))
				.ForMember(dest => dest.MiscCharges, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.MiscCharges) ? JsonConvert.DeserializeObject<List<MiscFee>>(src.MiscCharges) : new List<MiscFee>()))
				.ForMember(dest => dest.WorkerCompensations, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.WorkerCompensations) ? JsonConvert.DeserializeObject<List<InvoiceWorkerCompensation>>(src.WorkerCompensations) : new List<InvoiceWorkerCompensation>()))
				.ForMember(dest => dest.CompanyInvoiceSetup, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<InvoiceSetup>(src.InvoiceSetup)))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.Deductions) ? JsonConvert.DeserializeObject<List<PayrollDeduction>>(src.Deductions) : new List<PayrollDeduction>()))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.Company, opt => opt.MapFrom(src => src.Company))
				.ForMember(dest => dest.InvoicePayments, opt => opt.MapFrom(src => src.InvoicePayments))
				.ForMember(dest => dest.PayChecks, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.PayChecks) ? JsonConvert.DeserializeObject<List<int>>(src.PayChecks) : new List<int>()))
				.ForMember(dest => dest.VoidedCreditedChecks, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.VoidedCreditChecks) ? JsonConvert.DeserializeObject<List<int>>(src.VoidedCreditChecks) : new List<int>()))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.PayrollPayDay, opt => opt.MapFrom(src => src.PayrollPayDay));

			CreateMap<Models.JsonDataModel.InvoicePaymentJson, Models.InvoicePayment>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false));

			CreateMap<Models.JsonDataModel.PayrollInvoiceCommissionJson, Models.PayrollInvoiceCommission>();

			CreateMap<Models.JsonDataModel.PayrollPayCheckJson, PayCheck>()
				.ForMember(dest => dest.Employee, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Employee>(src.Employee)))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollPayCode>>(src.PayCodes)))
				.ForMember(dest => dest.Compensations, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollPayType>>(src.Compensations)))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollDeduction>>(src.Deductions)))
				.ForMember(dest => dest.WorkerCompensation, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.WorkerCompensation) ? JsonConvert.DeserializeObject<PayrollWorkerCompensation>(src.WorkerCompensation) : null))
				.ForMember(dest => dest.Accumulations, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayTypeAccumulation>>(src.Accumulations)))
				.ForMember(dest => dest.Taxes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollTax>>(src.Taxes)))
				.ForMember(dest => dest.Salary, opt => opt.MapFrom(src => src.Salary))
				.ForMember(dest => dest.PayrollId, opt => opt.MapFrom(src => src.PayrollId))
				.ForMember(dest => dest.InvoiceId, opt => opt.MapFrom(src => src.InvoiceId))
				.ForMember(dest => dest.Included, opt => opt.MapFrom(src => true))
				.ForMember(dest => dest.UpdateEmployeeRate, opt => opt.MapFrom(src => false));

			CreateMap<Models.JsonDataModel.VoidedPayCheckInvoiceCreditJson, VoidedPayCheckInvoiceCredit>()
				.ForMember(dest => dest.Deductions,
					opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollDeduction>>(src.Deductions)))
				.ForMember(dest => dest.InvoiceSetup,
					opt => opt.MapFrom(src => JsonConvert.DeserializeObject<InvoiceSetup>(src.InvoiceSetup)))
				.ForMember(dest => dest.MiscCharges,
					opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<MiscFee>>(src.MiscCharges)));


			CreateMap<Models.JsonDataModel.PayrollJson, Models.Payroll>()
				.ForMember(dest => dest.PayChecks, opt => opt.MapFrom(src => src.PayrollPayChecks))
				.ForMember(dest => dest.Company, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Company>(src.Company)))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.Notes, opt => opt.MapFrom(src => src.Notes))
				.ForMember(dest => dest.StartingCheckNumber, opt => opt.MapFrom(src => src.StartingCheckNumber))
				.ForMember(dest => dest.Status, opt => opt.MapFrom(src => src.Status))
				.ForMember(dest => dest.Warnings, opt => opt.Ignore())
				.ForMember(dest => dest.QueuePosition, opt => opt.Ignore())
				.ForMember(dest => dest.UserId, opt => opt.Ignore());

			CreateMap<Models.JsonDataModel.CompanyJson, Models.Company>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.CompanyName))
				.ForMember(dest => dest.CompanyNo, opt => opt.MapFrom(src => src.CompanyNo))
				.ForMember(dest => dest.TaxFilingName, opt => opt.MapFrom(src => src.TaxFilingName))
				.ForMember(dest => dest.AllowEFileFormFiling, opt => opt.MapFrom(src => src.ManageEFileForms))
				.ForMember(dest => dest.AllowTaxPayments, opt => opt.MapFrom(src => src.ManageTaxPayment))
				.ForMember(dest => dest.BusinessAddress, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Address>(src.BusinessAddress)))
				.ForMember(dest => dest.CompanyAddress, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Address>(src.CompanyAddress)))
				.ForMember(dest => dest.IsAddressSame, opt => opt.MapFrom(src => src.IsAddressSame))
				.ForMember(dest => dest.InsuranceGroupNo, opt => opt.MapFrom(src => src.InsuranceGroupNo))
				.ForMember(dest => dest.IsVisibleToHost, opt => opt.MapFrom(src => src.IsVisibleToHost))
				.ForMember(dest => dest.IsFiler944, opt => opt.MapFrom(src => src.IsFiler944))

				.ForMember(dest => dest.PayCheckStock, opt => opt.MapFrom(src => src.PayCheckStock))
				.ForMember(dest => dest.PayrollDaysInPast, opt => opt.MapFrom(src => src.PayrollDaysInPast))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollSchedule))

				.ForMember(dest => dest.DirectDebitPayer, opt => opt.MapFrom(src => src.DirectDebitPayer))
				.ForMember(dest => dest.DepositSchedule, opt => opt.MapFrom(src => src.DepositSchedule941))
				.ForMember(dest => dest.FederalEIN, opt => opt.MapFrom(src => Crypto.Decrypt(src.FederalEIN)))
				.ForMember(dest => dest.FederalPin, opt => opt.MapFrom(src => Crypto.Decrypt(src.FederalPin)))

				.ForMember(dest => dest.FileUnderHost, opt => opt.MapFrom(src => src.FileUnderHost))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => src.StatusId))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))

				.ForMember(dest => dest.Locations, opt => opt.MapFrom(src => src.Locations))
				.ForMember(dest => dest.AccumulatedPayTypes, opt => opt.MapFrom(src => src.CompanyAccumlatedPayTypes))
				.ForMember(dest => dest.Contract, opt => opt.MapFrom(src => src.CompanyContract))
				.ForMember(dest => dest.CompanyTaxRates, opt => opt.MapFrom(src => src.CompanyTaxRates))
				.ForMember(dest => dest.States, opt => opt.MapFrom(src => src.CompanyTaxStates))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src => src.CompanyDeductions))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => src.CompanyPayCodes))
				.ForMember(dest => dest.CompanyRenewals, opt => opt.MapFrom(src => src.CompanyRenewals))
				.ForMember(dest => dest.WorkerCompensations, opt => opt.MapFrom(src => src.CompanyWorkerCompensations))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.InsuranceClientNo, opt => opt.MapFrom(src => src.ClientNo))
				.ForMember(dest => dest.InsuranceGroup, opt => opt.MapFrom(src => src.InsuranceGroup))
				.ForMember(dest=>dest.Contact, opt=>opt.MapFrom(src=> !string.IsNullOrWhiteSpace(src.Contact) ? JsonConvert.DeserializeObject<Contact>(src.Contact) : null));

			CreateMap<Models.JsonDataModel.EmployeeJson, Models.Employee>()
				.ForMember(dest => dest.HostId, opt => opt.MapFrom(src => src.HostId))
				.ForMember(dest => dest.SSN, opt => opt.MapFrom(src => Crypto.Decrypt(src.SSN)))
				.ForMember(dest => dest.Contact, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Contact>(src.Contact)))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<CompanyPayCode>>(src.PayCodes)))
				.ForMember(dest => dest.Compensations, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<EmployeePayType>>(src.Compensations)))
				.ForMember(dest => dest.PayTypeAccruals, opt => opt.MapFrom(src =>string.IsNullOrWhiteSpace(src.PayTypeAccruals) ? new List<int>() : JsonConvert.DeserializeObject<List<int>>(src.PayTypeAccruals)))
				.ForMember(dest => dest.State, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<EmployeeState>(src.State)))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.SickLeaveHireDate, opt => opt.MapFrom(src=> src.SickLeaveHireDate.HasValue? src.SickLeaveHireDate.Value : src.HireDate))
				.ForMember(dest => dest.WorkerCompensation, opt => opt.MapFrom(src => src.CompanyWorkerCompensation))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.LastPayrollDate, opt => opt.MapFrom(src => src.LastPayDay))
				.ForMember(dest => dest.BankAccounts, opt => opt.MapFrom(src => src.EmployeeBankAccounts))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src => src.EmployeeDeductions));

			CreateMap<Models.JsonDataModel.EmployeeDeduction, Models.EmployeeDeduction>()
				.ForMember(dest => dest.Deduction, opt => opt.MapFrom(src => src.CompanyDeduction));

			CreateMap<Models.JsonDataModel.EmployeeBankAccount, Models.EmployeeBankAccount>()
				.ForMember(dest => dest.BankAccount, opt => opt.MapFrom(src => src.BankAccount));

			CreateMap<Models.JsonDataModel.BankAccount, BankAccount>()
				.ForMember(dest => dest.AccountNumber, opt => opt.MapFrom(src => Crypto.Decrypt(src.AccountNumber)))
				.ForMember(dest => dest.RoutingNumber, opt => opt.MapFrom(src => Crypto.Decrypt(src.RoutingNumber)))
				.ForMember(dest => dest.SourceTypeId, opt => opt.MapFrom(src => src.EntityTypeId))
				.ForMember(dest => dest.SourceId, opt => opt.MapFrom(src => src.EntityId))
				.ForMember(dest => dest.RoutingNumber1, opt => opt.Ignore());

			CreateMap<Models.JsonDataModel.MasterExtractJson, Models.MasterExtract>()
				.ForMember(dest => dest.Extract, opt => opt.MapFrom(src =>!string.IsNullOrWhiteSpace(src.Extract) ? JsonConvert.DeserializeObject<Extract>(src.Extract) : null))
				.ForMember(dest => dest.Journals, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<int>>(src.Journals)));

			CreateMap<Models.JsonDataModel.MasterExtractJson, Models.ACHMasterExtract>()
				.ForMember(dest => dest.Extract, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.Extract) ? JsonConvert.DeserializeObject<ACHExtract>(src.Extract) : null));

			
			CreateMap<Models.JsonDataModel.JournalPayeeJson, Models.JournalPayee>()
				.ForMember(dest => dest.Contact, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.Contact) ? JsonConvert.DeserializeObject<Contact>(src.Contact) : null))
				.ForMember(dest => dest.Address, opt => opt.MapFrom(src => src.PayeeType == EntityTypeEnum.Company ? JsonConvert.DeserializeObject<Address>(src.Address) : !string.IsNullOrWhiteSpace(src.Contact) ? JsonConvert.DeserializeObject<Contact>(src.Contact).Address : new Contact().Address));

			CreateMap<Models.CompanyPayrollCube, Models.JsonDataModel.CompanyPayrollCube>()
				.ForMember(dest => dest.Accumulation, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Accumulation)));

			CreateMap<Models.JsonDataModel.CompanyPayrollCube, Models.CompanyPayrollCube>()
				.ForMember(dest => dest.Accumulation, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<PayrollAccumulation>(src.Accumulation)));

			CreateMap<Models.JsonDataModel.JournalJson, Models.Journal>()
				.ForMember(dest => dest.JournalDetails, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<Models.JournalDetail>>(src.JournalDetails)))
				.ForMember(dest => dest.ListItems, opt => opt.MapFrom(src =>!string.IsNullOrWhiteSpace(src.ListItems) ? JsonConvert.DeserializeObject<List<Models.JournalItem>>(src.ListItems) : new List<JournalItem>()));

			CreateMap<Models.JsonDataModel.ExtractInvoicePaymentJson, Models.ExtractInvoicePayment>();
			CreateMap<Models.JsonDataModel.PayrollInvoiceMiscCharges, Models.PayrollInvoiceMiscCharges>()
				.ForMember(dest => dest.MiscCharges, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<Models.MiscFee>>(src.MiscCharges)));
			CreateMap<Models.PayrollInvoiceMiscCharges, Models.JsonDataModel.PayrollInvoiceMiscCharges>()
				.ForMember(dest => dest.MiscCharges, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.MiscCharges)));

			CreateMap<Models.JsonDataModel.ProfitStarsPaymentJson, Models.ProfitStarsPayment>()
				.ForMember(dest => dest.AccountType, opt => opt.MapFrom(src => src.AccType))
				.ForMember(dest => dest.requestID, opt => opt.MapFrom(src => string.Format("{0}{1}", ((ProfitStarsPaymentType)src.Type).GetHrMaxxName(), src.Id)))
				.ForMember(dest => dest.transactionID, opt => opt.MapFrom(src => string.Format("{0}{1}", ((ProfitStarsPaymentType)src.Type).GetHrMaxxName(), src.Id)))
				.ForMember(dest => dest.AccountNumber, opt => opt.MapFrom(src => Crypto.Decrypt(src.AccNum)))
				.ForMember(dest => dest.RoutingNumber, opt => opt.MapFrom(src => Crypto.Decrypt(src.RoutingNum)));

			CreateMap<Models.JsonDataModel.CompanyDashboardJson, Models.CompanyDashboard>()
				.ForMember(dest => dest.PendingUiEtt, opt => opt.Ignore())
				.ForMember(dest => dest.Pending940, opt => opt.Ignore())
				.ForMember(dest => dest.Pending941, opt => opt.Ignore())
				.ForMember(dest => dest.PendingPit, opt => opt.Ignore())
				.ForMember(dest => dest.PendingDelayedUiEtt, opt => opt.Ignore())
				.ForMember(dest => dest.PendingDelayed940, opt => opt.Ignore())
				.ForMember(dest => dest.PendingDelayed941, opt => opt.Ignore())
				.ForMember(dest => dest.PendingDelayedPit, opt => opt.Ignore())
				.ForMember(dest => dest.DelayedExtractsBySchedule, opt => opt.Ignore())
				.ForMember(dest => dest.Accumulation, opt => opt.Ignore())
                .ForMember(dest => dest.PendingExtractsBySchedule, opt => opt.Ignore());
			CreateMap<Models.JsonDataModel.TaxExtractJson, Models.TaxExtract>()
				.ForMember(dest => dest.Details, opt => opt.Ignore());
			CreateMap<Models.JsonDataModel.PayrollMetricJson, Models.PayrollMetric>()
                .ForMember(dest => dest.DeductionList, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.DeductionJson) ? JsonConvert.DeserializeObject<List<PayrollDeduction>>(src.DeductionJson) : default(List<PayrollDeduction>)))
                .ForMember(dest => dest.Accumulations, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.Accumulations) ? JsonConvert.DeserializeObject<List<PayTypeAccumulation>>(src.Accumulations) : default(List<PayTypeAccumulation>)));

            CreateMap<Models.JsonDataModel.StaffDashboardJson, Models.StaffDashboard>()
				.ForMember(dest => dest.MissedPayrollsYesterday, opt => opt.Ignore())
				.ForMember(dest => dest.Renewals, opt => opt.Ignore());
			CreateMap<Models.JsonDataModel.StaffDashboardCubeJson, Models.StaffDashboardCube>();
			CreateMap<Models.JsonDataModel.CompanyDueDateJson, Models.CompanyDueDate>()
				.ForMember(dest => dest.InvoiceSetup, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<InvoiceSetup>(src.InvoiceSetup)))
				.ForMember(dest => dest.Details, opt => opt.Ignore());

			CreateMap<Models.JsonDataModel.EmployeeMinifiedJson, Models.EmployeeMinified>()
				.ForMember(dest => dest.HostId, opt => opt.MapFrom(src => src.HostId))
				.ForMember(dest => dest.SSN, opt => opt.MapFrom(src => Crypto.Decrypt(src.SSN)))
				.ForMember(dest => dest.Contact, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Contact>(src.Contact)));

			CreateMap<Models.JsonDataModel.ScheduledPayrollJson, Models.SchedulePayroll>()
				.ForMember(dest => dest.Data, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Payroll>( src.Data)));

			CreateMap<Models.SchedulePayroll, Models.JsonDataModel.ScheduledPayrollJson>()
				.ForMember(dest => dest.Data, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Data)));

			CreateMap<Models.JsonDataModel.EmployeeACA, Models.EmployeeACA>();
			CreateMap<Models.EmployeeACA, Models.JsonDataModel.EmployeeACA>();

		}
	}
}

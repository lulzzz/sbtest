using System;
using System.Collections.Generic;
using System.Linq;
using AutoMapper;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using Magnum;
using Magnum.Extensions;
using Newtonsoft.Json;
using BankAccount = HrMaxx.OnlinePayroll.Models.BankAccount;
using Company = HrMaxx.OnlinePayroll.Models.Company;
using CompanyDeduction = HrMaxx.OnlinePayroll.Models.CompanyDeduction;
using CompanyPayCode = HrMaxx.OnlinePayroll.Models.CompanyPayCode;
using CompanyWorkerCompensation = HrMaxx.OnlinePayroll.Models.CompanyWorkerCompensation;
using DeductionType = HrMaxx.OnlinePayroll.Models.DeductionType;
using Employee = HrMaxx.OnlinePayroll.Models.Employee;
using PayType = HrMaxx.OnlinePayroll.Models.PayType;
using Tax = HrMaxx.OnlinePayroll.Models.DataModel.Tax;
using VendorCustomer = HrMaxx.OnlinePayroll.Models.VendorCustomer;

namespace HrMaxx.OnlinePayroll.Services.Mappers
{
	public class OnlinePayrollModelMapperProfile : ProfileLazy
	{
		public OnlinePayrollModelMapperProfile(Lazy<IMappingEngine> mapper) : base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();

			CreateMap<Models.Host, Models.DataModel.Host>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.FirmName, opt => opt.MapFrom(src => src.FirmName))
				.ForMember(dest => dest.Url, opt => opt.MapFrom(src => src.Url))
				.ForMember(dest => dest.EffectiveDate, opt => opt.MapFrom(src => src.EffectiveDate))
				.ForMember(dest => dest.TerminationDate, opt => opt.MapFrom(src => src.TerminationDate))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => src.StatusId))
				.ForMember(dest => dest.Status, opt => opt.Ignore())
				.ForMember(dest => dest.HomePage, opt => opt.Ignore())
				.ForMember(dest => dest.Companies, opt => opt.Ignore())
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyId, opt => opt.MapFrom(src => src.CompanyId))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src => src.UserName));

			CreateMap<Models.DataModel.Host, Models.Host>()
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

			CreateMap<Models.DataModel.Company, Models.Company>()
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

				.ForMember(dest => dest.AccumulatedPayTypes, opt => opt.MapFrom(src => src.CompanyAccumlatedPayTypes))
				.ForMember(dest => dest.Contract, opt => opt.MapFrom(src => src.CompanyContracts.FirstOrDefault()))
				.ForMember(dest => dest.CompanyTaxRates, opt => opt.MapFrom(src => src.CompanyTaxRates))
				.ForMember(dest => dest.States, opt => opt.MapFrom(src => src.CompanyTaxStates))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src => src.CompanyDeductions))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => src.CompanyPayCodes))
				.ForMember(dest => dest.WorkerCompensations, opt => opt.MapFrom(src => src.CompanyWorkerCompensations))
				.ForMember(dest => dest.UserId, opt => opt.Ignore());


			CreateMap<Models.Company, Models.DataModel.Company>()
				.ForMember(dest => dest.Host, opt => opt.Ignore())
				.ForMember(dest => dest.Hosts, opt => opt.Ignore())
				.ForMember(dest => dest.Status, opt => opt.Ignore())
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.CompanyName, opt => opt.MapFrom(src => src.Name))
				.ForMember(dest => dest.CompanyNo, opt => opt.MapFrom(src => src.CompanyNo))
				.ForMember(dest => dest.TaxFilingName, opt => opt.MapFrom(src => src.TaxFilingName))
				.ForMember(dest => dest.ManageEFileForms, opt => opt.MapFrom(src => src.AllowEFileFormFiling))
				.ForMember(dest => dest.ManageTaxPayment, opt => opt.MapFrom(src => src.AllowTaxPayments))
				.ForMember(dest => dest.BusinessAddress, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.BusinessAddress)))
				.ForMember(dest => dest.CompanyAddress, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.CompanyAddress)))
				.ForMember(dest => dest.IsAddressSame, opt => opt.MapFrom(src => src.IsAddressSame))
				.ForMember(dest => dest.InsuranceGroupNo, opt => opt.MapFrom(src => src.InsuranceGroupNo))
				.ForMember(dest => dest.IsVisibleToHost, opt => opt.MapFrom(src => src.IsVisibleToHost))
				.ForMember(dest => dest.IsFiler944, opt => opt.MapFrom(src => src.IsFiler944))

				.ForMember(dest => dest.PayCheckStock, opt => opt.MapFrom(src => src.PayCheckStock))
				.ForMember(dest => dest.PayrollDaysInPast, opt => opt.MapFrom(src => src.PayrollDaysInPast))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollSchedule))

				.ForMember(dest => dest.DirectDebitPayer, opt => opt.MapFrom(src => src.DirectDebitPayer))
				.ForMember(dest => dest.DepositSchedule941, opt => opt.MapFrom(src => src.DepositSchedule))
				.ForMember(dest => dest.FederalEIN, opt => opt.MapFrom(src => Crypto.Encrypt(src.FederalEIN)))
				.ForMember(dest => dest.FederalPin, opt => opt.MapFrom(src => Crypto.Encrypt(src.FederalPin)))

				.ForMember(dest => dest.FileUnderHost, opt => opt.MapFrom(src => src.FileUnderHost))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => src.StatusId))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src => src.UserName))
				.ForMember(dest => dest.CompanyAccumlatedPayTypes, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyDeductions, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyPayCodes, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyWorkerCompensations, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyContracts, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyTaxRates, opt => opt.MapFrom(src => src.CompanyTaxRates))
				.ForMember(dest => dest.VendorCustomers, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyTaxStates, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyAccounts, opt => opt.Ignore())
				.ForMember(dest => dest.Employees, opt => opt.Ignore())
				.ForMember(dest => dest.Journals, opt => opt.Ignore())
				.ForMember(dest => dest.PayrollInvoices, opt => opt.Ignore());


			CreateMap<Models.DataModel.CompanyContract, Models.ContractDetails>()
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

			CreateMap<Models.ContractDetails, Models.DataModel.CompanyContract>()
				.ForMember(dest => dest.Id, opt => opt.Ignore())
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.BillingType, opt => opt.MapFrom(src => src.BillingOption))
				.ForMember(dest => dest.Type, opt => opt.MapFrom(src => src.ContractOption))
				.ForMember(dest => dest.CardDetails,
					opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.CreditCardDetails)))
				.ForMember(dest => dest.InvoiceRate, opt => opt.MapFrom(src => src.InvoiceCharge))
				.ForMember(dest => dest.PrePaidSubscriptionType, opt => opt.MapFrom(src => src.PrePaidSubscriptionOption))
				.ForMember(dest => dest.BankDetails,
					opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.BankDetails)))
				.ForMember(dest => dest.InvoiceSetup,
					opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.InvoiceSetup)));

			CreateMap<Models.DataModel.CompanyTaxRate, Models.CompanyTaxRate>()
				.ForMember(dest => dest.TaxCode, opt => opt.MapFrom(src => src.Tax.Code));

			CreateMap<Models.CompanyTaxRate, Models.DataModel.CompanyTaxRate>()
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.Tax, opt => opt.Ignore());


			CreateMap<Models.DataModel.CompanyTaxState, Models.CompanyTaxState>()
				.ForMember(dest => dest.State, opt => opt.MapFrom(src => src))
				.ForMember(dest => dest.StateEIN, opt => opt.MapFrom(src => Crypto.Decrypt(src.EIN)))
				.ForMember(dest => dest.StatePIN, opt => opt.MapFrom(src => Crypto.Decrypt(src.Pin)));

			CreateMap<Models.CompanyTaxState, Models.DataModel.CompanyTaxState>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.CountryId, opt => opt.MapFrom(src => src.CountryId))
				.ForMember(dest => dest.StateId, opt => opt.MapFrom(src => src.State.StateId))
				.ForMember(dest => dest.StateCode, opt => opt.MapFrom(src => src.State.Abbreviation))
				.ForMember(dest => dest.StateName, opt => opt.MapFrom(src => src.State.StateName))
				.ForMember(dest => dest.EIN, opt => opt.MapFrom(src => Crypto.Encrypt(src.StateEIN)))
				.ForMember(dest => dest.Pin, opt => opt.MapFrom(src => Crypto.Encrypt(src.StatePIN)));

			CreateMap<Models.DataModel.CompanyTaxState, State>()
				.ForMember(dest => dest.Abbreviation, opt => opt.MapFrom(src => src.StateCode))
				.ForMember(dest => dest.StateId, opt => opt.MapFrom(src => src.StateId))
				.ForMember(dest => dest.StateName, opt => opt.MapFrom(src => src.StateName));

			CreateMap<Models.DataModel.DeductionType, DeductionType>();
			CreateMap<DeductionType, Models.DataModel.DeductionType>()
				.ForMember(dest => dest.CompanyDeductions, opt => opt.Ignore());

			CreateMap<Models.DataModel.CompanyDeduction, CompanyDeduction>()
				.ForMember(dest => dest.AnnualMax, opt => opt.MapFrom(src => src.AnnualMax))
				.ForMember(dest => dest.DeductionName, opt => opt.MapFrom(src => src.Name))
				.ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Description))
				.ForMember(dest => dest.Type, opt => opt.MapFrom(src => src.DeductionType))
				.ForMember(dest => dest.W2_12, opt => opt.MapFrom(src => src.DeductionType.W2_12))
				.ForMember(dest => dest.W2_13R, opt => opt.MapFrom(src => src.DeductionType.W2_13R))
				.ForMember(dest => dest.R940_R, opt => opt.MapFrom(src => src.DeductionType.R940_R));

			CreateMap<Models.CompanyDeduction, Models.DataModel.CompanyDeduction>()
				.ForMember(dest => dest.AnnualMax, opt => opt.MapFrom(src => src.AnnualMax))
				.ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.DeductionName))
				.ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Description))
				.ForMember(dest => dest.DeductionType, opt => opt.Ignore())
				.ForMember(dest => dest.TypeId, opt => opt.MapFrom(src => src.Type.Id))
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.EmployeeDeductions, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyId, opt => opt.MapFrom(src => src.CompanyId));

			CreateMap<Models.DataModel.CompanyWorkerCompensation, CompanyWorkerCompensation>();

			CreateMap<Models.CompanyWorkerCompensation, Models.DataModel.CompanyWorkerCompensation>()
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.Employees, opt => opt.Ignore());

			CreateMap<Models.DataModel.PayType, PayType>();

			CreateMap<Models.DataModel.CompanyAccumlatedPayType, AccumulatedPayType>()
				.ForMember(dest => dest.PayType, opt => opt.MapFrom(src => src.PayType));

			CreateMap<Models.AccumulatedPayType, Models.DataModel.CompanyAccumlatedPayType>()
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.PayType, opt => opt.Ignore());

			CreateMap<Models.DataModel.CompanyPayCode, CompanyPayCode>();
			CreateMap<CompanyPayCode, Models.DataModel.CompanyPayCode>()
				.ForMember(dest => dest.Company, opt => opt.Ignore());

			CreateMap<Models.DataModel.VendorCustomer, VendorCustomer>()
				.ForMember(dest => dest.IndividualSSN, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.IndividualSSN) ? Crypto.Decrypt(src.IndividualSSN) : src.IndividualSSN))
				.ForMember(dest => dest.BusinessFIN, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.BusinessFIN) ? Crypto.Decrypt(src.BusinessFIN) : src.BusinessFIN))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.Contact, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Contact>(src.Contact)))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy));

			CreateMap<VendorCustomer, Models.DataModel.VendorCustomer>()
				.ForMember(dest => dest.IndividualSSN, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.IndividualSSN) ? Crypto.Encrypt(src.IndividualSSN) : src.IndividualSSN))
				.ForMember(dest => dest.BusinessFIN, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.BusinessFIN) ? Crypto.Encrypt(src.BusinessFIN) : src.BusinessFIN))
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src => src.UserName))
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.Contact, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Contact)))
				.ForMember(dest => dest.Status, opt => opt.Ignore())
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => src.StatusId));

			CreateMap<Models.DataModel.CompanyAccount, Account>()
				.ForMember(dest => dest.UseInPayroll, opt => opt.MapFrom(src => src.UsedInPayroll))
				;

			CreateMap<Account, Models.DataModel.CompanyAccount>()
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.Journals, opt => opt.Ignore())
				.ForMember(dest => dest.BankAccount, opt => opt.MapFrom(src => src.BankAccount))
				.ForMember(dest => dest.AccountTemplate, opt => opt.Ignore())
				.ForMember(dest => dest.UsedInPayroll, opt => opt.MapFrom(src => src.UseInPayroll))
				;

			CreateMap<Models.DataModel.BankAccount, BankAccount>()
				.ForMember(dest => dest.AccountNumber, opt => opt.MapFrom(src => Crypto.Decrypt(src.AccountNumber)))
				.ForMember(dest => dest.RoutingNumber, opt => opt.MapFrom(src => Crypto.Decrypt(src.RoutingNumber)))
				.ForMember(dest => dest.SourceTypeId, opt => opt.MapFrom(src => src.EntityTypeId))
				.ForMember(dest => dest.SourceId, opt => opt.MapFrom(src => src.EntityId));

			CreateMap<BankAccount, Models.DataModel.BankAccount>()
				.ForMember(dest => dest.AccountNumber, opt => opt.MapFrom(src => Crypto.Encrypt(src.AccountNumber)))
				.ForMember(dest => dest.RoutingNumber, opt => opt.MapFrom(src => Crypto.Encrypt(src.RoutingNumber)))
				.ForMember(dest => dest.EntityId, opt => opt.MapFrom(src => src.SourceId))
				.ForMember(dest => dest.EntityTypeId, opt => opt.MapFrom(src => src.SourceTypeId))
				.ForMember(dest => dest.EntityType, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyAccounts, opt => opt.Ignore())
				.ForMember(dest => dest.Employees, opt => opt.Ignore());

			CreateMap<Models.DataModel.AccountTemplate, Models.DataModel.CompanyAccount>()
				.ForMember(dest => dest.Id, opt => opt.Ignore())
				.ForMember(dest => dest.TemplateId, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.OpeningBalance, opt => opt.MapFrom(src => (decimal)0))
				.ForMember(dest => dest.OpeningDate, opt => opt.MapFrom(src => DateTime.Now))
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.UsedInPayroll, opt => opt.Ignore())
				.ForMember(dest => dest.AccountTemplate, opt => opt.Ignore())
				.ForMember(dest => dest.BankAccount, opt => opt.Ignore())
				.ForMember(dest => dest.BankAccountId, opt => opt.Ignore())
				.ForMember(dest => dest.Journals, opt => opt.Ignore())
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now))
				.ForMember(dest => dest.LastModifiedBy, opt => opt.Ignore());

			CreateMap<Models.DataModel.Employee, Models.Employee>()
				.ForMember(dest => dest.SSN, opt => opt.MapFrom(src => Crypto.Decrypt(src.SSN)))
				.ForMember(dest => dest.BankAccount, opt => opt.MapFrom(src => src.BankAccount))
				.ForMember(dest => dest.Contact, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Contact>(src.Contact)))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<CompanyPayCode>>(src.PayCodes)))
				.ForMember(dest => dest.Compensations, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<EmployeePayType>>(src.Compensations)))
				.ForMember(dest => dest.State, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<EmployeeState>(src.State)))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.WorkerCompensation, opt => opt.MapFrom(src => src.CompanyWorkerCompensation))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src => src.EmployeeDeductions));

			CreateMap<Models.Employee, Models.DataModel.Employee>()
				.ForMember(dest => dest.SSN, opt => opt.MapFrom(src => Crypto.Encrypt(src.SSN)))
				.ForMember(dest => dest.BankAccount, opt => opt.Ignore())
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.Status, opt => opt.Ignore())
				.ForMember(dest => dest.BankAccountId, opt => opt.MapFrom(src => src.BankAccount.Id))
				.ForMember(dest => dest.Contact, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Contact)))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.PayCodes)))
				.ForMember(dest => dest.Compensations, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Compensations)))
				.ForMember(dest => dest.State, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.State)))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.EmployeeDeductions, opt => opt.Ignore())
				.ForMember(dest => dest.WorkerCompensationId, opt => opt.MapFrom(src => src.WorkerCompensation != null ? src.WorkerCompensation.Id : default(int?)))
				.ForMember(dest => dest.CompanyWorkerCompensation, opt => opt.Ignore())
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src => src.UserName));

			CreateMap<Models.DataModel.EmployeeDeduction, Models.EmployeeDeduction>()
				.ForMember(dest => dest.Deduction, opt => opt.MapFrom(src => src.CompanyDeduction));

			CreateMap<Models.EmployeeDeduction, Models.DataModel.EmployeeDeduction>()
				.ForMember(dest => dest.Employee, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyDeduction, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyDeductionId, opt => opt.MapFrom(src => src.Deduction.Id));


			CreateMap<HostHomePageDocument, DocumentDto>()
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.UserName, opt => opt.Ignore())
				.ForMember(dest => dest.LastModified, opt => opt.Ignore())
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => CombGuid.Generate()))
				.ForMember(dest => dest.DocumentPath, opt => opt.Ignore())
				.ForMember(dest => dest.DocumentName, opt => opt.MapFrom(src => src.OriginalFileName))
				.ForMember(dest => dest.MimeType, opt => opt.MapFrom(src => src.MimeType))
				.ForMember(dest => dest.DocumentExtension, opt => opt.MapFrom(src => src.FileExtension));

			CreateMap<Tax, TaxDefinition>();
			CreateMap<TaxYearRate, TaxByYear>();
			CreateMap<TaxByYear, TaxYearRate>()
				.ForMember(dest => dest.TaxId, opt => opt.MapFrom(src=>src.Tax.Id))
				.ForMember(dest => dest.Tax, opt => opt.Ignore());

			CreateMap<Models.DataModel.PayType, PayType>();
			CreateMap<Models.DataModel.BankAccount, BankAccount>()
				.ForMember(dest => dest.AccountNumber, opt => opt.MapFrom(src => Crypto.Decrypt(src.AccountNumber)))
				.ForMember(dest => dest.RoutingNumber, opt => opt.MapFrom(src => Crypto.Decrypt(src.RoutingNumber)))
				.ForMember(dest => dest.SourceTypeId, opt => opt.MapFrom(src => src.EntityTypeId))
				.ForMember(dest => dest.SourceId, opt => opt.MapFrom(src=>src.EntityId));

			CreateMap<BankAccount, Models.DataModel.BankAccount>()
				.ForMember(dest => dest.AccountNumber, opt => opt.MapFrom(src => Crypto.Encrypt(src.AccountNumber)))
				.ForMember(dest => dest.RoutingNumber, opt => opt.MapFrom(src => Crypto.Encrypt(src.RoutingNumber)))
				.ForMember(dest => dest.EntityId, opt => opt.MapFrom(src => src.SourceId))
				.ForMember(dest => dest.EntityTypeId, opt => opt.MapFrom(src => src.SourceTypeId))
				.ForMember(dest => dest.EntityType, opt => opt.Ignore())
				.ForMember(dest => dest.Employees, opt => opt.Ignore())
				.ForMember(dest => dest.AccountName, opt => opt.MapFrom(src=>src.BankName))
				.ForMember(dest => dest.CompanyAccounts, opt => opt.Ignore());

			CreateMap<TaxByYear, Models.Tax>()
				.ForMember(dest => dest.Code, opt => opt.MapFrom(src => src.Tax.Code))
				.ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Tax.Name))
				.ForMember(dest => dest.CountryId, opt => opt.MapFrom(src => src.Tax.CountryId))
				.ForMember(dest => dest.StateId, opt => opt.MapFrom(src => src.Tax.StateId))
				.ForMember(dest => dest.DefaultRate, opt => opt.MapFrom(src => src.Rate))
				.ForMember(dest => dest.IsEmployeeTax, opt => opt.MapFrom(src => src.Tax.PaidBy == "Employee"))
				.ForMember(dest => dest.IsCompanySpecific, opt => opt.MapFrom(src => src.Tax.IsCompanySpecific))
				.ForMember(dest => dest.AnnualMax, opt => opt.MapFrom(src => src.AnnualMaxPerEmployee));

			CreateMap<Models.DataModel.PayrollPayCheck, PayCheck>()
				.ForMember(dest => dest.Employee, opt => opt.MapFrom(src=>JsonConvert.DeserializeObject<Employee>(src.Employee)))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollPayCode>>(src.PayCodes)))
				.ForMember(dest => dest.Compensations, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollPayType>>(src.Compensations)))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollDeduction>>(src.Deductions)))
				.ForMember(dest => dest.WorkerCompensation, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.WorkerCompensation)? JsonConvert.DeserializeObject<PayrollWorkerCompensation>(src.WorkerCompensation) : null))
				.ForMember(dest => dest.Accumulations, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayTypeAccumulation>>(src.Accumulations)))
				.ForMember(dest => dest.Taxes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollTax>>(src.Taxes)))
				.ForMember(dest => dest.Salary, opt => opt.MapFrom(src=>src.Salary))
				.ForMember(dest => dest.PayrollId, opt => opt.MapFrom(src => src.PayrollId))
				.ForMember(dest => dest.InvoiceId, opt => opt.MapFrom(src => src.InvoiceId))
				.ForMember(dest => dest.Included, opt => opt.MapFrom(src => true))
				.ForMember(dest => dest.DocumentId, opt => opt.MapFrom(src => src.Journals.Any(j => (j.PEOASOCoCheck == src.PEOASOCoCheck)) ? src.Journals.First(j => (j.PEOASOCoCheck == src.PEOASOCoCheck)).DocumentId : Guid.Empty));


			CreateMap<Models.DataModel.Payroll, Models.Payroll>()
				.ForMember(dest => dest.PayChecks, opt => opt.MapFrom(src => src.PayrollPayChecks))
				.ForMember(dest => dest.Company, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Company>(src.Company)))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.Notes, opt => opt.MapFrom(src=>src.Notes))
				.ForMember(dest => dest.StartingCheckNumber, opt => opt.MapFrom(src => src.StartingCheckNumber))
				.ForMember(dest => dest.Status, opt => opt.MapFrom(src => src.Status))
				.ForMember(dest => dest.Invoice, opt => opt.MapFrom(src=>src.PayrollInvoices.FirstOrDefault()))
				.ForMember(dest => dest.UserId, opt => opt.Ignore());

			CreateMap<Models.Payroll, Models.DataModel.Payroll>()
				.ForMember(dest => dest.PayrollPayChecks, opt => opt.MapFrom(src=>src.PayChecks))
				.ForMember(dest => dest.StartDate, opt => opt.MapFrom(src => src.StartDate.Date))
				.ForMember(dest => dest.EndDate, opt => opt.MapFrom(src => src.EndDate.Date))
				.ForMember(dest => dest.PayDay, opt => opt.MapFrom(src => src.PayDay))
				.ForMember(dest => dest.CompanyId, opt => opt.MapFrom(src => src.Company.Id))
				.ForMember(dest => dest.Company, opt => opt.MapFrom(src =>JsonConvert.SerializeObject(src.Company)))
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src=>src.UserName))
				.ForMember(dest => dest.InvoiceId, opt => opt.Ignore())
				.ForMember(dest => dest.PayrollInvoice, opt => opt.Ignore())
				.ForMember(dest => dest.Notes, opt => opt.MapFrom(src => src.Notes))
				.ForMember(dest => dest.PayrollInvoices, opt => opt.Ignore());

			CreateMap<Models.PayCheck, Models.DataModel.PayrollPayCheck>()
				.ForMember(dest => dest.PayrollId, opt => opt.Ignore())
				.ForMember(dest => dest.StartDate, opt => opt.MapFrom(src => src.StartDate.Date))
				.ForMember(dest => dest.EndDate, opt => opt.MapFrom(src => src.EndDate.Date))
				.ForMember(dest => dest.PayDay, opt => opt.MapFrom(src => src.PayDay))
				.ForMember(dest => dest.Payroll, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.PrintStatus, opt => opt.MapFrom(src => 0))
				.ForMember(dest => dest.Journals, opt => opt.Ignore())
				.ForMember(dest => dest.PayrollInvoice, opt => opt.Ignore())
				.ForMember(dest => dest.PayrmentMethod, opt => opt.MapFrom(src => src.PaymentMethod))
				.ForMember(dest => dest.Employee, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Employee)))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.PayCodes)))
				.ForMember(dest => dest.Compensations, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Compensations)))
				.ForMember(dest => dest.Accumulations, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Accumulations)))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Deductions)))
				.ForMember(dest => dest.WorkerCompensation,
					opt =>
						opt.MapFrom(
							src => src.WorkerCompensation != null ? JsonConvert.SerializeObject(src.WorkerCompensation) : string.Empty))
				.ForMember(dest => dest.Taxes, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Taxes)));

			CreateMap<Models.Journal, Models.DataModel.Journal>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src=>src.Id))
				.ForMember(dest => dest.CompanyAccount, opt => opt.Ignore())
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.EntityType1, opt => opt.Ignore())
				.ForMember(dest => dest.PayrollPayCheck, opt => opt.Ignore())
				.ForMember(dest => dest.TransactionDate, opt => opt.MapFrom(src=>src.TransactionDate.Date))
				.ForMember(dest => dest.JournalDetails, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.JournalDetails)));

			CreateMap<Models.Account, Models.AccountWithJournal>()
				.ForMember(dest => dest.Journals, opt => opt.MapFrom(src=>new List<AccountRegister>()))
				.ForMember(dest => dest.AccountBalance, opt => opt.MapFrom(src=>(decimal)0));

			CreateMap<Models.DataModel.Journal, Models.Journal>()
				.ForMember(dest => dest.JournalDetails, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<Models.JournalDetail>>(src.JournalDetails)));

			CreateMap<Models.CompanyPayrollCube, Models.DataModel.CompanyPayrollCube>()
				.ForMember(dest => dest.Accumulation, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Accumulation)));

			CreateMap<Models.DataModel.CompanyPayrollCube, Models.CompanyPayrollCube>()
				.ForMember(dest => dest.Accumulation, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<PayrollAccumulation>(src.Accumulation)));

			CreateMap<Models.Invoice, Models.DataModel.Invoice>()
				
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src=>src.UserName))
				.ForMember(dest => dest.LineItems, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.LineItems)))
				.ForMember(dest => dest.Payments, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Payments)));

			CreateMap<Models.DataModel.Invoice, Models.Invoice>()
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.PayrollIds, opt => opt.Ignore())
				.ForMember(dest => dest.LineItems, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<InvoiceLineItem>>(src.LineItems)))
				.ForMember(dest => dest.Payments, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<InvoicePayment>>(src.Payments)));

			CreateMap<Models.PayrollInvoice, Models.DataModel.PayrollInvoice>()
				.ForMember(dest => dest.InvoiceSetup, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.CompanyInvoiceSetup)))
				.ForMember(dest => dest.EmployerTaxes, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.EmployerTaxes)))
				.ForMember(dest => dest.EmployeeTaxes, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.EmployeeTaxes)))
				.ForMember(dest => dest.MiscCharges, opt => opt.MapFrom(src => src.MiscCharges.Any() ? JsonConvert.SerializeObject(src.MiscCharges) : string.Empty))
				.ForMember(dest => dest.WorkerCompensations, opt => opt.MapFrom(src => src.WorkerCompensations.Any() ? JsonConvert.SerializeObject(src.WorkerCompensations) : string.Empty))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src => src.Deductions.Any() ? JsonConvert.SerializeObject(src.Deductions) : string.Empty))
				.ForMember(dest => dest.Payrments, opt => opt.MapFrom(src => src.Payments.Any() ? JsonConvert.SerializeObject(src.Payments) : string.Empty))
				.ForMember(dest => dest.PayChecks, opt => opt.MapFrom(src => src.PayChecks.Any() ? JsonConvert.SerializeObject(src.PayChecks) : string.Empty))
				.ForMember(dest => dest.VoidedCreditChecks, opt => opt.MapFrom(src => src.VoidedCreditedChecks.Any() ? JsonConvert.SerializeObject(src.VoidedCreditedChecks) : string.Empty))
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src => src.UserName))
				.ForMember(dest => dest.Balance, opt => opt.MapFrom(src => src.Balance))
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.PayrollPayChecks, opt => opt.Ignore())
				.ForMember(dest => dest.Payroll, opt => opt.Ignore())
				.ForMember(dest => dest.Payrolls, opt => opt.Ignore());

			CreateMap<Models.DataModel.PayrollInvoice, Models.PayrollInvoice>()
				.ForMember(dest => dest.EmployerTaxes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollTax>>(src.EmployerTaxes)))
				.ForMember(dest => dest.EmployeeTaxes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollTax>>(src.EmployeeTaxes)))
				.ForMember(dest => dest.MiscCharges, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.MiscCharges) ? JsonConvert.DeserializeObject<List<MiscFee>>(src.MiscCharges) : new List<MiscFee>()))
				.ForMember(dest => dest.WorkerCompensations, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.WorkerCompensations) ? JsonConvert.DeserializeObject<List<InvoiceWorkerCompensation>>(src.WorkerCompensations) : new List<InvoiceWorkerCompensation>()))
				.ForMember(dest => dest.CompanyInvoiceSetup, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<InvoiceSetup>(src.InvoiceSetup)))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.Deductions) ? JsonConvert.DeserializeObject<List<PayrollDeduction>>(src.Deductions) : new List<PayrollDeduction>()))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.Company, opt => opt.MapFrom(src=>src.Company))
				.ForMember(dest => dest.Payments, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.Payrments) ? JsonConvert.DeserializeObject<List<InvoicePayment>>(src.Payrments) : new List<InvoicePayment>()))
				.ForMember(dest => dest.PayChecks, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.PayChecks) ? JsonConvert.DeserializeObject<List<int>>(src.PayChecks) : new List<int>()))
				.ForMember(dest => dest.VoidedCreditedChecks, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.VoidedCreditChecks) ? JsonConvert.DeserializeObject<List<int>>(src.VoidedCreditChecks) : new List<int>()))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.PayrollPayDay, opt => opt.MapFrom(src=>src.Payroll.PayDay));
		}
	}
}
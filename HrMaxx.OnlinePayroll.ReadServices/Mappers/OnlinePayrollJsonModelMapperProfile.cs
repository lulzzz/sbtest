using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using Newtonsoft.Json;


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

			CreateMap<Models.JsonDataModel.CompanyTaxState, Models.CompanyTaxState>()
				.ForMember(dest => dest.State, opt => opt.MapFrom(src => src))
				.ForMember(dest => dest.StateEIN, opt => opt.MapFrom(src => Crypto.Decrypt(src.EIN)))
				.ForMember(dest => dest.StatePIN, opt => opt.MapFrom(src => Crypto.Decrypt(src.Pin)));


			CreateMap<Models.JsonDataModel.CompanyJson, Models.CompanyLocation>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.ParentId, opt => opt.MapFrom(src => src.ParentId))
				.ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.CompanyName))
				.ForMember(dest => dest.Address, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Address>(src.CompanyAddress)));

			CreateMap<Models.JsonDataModel.CompanyTaxState, State>()
				.ForMember(dest => dest.Abbreviation, opt => opt.MapFrom(src => src.StateCode))
				.ForMember(dest => dest.StateId, opt => opt.MapFrom(src => src.StateId))
				.ForMember(dest => dest.StateName, opt => opt.MapFrom(src => src.StateName));

			CreateMap<Models.JsonDataModel.DeductionType, DeductionType>();
			CreateMap<DeductionType, Models.DataModel.DeductionType>()
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
				.ForMember(dest => dest.DocumentId, opt => opt.MapFrom(src=>src.DocumentId));


			CreateMap<Models.JsonDataModel.PayrollJson, Models.Payroll>()
				.ForMember(dest => dest.PayChecks, opt => opt.MapFrom(src => src.PayrollPayChecks))
				.ForMember(dest => dest.Company, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Company>(src.Company)))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.Notes, opt => opt.MapFrom(src => src.Notes))
				.ForMember(dest => dest.StartingCheckNumber, opt => opt.MapFrom(src => src.StartingCheckNumber))
				.ForMember(dest => dest.Status, opt => opt.MapFrom(src => src.Status))
				.ForMember(dest => dest.Invoice, opt => opt.MapFrom(src => src.PayrollInvoice))
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
				.ForMember(dest => dest.WorkerCompensations, opt => opt.MapFrom(src => src.CompanyWorkerCompensations))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.InsuranceClientNo, opt => opt.MapFrom(src => src.ClientNo))
				.ForMember(dest => dest.InsuranceGroup, opt => opt.MapFrom(src => src.InsuranceGroup));

			CreateMap<Models.JsonDataModel.EmployeeJson, Models.Employee>()
				.ForMember(dest => dest.HostId, opt => opt.MapFrom(src => src.HostId))
				.ForMember(dest => dest.SSN, opt => opt.MapFrom(src => Crypto.Decrypt(src.SSN)))
				.ForMember(dest => dest.Contact, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Contact>(src.Contact)))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<CompanyPayCode>>(src.PayCodes)))
				.ForMember(dest => dest.Compensations, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<EmployeePayType>>(src.Compensations)))
				.ForMember(dest => dest.State, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<EmployeeState>(src.State)))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.SickLeaveHireDate, opt => opt.MapFrom(src=> src.SickLeaveHireDate.HasValue? src.SickLeaveHireDate.Value : src.HireDate))
				.ForMember(dest => dest.WorkerCompensation, opt => opt.MapFrom(src => src.CompanyWorkerCompensation))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
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
		}
	}
}

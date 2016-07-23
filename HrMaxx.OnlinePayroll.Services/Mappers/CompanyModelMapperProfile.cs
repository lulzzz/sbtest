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
using CompanyDeduction = HrMaxx.OnlinePayroll.Models.CompanyDeduction;
using CompanyPayCode = HrMaxx.OnlinePayroll.Models.CompanyPayCode;
using CompanyWorkerCompensation = HrMaxx.OnlinePayroll.Models.CompanyWorkerCompensation;
using DeductionType = HrMaxx.OnlinePayroll.Models.DeductionType;
using PayType = HrMaxx.OnlinePayroll.Models.PayType;

namespace HrMaxx.OnlinePayroll.Services.Mappers
{
	public class CompanyModelMapperProfile : ProfileLazy
	{
		public CompanyModelMapperProfile(Lazy<IMappingEngine> mapper)
			: base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();
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

				.ForMember(dest => dest.AccumulatedPayTypes, opt => opt.MapFrom(src=>src.CompanyAccumlatedPayTypes))
				.ForMember(dest => dest.Contract, opt => opt.MapFrom(src => src.CompanyContracts.FirstOrDefault()))
				.ForMember(dest => dest.CompanyTaxRates, opt => opt.MapFrom(src => src.CompanyTaxRates))
				.ForMember(dest => dest.States, opt => opt.MapFrom(src => src.CompanyTaxStates))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src=>src.CompanyDeductions))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => src.CompanyPayCodes))
				.ForMember(dest => dest.WorkerCompensations, opt => opt.MapFrom(src=>src.CompanyWorkerCompensations))
				.ForMember(dest => dest.UserId, opt => opt.Ignore());


			CreateMap<Models.Company, Models.DataModel.Company>()
				.ForMember(dest => dest.Host, opt => opt.Ignore())
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
				.ForMember(dest => dest.CompanyTaxRates, opt => opt.MapFrom(src=>src.CompanyTaxRates))
				.ForMember(dest => dest.CompanyTaxStates, opt => opt.Ignore());
			

			CreateMap<Models.DataModel.CompanyContract, Models.ContractDetails>()
				.ForMember(dest => dest.BillingOption, opt => opt.MapFrom(src => src.BillingType))
				.ForMember(dest => dest.ContractOption, opt => opt.MapFrom(src => src.Type))
				.ForMember(dest => dest.CreditCardDetails,
				opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.CardDetails)? JsonConvert.DeserializeObject<CreditCard>(src.CardDetails) : null))
				.ForMember(dest => dest.InvoiceCharge, opt => opt.MapFrom(src => src.InvoiceRate))
				.ForMember(dest => dest.PrePaidSubscriptionOption, opt => opt.MapFrom(src => src.PrePaidSubscriptionType.HasValue? (PrePaidSubscriptionOption)src.PrePaidSubscriptionType.Value : PrePaidSubscriptionOption.NA))
				.ForMember(dest => dest.BankDetails,
				opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.BankDetails)? JsonConvert.DeserializeObject<BankAccount>(src.BankDetails) : null));

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
					opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.BankDetails)));

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
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src=>src.Id))
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.CountryId, opt => opt.MapFrom(src=>src.CountryId))
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
				.ForMember(dest => dest.CompanyId, opt => opt.MapFrom(src=>src.CompanyId));

			CreateMap<Models.DataModel.CompanyWorkerCompensation, CompanyWorkerCompensation>();

			CreateMap<Models.CompanyWorkerCompensation, Models.DataModel.CompanyWorkerCompensation>()
				.ForMember(dest => dest.Company, opt => opt.Ignore());

			CreateMap<Models.DataModel.PayType, PayType>();

			CreateMap<Models.DataModel.CompanyAccumlatedPayType, AccumulatedPayType>()
				.ForMember(dest => dest.PayType, opt => opt.MapFrom(src => src.PayType));

			CreateMap<Models.AccumulatedPayType, Models.DataModel.CompanyAccumlatedPayType>()
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.PayType, opt => opt.Ignore());

			CreateMap<Models.DataModel.CompanyPayCode, CompanyPayCode>();
			CreateMap<CompanyPayCode, Models.DataModel.CompanyPayCode>()
				.ForMember(dest => dest.Company, opt => opt.Ignore());


		}
	}
}
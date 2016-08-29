﻿using System;
using System.Collections.Generic;
using System.IO;
using AutoMapper;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxxAPI.Resources.Common;
using HrMaxxAPI.Resources.Journals;
using HrMaxxAPI.Resources.OnlinePayroll;
using HrMaxxAPI.Resources.Payroll;
using Magnum;

namespace HrMaxxAPI.Code.Mappers
{
	public class  OnlinePayrollResourceMapperProfile : ProfileLazy
	{
		public OnlinePayrollResourceMapperProfile(Lazy<IMappingEngine> mapper)
			: base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();

			CreateMap<HostResource, Host>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));

			CreateMap<HomePageResource, HostHomePage>()
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));
			CreateMap<HostHomePage, HomePageResource>()
				.ForMember(dest => dest.StagingId, opt => opt.MapFrom(src => CombGuid.Generate()));

			CreateMap<HostHomePageDocumentResource, HostHomePageDocument>()
				.ForMember(dest => dest.SourceFileName, opt => opt.MapFrom(src => src.file.Name))
				.ForMember(dest => dest.OriginalFileName, opt => opt.MapFrom(src => src.FileName.Replace(Path.GetExtension(src.FileName), string.Empty)))
				.ForMember(dest => dest.FileExtension, opt => opt.MapFrom(src => Path.GetExtension(src.FileName).Replace(".", "")));

			CreateMap<AddressResource, Address>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));

			CreateMap<Address, AddressResource>()
				.ForMember(dest => dest.SourceId, opt => opt.Ignore())
				.ForMember(dest => dest.SourceTypeId, opt => opt.Ignore())
				.ForMember(dest => dest.TargetTypeId, opt => opt.Ignore());

			CreateMap<Company, CompanyResource>()
				.ForMember(dest => dest.CompanyAddress, opt => opt.MapFrom(src => src.CompanyAddress));
				
			CreateMap<CompanyResource, Company>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now))
				.ForMember(dest => dest.CompanyAddress, opt => opt.MapFrom(src => src.CompanyAddress));

			CreateMap<CompanyDeduction, CompanyDeductionResource>();
				
			CreateMap<CompanyDeductionResource, CompanyDeduction>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0));

			CreateMap<CompanyTaxRate, CompanyTaxRateResource>();
			CreateMap<CompanyTaxRateResource, CompanyTaxRate>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0));
			
			CreateMap<CompanyTaxState, CompanyTaxStateResource>();
			CreateMap<CompanyTaxStateResource, CompanyTaxState>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue? src.Id.Value : 0))
				.ForMember(dest => dest.CountryId, opt => opt.MapFrom(src => 1));

			CreateMap<CompanyWorkerCompensation, CompanyWorkerCompensationResource>();
			CreateMap<CompanyWorkerCompensationResource, CompanyWorkerCompensation>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0));
			
			CreateMap<ContractDetails, ContractDetailsResource>();
			CreateMap<ContractDetailsResource, ContractDetails>()
				.ForMember(dest => dest.PrePaidSubscriptionOption, opt => opt.MapFrom(src => src.PrePaidSubscriptionOption.HasValue ? src.PrePaidSubscriptionOption.Value : PrePaidSubscriptionOption.NA));

			CreateMap<BankAccountResource, BankAccount>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now))
				.ForMember(dest => dest.LastModifiedBy, opt => opt.Ignore());
 
			CreateMap<BankAccount, BankAccountResource>();

			CreateMap<AccumulatedPayType, AccumulatedPayTypeResource>();
			CreateMap<AccumulatedPayTypeResource, AccumulatedPayType>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0));

			CreateMap<CompanyPayCode, CompanyPayCodeResource>();
			CreateMap<CompanyPayCodeResource, CompanyPayCode>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0));

			CreateMap<CreditCardResource, CreditCard>();
			CreateMap<CreditCard, CreditCardResource>();

			CreateMap<VendorCustomer, VendorCustomerResource>();
			CreateMap<VendorCustomerResource, VendorCustomer>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));

			CreateMap<AccountResource, Account>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0))
				.ForMember(dest => dest.OpeningDate, opt => opt.MapFrom(src => src.OpeningDate.HasValue ? src.OpeningDate.Value : DateTime.Now)); 

			CreateMap<Account, AccountResource>();

			CreateMap<EmployeeResource, Employee>()
				.ForMember(dest => dest.FirstName, opt => opt.MapFrom(src => src.Contact.FirstName))
				.ForMember(dest => dest.MiddleInitial, opt => opt.MapFrom(src => src.Contact.MiddleInitial))
				.ForMember(dest => dest.LastName, opt => opt.MapFrom(src => src.Contact.LastName))
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));


			CreateMap<Employee, EmployeeResource>();

			CreateMap<EmployeePayTypeResource, EmployeePayType>();
			CreateMap<EmployeePayType, EmployeePayTypeResource>();

			CreateMap<EmployeeStateResource, EmployeeState>();
			CreateMap<EmployeeState, EmployeeStateResource>();


			CreateMap<EmployeeDeductionResource, EmployeeDeduction>()
				.ForMember(dest => dest.Method, opt => opt.MapFrom(src => src.Method.Key))
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue? src.Id : 0));
			CreateMap<EmployeeDeduction, EmployeeDeductionResource>()
				.ForMember(dest => dest.Method, opt => opt.MapFrom(src => src.Method==DeductionMethod.Percentage? new KeyValuePair<int, string>(1, "Percentage") : new KeyValuePair<int, string>(2, "Fixed Rate")));

			CreateMap<PayrollResource, Payroll>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now)); 

			CreateMap<Payroll, PayrollResource>();

			CreateMap<PayCheckResource, PayCheck>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id : 0))
				.ForMember(dest => dest.StartDate, opt => opt.MapFrom(src=>src.StartDate))
				.ForMember(dest => dest.EndDate, opt => opt.MapFrom(src=>src.EndDate))
				.ForMember(dest => dest.PayDay, opt => opt.MapFrom(src=>src.PayDay))
				.ForMember(dest => dest.YTDSalary, opt => opt.Ignore())
				.ForMember(dest => dest.CheckNumber, opt => opt.MapFrom(src => src.CheckNumber.HasValue ? src.CheckNumber : default(int)));
			CreateMap<PayCheck, PayCheckResource>();

			CreateMap<PayrollPayCodeResource, PayrollPayCode>();
			CreateMap<PayrollPayCode, PayrollPayCodeResource>();

			CreateMap<PayTypeAccumulationResource, PayTypeAccumulation>();
			CreateMap<PayTypeAccumulation, PayTypeAccumulationResource>();

			CreateMap<PayrollTaxResource, PayrollTax>();
			CreateMap<PayrollTax, PayrollTaxResource>();

			CreateMap<PayrollPayTypeResource, PayrollPayType>();
			CreateMap<PayrollPayType, PayrollPayTypeResource>();

			CreateMap<CommentResource, Comment>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.TimeStamp, opt => opt.MapFrom(src => DateTime.Now))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));

			CreateMap<Comment, CommentResource>()
				.ForMember(dest => dest.SourceTypeId, opt => opt.Ignore())
				.ForMember(dest => dest.TargetTypeId, opt => opt.Ignore())
				.ForMember(dest => dest.SourceId, opt => opt.Ignore());

			CreateMap<PayrollDeductionResource, PayrollDeduction>()
				.ForMember(dest => dest.Method, opt => opt.MapFrom(src => src.Method.Key));
			CreateMap<PayrollDeduction, PayrollDeductionResource>()
				.ForMember(dest => dest.Method, opt => opt.MapFrom(src => src.Method == DeductionMethod.Percentage ? new KeyValuePair<int, string>(1, "Percentage") : new KeyValuePair<int, string>(2, "Fixed Rate"))); ;

			CreateMap<Journal, JournalResource>();
			CreateMap<JournalResource, Journal>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id : 0))
				.ForMember(dest => dest.Amount, opt => opt.MapFrom(src => Math.Round(src.Amount, 2, MidpointRounding.AwayFromZero)));
			CreateMap<JournalDetail, JournalDetailResource>();
			CreateMap<JournalDetailResource, JournalDetail>()
				.ForMember(dest => dest.Amount, opt => opt.MapFrom(src => Math.Round(src.Amount, 2, MidpointRounding.AwayFromZero)));

			CreateMap<JournalList, JournalListResource>();
		}
	}
}
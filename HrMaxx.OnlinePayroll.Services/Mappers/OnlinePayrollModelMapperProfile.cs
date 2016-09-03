using System;
using System.Collections.Generic;
using System.Linq;
using AutoMapper;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using Magnum;
using Magnum.Extensions;
using Newtonsoft.Json;
using BankAccount = HrMaxx.OnlinePayroll.Models.BankAccount;
using Company = HrMaxx.OnlinePayroll.Models.Company;
using Employee = HrMaxx.OnlinePayroll.Models.Employee;
using PayType = HrMaxx.OnlinePayroll.Models.PayType;
using Tax = HrMaxx.OnlinePayroll.Models.DataModel.Tax;

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
				.ForMember(dest => dest.FirmName, opt => opt.MapFrom(src=>src.FirmName))
				.ForMember(dest => dest.Url, opt => opt.MapFrom(src => src.Url))
				.ForMember(dest => dest.EffectiveDate, opt => opt.MapFrom(src => src.EffectiveDate))
				.ForMember(dest => dest.TerminationDate, opt => opt.MapFrom(src => src.TerminationDate))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => src.StatusId))
				.ForMember(dest => dest.Status, opt => opt.Ignore())
				.ForMember(dest=>dest.HomePage, opt=>opt.Ignore())
				.ForMember(dest => dest.Companies, opt => opt.Ignore())
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src => src.UserName));

			CreateMap<Models.DataModel.Host, Models.Host>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id))
				.ForMember(dest => dest.FirmName, opt => opt.MapFrom(src => src.FirmName))
				.ForMember(dest => dest.Url, opt => opt.MapFrom(src => src.Url))
				.ForMember(dest => dest.EffectiveDate, opt => opt.MapFrom(src => src.EffectiveDate))
				.ForMember(dest => dest.TerminationDate, opt => opt.MapFrom(src => src.TerminationDate))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => src.StatusId))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastModified))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
			.ForMember(dest => dest.UserId, opt => opt.Ignore());

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
				.ForMember(dest => dest.Accumulations, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayTypeAccumulation>>(src.Accumulations)))
				.ForMember(dest => dest.Taxes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollTax>>(src.Taxes)))
				.ForMember(dest => dest.Notes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<Comment>>(src.Notes)))
				.ForMember(dest => dest.Salary, opt => opt.MapFrom(src=>src.Salary))
				.ForMember(dest => dest.YTDGrossWage, opt => opt.Ignore())
				.ForMember(dest => dest.YTDNetWage, opt => opt.Ignore());


			CreateMap<Models.DataModel.Payroll, Models.Payroll>()
				.ForMember(dest => dest.PayChecks, opt => opt.MapFrom(src => src.PayrollPayChecks))
				.ForMember(dest => dest.Company, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<Company>(src.Company)))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.Notes, opt => opt.Ignore())
				.ForMember(dest => dest.StartingCheckNumber, opt => opt.MapFrom(src => src.StartingCheckNumber))
				.ForMember(dest => dest.Status, opt => opt.MapFrom(src => src.Status))
				.ForMember(dest => dest.InvoiceId, opt => opt.MapFrom(src => src.InvoiceId))
				.ForMember(dest => dest.UserId, opt => opt.Ignore());

			CreateMap<Models.Payroll, Models.DataModel.Payroll>()
				.ForMember(dest => dest.PayrollPayChecks, opt => opt.MapFrom(src=>src.PayChecks))
				.ForMember(dest => dest.CompanyId, opt => opt.MapFrom(src => src.Company.Id))
				.ForMember(dest => dest.Company, opt => opt.MapFrom(src =>JsonConvert.SerializeObject(src.Company)))
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src=>src.UserName))
				.ForMember(dest => dest.InvoiceId, opt => opt.Ignore())
				.ForMember(dest => dest.Invoice, opt => opt.Ignore());

			CreateMap<Models.PayCheck, Models.DataModel.PayrollPayCheck>()
				.ForMember(dest => dest.PayrollId, opt => opt.Ignore())
				.ForMember(dest => dest.Payroll, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.PrintStatus, opt => opt.MapFrom(src=>0))
				.ForMember(dest => dest.Journals, opt => opt.Ignore())
				.ForMember(dest => dest.PayrmentMethod, opt => opt.MapFrom(src=>src.PaymentMethod))
				.ForMember(dest => dest.Employee, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Employee)))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.PayCodes)))
				.ForMember(dest => dest.Compensations, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Compensations)))
				.ForMember(dest => dest.Accumulations, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Accumulations)))
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Deductions)))
				.ForMember(dest => dest.Taxes, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Taxes)))
				.ForMember(dest => dest.Notes, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Notes)));

			CreateMap<Models.Journal, Models.DataModel.Journal>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src=>src.Id))
				.ForMember(dest => dest.CompanyAccount, opt => opt.Ignore())
				.ForMember(dest => dest.Company, opt => opt.Ignore())
				.ForMember(dest => dest.EntityType1, opt => opt.Ignore())
				.ForMember(dest => dest.PayrollPayCheck, opt => opt.Ignore())
				.ForMember(dest => dest.JournalDetails, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.JournalDetails)));

			CreateMap<Models.Account, Models.AccountWithJournal>()
				.ForMember(dest => dest.Journals, opt => opt.MapFrom(src=>new List<AccountRegister>()))
				.ForMember(dest => dest.AccountBalance, opt => opt.MapFrom(src=>(decimal)0));

			CreateMap<Models.DataModel.Journal, Models.Journal>()
				.ForMember(dest => dest.JournalDetails, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<Models.JournalDetail>>(src.JournalDetails)));

			CreateMap<Models.CompanyPayrollCube, Models.DataModel.CompanyPayrollCube>()
				.ForMember(dest => dest.Accumulation, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Accumulation)));

			CreateMap<Models.Invoice, Models.DataModel.Invoice>()
				.ForMember(dest => dest.Payrolls, opt => opt.Ignore())
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src=>src.UserName))
				.ForMember(dest => dest.LineItems, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.LineItems)))
				.ForMember(dest => dest.Payments, opt => opt.MapFrom(src => JsonConvert.SerializeObject(src.Payments)));

			CreateMap<Models.DataModel.Invoice, Models.Invoice>()
				.ForMember(dest => dest.PayrollIds, opt => opt.MapFrom(src=>src.Payrolls.Select(p=>p.Id).ToList()))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastModifiedBy))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.LineItems, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<InvoiceLineItem>>(src.LineItems)))
				.ForMember(dest => dest.Payments, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<InvoicePayment>>(src.Payments))); 
		}
	}
}
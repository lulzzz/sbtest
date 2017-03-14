using System;
using System.Collections.Generic;
using System.IO;
using AutoMapper;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using HrMaxxAPI.Resources.Common;
using HrMaxxAPI.Resources.Journals;
using HrMaxxAPI.Resources.OnlinePayroll;
using HrMaxxAPI.Resources.Payroll;
using HrMaxxAPI.Resources.Reports;
using Magnum;
using Newtonsoft.Json;
using BankAccount = HrMaxx.OnlinePayroll.Models.BankAccount;
using CompanyDeduction = HrMaxx.OnlinePayroll.Models.CompanyDeduction;
using CompanyPayCode = HrMaxx.OnlinePayroll.Models.CompanyPayCode;
using CompanyTaxRate = HrMaxx.OnlinePayroll.Models.CompanyTaxRate;
using CompanyTaxState = HrMaxx.OnlinePayroll.Models.CompanyTaxState;
using CompanyWorkerCompensation = HrMaxx.OnlinePayroll.Models.CompanyWorkerCompensation;
using EmployeeBankAccount = HrMaxx.OnlinePayroll.Models.EmployeeBankAccount;
using EmployeeDeduction = HrMaxx.OnlinePayroll.Models.EmployeeDeduction;

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

			CreateMap<HostAndCompanies, HostAndCompaniesResource>();
			CreateMap<HostListItem, HostListItemResource>()
				.ForMember(dest => dest.HomePage, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<HostHomePage>(src.HomePage)))
				.ForMember(dest => dest.Contact, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.Contact) ? JsonConvert.DeserializeObject<Contact>(src.Contact) : null));
			CreateMap<CompanyListItem, CompanyListItemResource>()
				.ForMember(dest => dest.InvoiceSetup, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.InvoiceSetup) ? JsonConvert.DeserializeObject<InvoiceSetup>(src.InvoiceSetup) : null))
				.ForMember(dest => dest.CompanyAddress, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.CompanyAddress) ? JsonConvert.DeserializeObject<Address>(src.CompanyAddress) : null))
				.ForMember(dest => dest.FederalEIN, opt => opt.MapFrom(src => Crypto.Decrypt(src.FederalEIN)))
				.ForMember(dest => dest.Contact, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.Contact) ? JsonConvert.DeserializeObject<Contact>(src.Contact) : null));

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
				.ForMember(dest => dest.Created, opt => opt.MapFrom(src => !src.Created.HasValue ? DateTime.Now : src.Created))
				.ForMember(dest => dest.CompanyAddress, opt => opt.MapFrom(src => src.CompanyAddress));

			CreateMap<CompanyDeduction, CompanyDeductionResource>();
				
			CreateMap<CompanyDeductionResource, CompanyDeduction>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0))
				.ForMember(dest => dest.DeductionType, opt => opt.Ignore());

			CreateMap<CompanyLocationResource, CompanyLocation>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => CombGuid.Generate()));
			CreateMap<CompanyLocation, CompanyLocationResource>();

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
				.ForMember(dest => dest.LastModifiedBy, opt => opt.Ignore())
				.ForMember(dest => dest.RoutingNumber1, opt => opt.Ignore());
 
			CreateMap<BankAccount, BankAccountResource>();

			CreateMap<AccumulatedPayType, AccumulatedPayTypeResource>();
			CreateMap<AccumulatedPayTypeResource, AccumulatedPayType>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0));

			CreateMap<CompanyPayCode, CompanyPayCodeResource>();
			CreateMap<CompanyPayCodeResource, CompanyPayCode>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0));


			CreateMap<InvoiceSetup, InvoiceSetupResource>();
			CreateMap<InvoiceSetupResource, InvoiceSetup>();

			CreateMap<RecurringCharge, RecurringChargeResource>();
			CreateMap<RecurringChargeResource, RecurringCharge>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0)); ;
			CreateMap<SalesRepResource, SalesRep>();
			CreateMap<SalesRep, SalesRepResource>();

			CreateMap<CreditCardResource, CreditCard>();
			CreateMap<CreditCard, CreditCardResource>();

			CreateMap<VendorCustomer, VendorCustomerResource>();
			CreateMap<VendorCustomerResource, VendorCustomer>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.IdentifierType, opt => opt.MapFrom(src => src.IdentifierType.HasValue ? src.IdentifierType.Value : VCIdentifierType.NA))
				.ForMember(dest => dest.Type1099, opt => opt.MapFrom(src => src.Type1099.HasValue ? src.Type1099.Value : F1099Type.NA))
				.ForMember(dest => dest.SubType1099, opt => opt.MapFrom(src => src.SubType1099.HasValue ? src.SubType1099.Value : F1099SubType.NA))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));

			CreateMap<AccountResource, Account>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0))
				.ForMember(dest => dest.OpeningDate, opt => opt.MapFrom(src => src.OpeningDate.HasValue ? src.OpeningDate.Value : DateTime.Now)); 

			CreateMap<Account, AccountResource>();

			CreateMap<EmployeeResource, Employee>()
				.ForMember(dest => dest.FirstName, opt => opt.MapFrom(src => src.Contact.FirstName))
				.ForMember(dest => dest.MiddleInitial, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.Contact.MiddleInitial) ? src.Contact.MiddleInitial.Substring(0,1) : string.Empty))
				.ForMember(dest => dest.LastName, opt => opt.MapFrom(src => src.Contact.LastName))
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));


			CreateMap<Employee, EmployeeResource>();

			CreateMap<EmployeePayTypeResource, EmployeePayType>();
			CreateMap<EmployeePayType, EmployeePayTypeResource>();

			CreateMap<EmployeeStateResource, EmployeeState>();
			CreateMap<EmployeeState, EmployeeStateResource>();

			CreateMap<EmployeeBankAccount, EmployeeBankAccountResource>();
			CreateMap<EmployeeBankAccountResource, EmployeeBankAccount>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0));


			CreateMap<EmployeeDeductionResource, EmployeeDeduction>()
				.ForMember(dest => dest.Method, opt => opt.MapFrom(src => src.Method.Key))
				.ForMember(dest => dest.CeilingMethod, opt => opt.MapFrom(src => src.CeilingMethod.HasValue ? src.CeilingMethod.Value : 1))
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue? src.Id : 0));
			CreateMap<EmployeeDeduction, EmployeeDeductionResource>()
				.ForMember(dest => dest.Method, opt => opt.MapFrom(src => src.Method==DeductionMethod.Percentage? new KeyValuePair<int, string>(1, "Percentage") : new KeyValuePair<int, string>(2, "Amount")));

			CreateMap<PayrollResource, Payroll>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id : CombGuid.Generate()))
				.ForMember(dest => dest.StartDate, opt => opt.MapFrom(src => src.StartDate.Date))
				.ForMember(dest => dest.EndDate, opt => opt.MapFrom(src => src.EndDate.Date))
				.ForMember(dest => dest.PayDay, opt => opt.MapFrom(src => src.PayDay.Date))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now)); 

			CreateMap<Payroll, PayrollResource>();

			CreateMap<PayCheckResource, PayCheck>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id : 0))
				.ForMember(dest => dest.PayrollId, opt => opt.Ignore())
				.ForMember(dest => dest.StartDate, opt => opt.MapFrom(src=>src.StartDate.Value.Date))
				.ForMember(dest => dest.EndDate, opt => opt.MapFrom(src=>src.EndDate.Value.Date))
				.ForMember(dest => dest.PayDay, opt => opt.MapFrom(src=>src.PayDay.Value.Date))
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

			CreateMap<PayrollWorkerCompensation, PayrollWorkerCompensationResource>();
			CreateMap<PayrollWorkerCompensationResource, PayrollWorkerCompensation>();

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
				.ForMember(dest => dest.DocumentId, opt => opt.MapFrom(src => src.DocumentId.HasValue ? src.DocumentId.Value : CombGuid.Generate()))
				.ForMember(dest => dest.Amount, opt => opt.MapFrom(src => Math.Round(src.Amount, 2, MidpointRounding.AwayFromZero)));
			CreateMap<JournalDetail, JournalDetailResource>();
			CreateMap<JournalDetailResource, JournalDetail>()
				.ForMember(dest => dest.Amount, opt => opt.MapFrom(src => Math.Round(src.Amount, 2, MidpointRounding.AwayFromZero)));

			CreateMap<JournalList, JournalListResource>();

			CreateMap<InvoiceResource, Invoice>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now)); 
			CreateMap<InvoiceLineItemResource, InvoiceLineItem>();
			CreateMap<InvoicePaymentResource, InvoicePayment>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : 0));

			CreateMap<InvoiceLineItem, InvoiceLineItemResource>();
			CreateMap<InvoicePayment, InvoicePaymentResource>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false)); 

			CreateMap<Invoice, InvoiceResource>();

			CreateMap<ReportRequestResource, ReportRequest>()
				.ForMember(dest => dest.Description, opt => opt.Ignore())
				.ForMember(dest => dest.AllowFiling, opt => opt.Ignore())
				.ForMember(dest => dest.AllowExclude, opt => opt.Ignore())
				.ForMember(dest => dest.IncludeVoids, opt => opt.Ignore())
				.ForMember(dest => dest.StartDate, opt => opt.MapFrom(src => src.StartDate.HasValue ? src.StartDate.Value : DateTime.MinValue))
				.ForMember(dest => dest.EndDate, opt => opt.MapFrom(src => src.EndDate.HasValue ? src.EndDate.Value : DateTime.MinValue));

			CreateMap<ReportResponse, ReportResponseResource>();

			CreateMap<PayrollInvoiceResource, PayrollInvoice>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.Id.HasValue ? src.Id.Value : CombGuid.Generate()))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));
				
			CreateMap<PayrollInvoice, PayrollInvoiceResource>()
				.ForMember(dest => dest.TaxPaneltyConfig, opt => opt.Ignore());

			CreateMap<DashboardRequestResource, DashboardRequest>()
				.ForMember(dest => dest.Host, opt => opt.Ignore())
				.ForMember(dest => dest.Role, opt => opt.Ignore());

			CreateMap<CaliforniaCompanyTaxResource, CaliforniaCompanyTax>()
				.ForMember(dest => dest.UiRate, opt => opt.MapFrom(src => src.UiRate == 0 ? src.DefaultUiRate : src.UiRate))
				.ForMember(dest => dest.EttRate, opt => opt.MapFrom(src => src.EttRate == 0 ? src.DefaultEttRate : src.EttRate))
				.ForMember(dest => dest.CompanyId, opt => opt.MapFrom(src => src.CompanyId.Value));

			CreateMap<HrMaxx.OnlinePayroll.Models.JsonDataModel.CompanyTaxState, HrMaxx.OnlinePayroll.Models.CompanyTaxState>()
				.ForMember(dest => dest.State, opt => opt.MapFrom(src => src))
				.ForMember(dest => dest.StateEIN, opt => opt.MapFrom(src => Crypto.Decrypt(src.EIN)))
				.ForMember(dest => dest.StatePIN, opt => opt.MapFrom(src => Crypto.Decrypt(src.Pin)));

			CreateMap<HrMaxx.OnlinePayroll.Models.JsonDataModel.CompanyTaxState, State>()
				.ForMember(dest => dest.Abbreviation, opt => opt.MapFrom(src => src.StateCode))
				.ForMember(dest => dest.TaxesEnabled, opt => opt.Ignore())
				.ForMember(dest => dest.StateId, opt => opt.MapFrom(src => src.StateId))
				.ForMember(dest => dest.StateName, opt => opt.MapFrom(src => src.StateName));
			CreateMap<HrMaxx.OnlinePayroll.Models.JsonDataModel.InsuranceGroup, HrMaxx.Common.Models.InsuranceGroupDto>();

			CreateMap<CommissionsReportRequestResource, CommissionsReportRequest>()
				.ForMember(dest => dest.AllowFiling, opt => opt.Ignore())
				.ForMember(dest => dest.Description, opt => opt.Ignore());

			CreateMap<PayrollInvoiceListItem, PayrollInvoiceListItemResource>()
				.ForMember(dest => dest.TaxPaneltyConfig, opt => opt.Ignore())
				.ForMember(dest => dest.BusinessAddress, opt => opt.MapFrom(src=>JsonConvert.DeserializeObject<Address>(src.BusinessAddress)))
				.ForMember(dest => dest.EmployeeTaxes, opt => opt.MapFrom(src=>JsonConvert.DeserializeObject<List<PayrollTax>>(src.EmployeeTaxes)))
				.ForMember(dest => dest.EmployerTaxes, opt => opt.MapFrom(src => JsonConvert.DeserializeObject<List<PayrollTax>>(src.EmployerTaxes)));
		}
	}
}
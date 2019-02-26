using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Security;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using Magnum;

namespace OPImportUtility
{
	public class OPImportMapperProfile : ProfileLazy
	{
		public OPImportMapperProfile(Lazy<IMappingEngine> mapper)
			: base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();
			CreateMap<CPA, HrMaxx.OnlinePayroll.Models.Host>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => CombGuid.Generate()))
				.ForMember(dest => dest.HostIntId, opt => opt.MapFrom(src => src.CPAID))
				.ForMember(dest => dest.FirmName, opt => opt.MapFrom(src => src.CPAFirmName))
				.ForMember(dest => dest.TerminationDate, opt => opt.MapFrom(src => src.CPATermDate))
				.ForMember(dest => dest.EffectiveDate, opt => opt.MapFrom(src => src.CPAEffDate))
				.ForMember(dest => dest.Url, opt => opt.MapFrom(src => src.URL1.Replace(".hrmaxx.com", string.Empty)))
				.ForMember(dest => dest.StatusId,
					opt => opt.MapFrom(src => src.Status.Equals("A") ? 1 : src.Status.Equals("I") ? 2 : 3))
					.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastUpdateDate))
					.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastUpdateBy.Equals("0") ? "17" : src.LastUpdateBy))
					.ForMember(dest => dest.IsPeoHost, opt => opt.MapFrom(src => false));

			CreateMap<Company, HrMaxx.OnlinePayroll.Models.Company>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => CombGuid.Generate()))
				.ForMember(dest => dest.CompanyIntId, opt => opt.MapFrom(src => src.CompanyID))
				.ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.CompanyName))
				.ForMember(dest => dest.CompanyNo, opt => opt.MapFrom(src => src.CompanyNo))
				.ForMember(dest => dest.StatusId,
					opt =>
						opt.MapFrom(
							src =>
								src.Status.Equals("A")
									? StatusOption.Active
									: src.Status.Equals("I") ? StatusOption.InActive : StatusOption.Terminated))
				.ForMember(dest => dest.FileUnderHost, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.IsHostCompany, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.PayrollDaysInPast, opt => opt.MapFrom(src => src.PastDays))
				.ForMember(dest => dest.DirectDebitPayer, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.ProfitStarsPayer, opt => opt.MapFrom(src => src.DirectDebitPayer))
				.ForMember(dest => dest.PayCheckStock,
					opt =>
						opt.MapFrom(
							src =>
								src.CheckStock.Equals("Deluxe")
									? PayCheckStock.LaserTop
									: src.CheckStock.Equals("New")
										? PayCheckStock.MICRQb
										: src.CheckStock.Equals("Blank") ? PayCheckStock.MICREncodedTop : PayCheckStock.LaserMiddle))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => (PayrollSchedule) src.PayrollPeriodID))
				.ForMember(dest => dest.Memo, opt => opt.MapFrom(src => src.Memo))
				.ForMember(dest => dest.TaxFilingName, opt => opt.MapFrom(src => src.TaxFilingName))
				.ForMember(dest => dest.AllowTaxPayments, opt => opt.MapFrom(src => src.ProcessTaxPayments))
				.ForMember(dest => dest.AllowEFileFormFiling, opt => opt.MapFrom(src => !src.efiler))
				.ForMember(dest => dest.FederalEIN, opt => opt.MapFrom(src => Crypto.Decrypt(src.FEIN).Replace("-", string.Empty)))
				.ForMember(dest => dest.FederalPin, opt => opt.MapFrom(src => Crypto.Decrypt(src.FEPIN)))
				.ForMember(dest => dest.DepositSchedule,
					opt =>
						opt.MapFrom(
							src =>
								src.DepositSchedule941.Equals("EachPayroll")
									? DepositSchedule941.SemiWeekly
									: src.DepositSchedule941.Equals("Monthly") ? DepositSchedule941.Monthly : DepositSchedule941.Quarterly))
				.ForMember(dest => dest.IsFiler944, opt => opt.MapFrom(src => src.Depositor944))
				.ForMember(dest => dest.IsFiler1095, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.Created, opt => opt.MapFrom(src => src.EnteredDate))
				.ForMember(dest => dest.LastPayrollDate, opt => opt.MapFrom(src => src.PayDate))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastUpdateDate))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => src.LastUpdateBy))
				.ForMember(dest => dest.InsuranceClientNo, opt => opt.MapFrom(src => "0000"))
				.ForMember(dest => dest.MinWage, opt => opt.MapFrom(src => 10.5))
				.ForMember(dest => dest.PayrollScheduleDay, opt => opt.MapFrom(src => src.PayrollPeriodID==4?23:src.PayrollPeriodID==3?22:src.PayrollPeriodID==1?1:8))
				.ForMember(dest => dest.CompanyCheckPrintOrder, opt => opt.MapFrom(src => CompanyCheckPrintOrder.EmployeeLastName));

			CreateMap<BillingDetail, HrMaxx.Common.Models.Dtos.Address>()
				.ForMember(dest => dest.AddressLine1, opt => opt.MapFrom(src => Crypto.Decrypt(src.billingAddressLine1)))
				.ForMember(dest => dest.City, opt => opt.MapFrom(src => Crypto.Decrypt(src.billingAddressLine2)))
				.ForMember(dest => dest.Zip, opt => opt.MapFrom(src => Crypto.Decrypt(src.billingAddressZip)))
				.ForMember(dest => dest.ZipExtension, opt => opt.MapFrom(src => string.Empty))
				.ForMember(dest => dest.Id, opt => opt.Ignore())
				.ForMember(dest => dest.Type, opt => opt.MapFrom(src => AddressType.Business))
				.ForMember(dest => dest.StateId, opt => opt.MapFrom(src=>1))
				.ForMember(dest => dest.CountryId, opt => opt.MapFrom(src => 1));

			CreateMap<BillingDetail, HrMaxx.OnlinePayroll.Models.CreditCard>()
				.ForMember(dest => dest.CardType, opt => opt.MapFrom(src => Crypto.Decrypt(src.CardType)))
				.ForMember(dest => dest.CardNumber, opt => opt.MapFrom(src => Crypto.Decrypt(src.CardNumber)))
				.ForMember(dest => dest.CardName, opt => opt.MapFrom(src => Crypto.Decrypt(src.CardName)))
				.ForMember(dest => dest.SecurityCode, opt => opt.MapFrom(src => Crypto.Decrypt(src.CardCode)))
				.ForMember(dest => dest.ExpiryMonth, opt => opt.MapFrom(src => Crypto.Decrypt(src.CardExpiryMonth)))
				.ForMember(dest => dest.ExpiryYear, opt => opt.MapFrom(src => Crypto.Decrypt(src.CardExpiryYear)))
				.ForMember(dest => dest.BillingAddress, opt => opt.MapFrom(src => src));

			CreateMap<BankAccount, HrMaxx.OnlinePayroll.Models.BankAccount>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => src.AccountId))
				.ForMember(dest => dest.BankName, opt => opt.MapFrom(src => src.BankName))
				.ForMember(dest => dest.AccountName, opt => opt.Ignore())
				.ForMember(dest => dest.AccountType,
					opt => opt.MapFrom(src => src.AccountType.Equals("Checking") ? BankAccountType.Checking : BankAccountType.Savings))
				.ForMember(dest => dest.AccountNumber, opt => opt.MapFrom(src => Crypto.Decrypt(src.AccountNumber)))
				.ForMember(dest => dest.RoutingNumber, opt => opt.MapFrom(src => Crypto.Decrypt(src.RoutingNumber)))
				.ForMember(dest => dest.SourceId, opt => opt.Ignore())
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastUpdateDate))
				.ForMember(dest => dest.LastModifiedBy, opt => opt.MapFrom(src => src.LastUpdateBy))
				.ForMember(dest => dest.SourceTypeId, opt => opt.MapFrom(src => src.EntityTypeID==5?EntityTypeEnum.Company : EntityTypeEnum.Employee));

			CreateMap<Vendors, HrMaxx.OnlinePayroll.Models.VendorCustomer>()
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => CombGuid.Generate()))
				.ForMember(dest => dest.VendorCustomerIntId, opt => opt.MapFrom(src => src.VendorCustomerID))
				.ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.VendorCustomerName))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => src.VendorCustomerstatus.Equals("A") ? StatusOption.Active : src.VendorCustomerstatus.Equals("I") ? StatusOption.InActive :  StatusOption.Terminated))
				.ForMember(dest => dest.AccountNo, opt => opt.MapFrom(src => src.Acct_No))
				.ForMember(dest => dest.IsVendor, opt => opt.MapFrom(src => src.IsCustomer.Equals("N")))
				.ForMember(dest => dest.Note, opt => opt.MapFrom(src => src.VendorCustNotes))
				.ForMember(dest => dest.IsVendor1099, opt => opt.MapFrom(src => src.Vendor1099.Equals("Y")))
				.ForMember(dest => dest.IsAgency, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.Type1099, opt => opt.MapFrom(src=>string.IsNullOrWhiteSpace(src.Type1099) ? F1099Type.NA : (F1099Type)HrMaaxxSecurity.GetEnumFromDbName<F1099Type>(src.Type1099.Replace("-", " "))))
				.ForMember(dest => dest.SubType1099, opt => opt.MapFrom(src => string.IsNullOrWhiteSpace(src.SubType1099) ? F1099SubType.NA : (F1099SubType)HrMaaxxSecurity.GetEnumFromDbName<F1099SubType>(src.SubType1099.Replace("-", " "))))
				.ForMember(dest => dest.IndividualSSN, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.IndividualSSN) ? Crypto.Decrypt(src.IndividualSSN) : string.Empty))
				.ForMember(dest => dest.BusinessFIN, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.BusinessFIN) ? Crypto.Decrypt(src.BusinessFIN) : string.Empty))
				.ForMember(dest => dest.IsTaxDepartment, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => !src.LastUpdateDate.HasValue ? DateTime.Now : src.LastUpdateDate))
				.ForMember(dest => dest.UserName, opt => opt.Ignore())
				.ForMember(dest => dest.Contact, opt => opt.MapFrom(src => src))
				.ForMember(dest => dest.IdentifierType, opt => opt.Ignore());

			CreateMap<Vendors, HrMaxx.Common.Models.Dtos.Contact>()
				.ForMember(dest => dest.FirstName, opt => opt.MapFrom(src=>src.ContactFirstName))
				.ForMember(dest => dest.LastName, opt => opt.MapFrom(src=>src.ContactLastName))
				.ForMember(dest => dest.MiddleInitial, opt => opt.MapFrom(src=>src.ContactMiddleInitial))
				.ForMember(dest => dest.Email, opt => opt.Ignore())
				.ForMember(dest => dest.Address, opt => opt.MapFrom(src=>src));

			CreateMap<Vendors, HrMaxx.Common.Models.Dtos.Address>()
				.ForMember(dest => dest.AddressLine1, opt => opt.MapFrom(src=>src.ContactAddress))
				.ForMember(dest => dest.City, opt => opt.MapFrom(src=>src.ContactCity))
				.ForMember(dest => dest.Type, opt => opt.Ignore())
				.ForMember(dest => dest.StateId, opt => opt.MapFrom(src=>!string.IsNullOrWhiteSpace(src.ContactState) ? ((USStates)HrMaaxxSecurity.GetEnumFromHrMaxxName<USStates>(src.ContactState)).GetDbId() : 1))
				.ForMember(dest => dest.Zip, opt => opt.MapFrom(src=>src.ContactZip))
				.ForMember(dest => dest.ZipExtension, opt => opt.MapFrom(src=>src.ContactZipExt));

			CreateMap<Employee, HrMaxx.OnlinePayroll.Models.Employee>()
				.ForMember(dest => dest.HostId, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => CombGuid.Generate()))
				.ForMember(dest => dest.EmployeeIntId, opt => opt.MapFrom(src => src.EmployeeID))
				.ForMember(dest => dest.CompanyEmployeeNo, opt => opt.MapFrom(src => src.EmployeeNo))
				.ForMember(dest => dest.FirstName, opt => opt.MapFrom(src => src.FirstName))
				.ForMember(dest => dest.MiddleInitial, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.MiddleName) ? src.MiddleName.Substring(0,1) : string.Empty))
				.ForMember(dest => dest.LastName, opt => opt.MapFrom(src => src.LastName))
				.ForMember(dest => dest.Contact, opt => opt.Ignore())
				.ForMember(dest => dest.Gender, opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<GenderType>(string.IsNullOrWhiteSpace(src.Gender) ? "NA" : src.Gender)))
				.ForMember(dest => dest.SSN, opt => opt.MapFrom(src => Crypto.Decrypt(src.EmployeeSSN)))
				.ForMember(dest => dest.BirthDate, opt => opt.Ignore())
				.ForMember(dest => dest.HireDate, opt => opt.MapFrom(src => src.HireDate.HasValue ? src.HireDate.Value : new DateTime(1970,1,1)))
				.ForMember(dest => dest.SickLeaveHireDate, opt => opt.Ignore())
				.ForMember(dest => dest.CarryOver, opt => opt.MapFrom(src => 0))
				.ForMember(dest => dest.Department, opt => opt.MapFrom(src => src.Department))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => src.Status.Equals("A") ? StatusOption.Active : src.Status.Equals("I") ? StatusOption.InActive :  StatusOption.Terminated))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbId<PayrollSchedule>(src.PayrollPeriodID)))
				.ForMember(dest => dest.PayType, opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<EmployeeType>(src.PayType)))
				.ForMember(dest => dest.Rate, opt => opt.MapFrom(src => src.PayRateAmount))
				.ForMember(dest => dest.PaymentMethod, opt => opt.MapFrom(src => string.IsNullOrWhiteSpace(src.PaymentMethod) || src.PaymentMethod.Equals("C") ? EmployeePaymentMethod.Check : src.PaymentMethod.Equals("DD") ? EmployeePaymentMethod.ProfitStars : EmployeePaymentMethod.DirectDebit))
				.ForMember(dest => dest.DirectDebitAuthorized, opt => opt.MapFrom(src => src.DDCert))
				.ForMember(dest => dest.TaxCategory, opt => opt.MapFrom(src => src.EmployeeType==2 ? EmployeeTaxCategory.NonImmigrantAlien : EmployeeTaxCategory.USWorkerNonVisa))
				.ForMember(dest => dest.FederalStatus, opt => opt.MapFrom(src => src.FedFilingStatus.Equals("UHH") ? EmployeeTaxStatus.UnmarriedHeadofHousehold : src.FedFilingStatus.Equals("MFJ") ? EmployeeTaxStatus.Married : EmployeeTaxStatus.Single))
				.ForMember(dest => dest.FederalExemptions, opt => opt.MapFrom(src => src.FedExemptions))
				.ForMember(dest => dest.FederalAdditionalAmount, opt => opt.MapFrom(src => src.FedAdditionalAmount))
				.ForMember(dest => dest.State, opt => opt.Ignore())
				.ForMember(dest => dest.Compensations, opt => opt.MapFrom(src=>new List<HrMaxx.OnlinePayroll.Models.EmployeePayType>()))
				.ForMember(dest => dest.WorkerCompensation, opt => opt.Ignore())
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => new List<CompanyPayCode>()))
				.ForMember(dest => dest.Memo, opt => opt.MapFrom(src => src.W2Memo))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => src.LastUpdateDate));
				





		}
	}
}

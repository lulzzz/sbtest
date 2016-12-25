using System;
using System.Collections.Generic;
using System.IO;
using System.Web.Http.ModelBinding;
using AutoMapper;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Services.Mappers;
using Magnum;

namespace SiteInspectionStatus_Utility
{
	public class  ImportMapperProfile : ProfileLazy
	{
		public ImportMapperProfile(Lazy<IMappingEngine> mapper)
			: base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();


			CreateMap<SiteInspectionStatus_Utility.Company, HrMaxx.OnlinePayroll.Models.Company>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => CombGuid.Generate()))
				.ForMember(dest => dest.AllowEFileFormFiling, opt => opt.MapFrom(src => src.ManageEFileForms.Equals("1")))
				.ForMember(dest => dest.AllowTaxPayments, opt => opt.MapFrom(src => src.ManageTaxPayment.Equals("1")))
				.ForMember(dest => dest.CompanyNo, opt => opt.MapFrom(src => src.CompanyNo))
				.ForMember(dest => dest.CompanyNumber, opt => opt.MapFrom(src => 0))
				.ForMember(dest => dest.Created, opt => opt.MapFrom(src => DateTime.Now))
				.ForMember(dest => dest.DepositSchedule, opt => opt.MapFrom(src => src.DepositSchedule941))
				.ForMember(dest => dest.DirectDebitPayer, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.FederalEIN, opt => opt.MapFrom(src => src.FederalEIN))
				.ForMember(dest => dest.FederalPin, opt => opt.MapFrom(src => src.FederalPIN))
				.ForMember(dest => dest.FileUnderHost, opt => opt.MapFrom(src => src.FileUnderHost.Equals("1")))
				.ForMember(dest => dest.HostId, opt => opt.MapFrom(src => new Guid(src.HostId)))
				.ForMember(dest => dest.InsuranceClientNo, opt => opt.MapFrom(src => src.InsuranceClientNo))
				.ForMember(dest => dest.InsuranceGroupNo, opt => opt.MapFrom(src => Convert.ToInt32(src.InsuranceGroupNo)))
				.ForMember(dest => dest.IsAddressSame, opt => opt.MapFrom(src => true))
				.ForMember(dest => dest.IsFiler944, opt => opt.MapFrom(src => src.IsFiler944.Equals("1")))
				.ForMember(dest => dest.IsHostCompany, opt => opt.MapFrom(src => src.IsHostCompany.Equals("1")))
				.ForMember(dest => dest.IsVisibleToHost, opt => opt.MapFrom(src => true))
				.ForMember(dest => dest.Memo, opt => opt.MapFrom(src => src.Memo))
				.ForMember(dest => dest.MinWage, opt => opt.MapFrom(src => 10))
				.ForMember(dest => dest.Name, opt => opt.MapFrom(src => src.Name))
				.ForMember(dest => dest.PayCheckStock, opt => opt.MapFrom(src => src.PayCheckStock))
				.ForMember(dest => dest.PayrollDaysInPast, opt => opt.MapFrom(src => 0))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => (StatusOption)1))
				.ForMember(dest => dest.TaxFilingName, opt => opt.MapFrom(src => src.TaxFilingName))

				.ForMember(dest => dest.AccumulatedPayTypes, opt => opt.Ignore())
				.ForMember(dest => dest.BusinessAddress, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyAddress, opt => opt.Ignore())
				.ForMember(dest => dest.CompanyTaxRates, opt => opt.Ignore())
				.ForMember(dest => dest.Contract, opt => opt.Ignore())
				.ForMember(dest => dest.Deductions, opt => opt.MapFrom(src=>new List<CompanyDeduction>()))
				.ForMember(dest => dest.InsuranceGroup, opt => opt.Ignore())
				.ForMember(dest => dest.IsLocation, opt => opt.Ignore())
				.ForMember(dest => dest.LastPayrollDate, opt => opt.Ignore())
				.ForMember(dest => dest.Locations, opt => opt.Ignore())
				.ForMember(dest => dest.ParentId, opt => opt.MapFrom(src=> !string.IsNullOrWhiteSpace(src.ParentId) ? new Guid(src.ParentId) : default(Guid?)))
				.ForMember(dest => dest.PayCodes, opt => opt.Ignore())
				.ForMember(dest => dest.States, opt => opt.Ignore())
				.ForMember(dest => dest.WorkerCompensations, opt => opt.MapFrom(src=>new List<CompanyWorkerCompensation>()))
				.ForMember(dest => dest.UserId, opt => opt.Ignore())
				.ForMember(dest => dest.UserName, opt => opt.Ignore())
				.ForMember(dest => dest.LastModified, opt => opt.Ignore());



			CreateMap<SiteInspectionStatus_Utility.CompanyDeduction, HrMaxx.OnlinePayroll.Models.CompanyDeduction>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src=>0))
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.Type, opt => opt.Ignore())
				.ForMember(dest => dest.FloorPerCheck, opt => opt.MapFrom(src=>default(decimal?)))
				.ForMember(dest => dest.DeductionName, opt => opt.MapFrom(src => src.DeductionName))
				.ForMember(dest => dest.Description, opt => opt.MapFrom(src=>src.Description))
				.ForMember(dest => dest.AnnualMax, opt => opt.MapFrom(src=>0))
				.ForMember(dest => dest.W2_12, opt => opt.Ignore())
				.ForMember(dest => dest.W2_13R, opt => opt.Ignore())
				.ForMember(dest => dest.R940_R, opt => opt.Ignore());
			CreateMap<SiteInspectionStatus_Utility.CompanyWorkerCompensation, HrMaxx.OnlinePayroll.Models.CompanyWorkerCompensation>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => 0))
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.Code, opt => opt.MapFrom(src => Convert.ToInt32(src.Code)))
				.ForMember(dest => dest.Rate, opt => opt.MapFrom(src => Convert.ToDecimal(src.Rate)))
				.ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Description))
				.ForMember(dest => dest.MinGrossWage, opt => opt.MapFrom(src => src.MinGrossWage.Equals("0") ? default(decimal?) : Convert.ToDecimal(src.MinGrossWage)));
			
			CreateMap<SiteInspectionStatus_Utility.Employee, HrMaxx.OnlinePayroll.Models.Employee>()
				.ForMember(dest => dest.Id, opt => opt.MapFrom(src => CombGuid.Generate()))
				.ForMember(dest => dest.CompanyId, opt => opt.Ignore())
				.ForMember(dest => dest.HostId, opt => opt.Ignore())
				.ForMember(dest => dest.FirstName, opt => opt.MapFrom(src => src.FirstName))
				.ForMember(dest => dest.MiddleInitial, opt => opt.MapFrom(src => !string.IsNullOrWhiteSpace(src.MiddleInitial) ? src.MiddleInitial.Substring(0,1) : string.Empty))
				.ForMember(dest => dest.LastName, opt => opt.MapFrom(src => src.LastName))
				.ForMember(dest => dest.Contact, opt => opt.Ignore())
				.ForMember(dest => dest.Gender, opt => opt.MapFrom(src => GenderType.NA))
				.ForMember(dest => dest.SSN, opt => opt.MapFrom(src => src.SSN))
				.ForMember(dest => dest.BirthDate, opt => opt.Ignore())
				.ForMember(dest => dest.HireDate, opt => opt.MapFrom(src => Convert.ToDateTime(src.HireDate)))
				.ForMember(dest => dest.Department, opt => opt.MapFrom(src => src.Department))
				.ForMember(dest => dest.StatusId, opt => opt.MapFrom(src => StatusOption.Active))
				.ForMember(dest => dest.EmployeeNo, opt => opt.MapFrom(src => src.EmployeeNo))
				.ForMember(dest => dest.Memo, opt => opt.MapFrom(src => src.Memo))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => (PayrollSchedule)Convert.ToInt32(src.PayrollSchedule)))
				.ForMember(dest => dest.PayType, opt => opt.MapFrom(src => (EmployeeType) Convert.ToInt32(src.PayType)))
				.ForMember(dest => dest.Rate, opt => opt.MapFrom(src => Convert.ToDecimal(src.Rate)))
				.ForMember(dest => dest.PayCodes, opt => opt.MapFrom(src => new List<CompanyPayCode>()))
				.ForMember(dest => dest.Compensations, opt => opt.MapFrom(src => new List<EmployeePayType>()))
				.ForMember(dest => dest.PaymentMethod, opt => opt.MapFrom(src => (EmployeePaymentMethod)Convert.ToInt32(src.PaymentMethod)))
				.ForMember(dest => dest.BankAccounts, opt => opt.Ignore())
				.ForMember(dest => dest.DirectDebitAuthorized, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.TaxCategory, opt => opt.MapFrom(src => EmployeeTaxCategory.USWorkerNonVisa))
				.ForMember(dest => dest.FederalAdditionalAmount, opt => opt.MapFrom(src => Convert.ToDecimal(src.FederalAdditionalAmount)))
				.ForMember(dest => dest.FederalExemptions, opt => opt.MapFrom(src => Convert.ToInt32(src.FederalExemptions)))
				.ForMember(dest => dest.FederalStatus, opt => opt.MapFrom(src => src.FederalStatus))
				.ForMember(dest => dest.State, opt => opt.Ignore())
				.ForMember(dest => dest.Deductions, opt => opt.Ignore())
				.ForMember(dest => dest.WorkerCompensation, opt => opt.Ignore())
				.ForMember(dest => dest.LastPayrollDate, opt => opt.Ignore())
				.ForMember(dest => dest.UserId, opt => opt.MapFrom(src => Guid.Empty))
				.ForMember(dest => dest.UserName, opt => opt.MapFrom(src => "System"))
				.ForMember(dest => dest.LastModified, opt => opt.MapFrom(src => DateTime.Now));
			//CreateMap<SiteInspectionStatus_Utility.EmployeeBankAccount, HrMaxx.OnlinePayroll.Models.EmployeeBankAccount>();
			//CreateMap<SiteInspectionStatus_Utility.EmployeeDeduction, HrMaxx.OnlinePayroll.Models.EmployeeDeduction>();
			//CreateMap<SiteInspectionStatus_Utility.VendorCustomer, HrMaxx.OnlinePayroll.Models.VendorCustomer>();
			//CreateMap<SiteInspectionStatus_Utility.EmployeeGarnishments, HrMaxx.OnlinePayroll.Models.EmployeeDeduction>();
				
			
		}
	}
}
using System;
using AutoMapper;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.USTaxModels;

namespace HrMaxx.OnlinePayroll.Services.Mappers
{
	public class USTaxTablesModelMapperProfile : ProfileLazy
	{
		public USTaxTablesModelMapperProfile(Lazy<IMappingEngine> mapper)
			: base(mapper)
		{
		}

		protected override void Configure()
		{
			base.Configure();

			CreateMap<Models.DataModel.FITTaxTable, FITTaxTableRow>()
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.RangeStart, opt => opt.MapFrom(src => src.StartRange))
				.ForMember(dest => dest.RangeEnd, opt => opt.MapFrom(src => src.EndRange))
				.ForMember(dest => dest.ExcessOverAmoutt, opt => opt.MapFrom(src => src.ExcessOvrAmt))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<USFederalFilingStatus>(src.FilingStatus.Trim())));

			CreateMap<Models.DataModel.FITWithholdingAllowanceTable, FITWithholdingAllowanceTableRow>()
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.AmoutForOneWithholdingAllowance, opt => opt.MapFrom(src => src.AmtForOneWithholdingAllow));

			CreateMap<Models.DataModel.SITTaxTable, CASITTaxTableRow>()
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.RangeStart, opt => opt.MapFrom(src => src.StartRange))
				.ForMember(dest => dest.RangeEnd, opt => opt.MapFrom(src => src.EndRange))
				.ForMember(dest => dest.ExcessOverAmoutt, opt => opt.MapFrom(src => src.ExcessOvrAmt))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<CAStateFilingStatus>(src.FilingStatus.Trim())));

			CreateMap<Models.DataModel.SITLowIncomeTaxTable, CASITLowIncomeTaxTableRow>()
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodId))
				.ForMember(dest => dest.AmountIfExemptGreaterThan2, opt => opt.MapFrom(src => src.AmtIfExmpGrtThan2))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<CAStateLowIncomeFilingStatus>(src.FilingStatus.Trim())));

			CreateMap<Models.DataModel.StandardDeductionTable, CAStandardDeductionTableRow>()
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.AmountIfExemptGreaterThan1, opt => opt.MapFrom(src => src.AmtIfExmpGrtThan1))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<CAStateLowIncomeFilingStatus>(src.FilingStatus.Trim())));

			CreateMap<Models.DataModel.EstimatedDeductionsTable, EstimatedDeductionTableRow>()
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.Allowances, opt => opt.MapFrom(src => src.NoOfAllowances));

			CreateMap<Models.DataModel.ExemptionAllowanceTable, ExemptionAllowanceTableRow>()
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.Allowances, opt => opt.MapFrom(src => src.NoOfAllowances));

			CreateMap<Models.DataModel.TaxDeductionPrecedence, TaxDeductionPrecendence>();

		}
	}
}


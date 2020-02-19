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
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.RangeStart, opt => opt.MapFrom(src => src.StartRange))
				.ForMember(dest => dest.RangeEnd, opt => opt.MapFrom(src => src.EndRange))
				.ForMember(dest => dest.ExcessOverAmoutt, opt => opt.MapFrom(src => src.ExcessOvrAmt))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<USFederalFilingStatus>(src.FilingStatus.Trim())));
			
			CreateMap<Models.DataModel.MTSITTaxTable, MTSITTaxTableRow>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.RangeStart, opt => opt.MapFrom(src => src.StartRange))
				.ForMember(dest => dest.RangeEnd, opt => opt.MapFrom(src => src.EndRange))
				.ForMember(dest => dest.ExcessOverAmoutt, opt => opt.MapFrom(src => src.ExcessOvrAmt));

			CreateMap<Models.DataModel.HISITTaxTable, FITTaxTableRow>()
                .ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.ForMultiJobs, opt => opt.Ignore())
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
                .ForMember(dest => dest.RangeStart, opt => opt.MapFrom(src => src.StartRange))
                .ForMember(dest => dest.RangeEnd, opt => opt.MapFrom(src => src.EndRange))
                .ForMember(dest => dest.ExcessOverAmoutt, opt => opt.MapFrom(src => src.ExcessOvrAmt))
                .ForMember(dest => dest.FilingStatus,
                    opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<USFederalFilingStatus>(src.FilingStatus.Trim())));

            CreateMap<FITTaxTableRow, Models.DataModel.FITTaxTable>()
				.ForMember(dest => dest.PayrollPeriodID, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.StartRange, opt => opt.MapFrom(src => src.RangeStart))
				.ForMember(dest => dest.EndRange, opt => opt.MapFrom(src => src.RangeEnd))
				.ForMember(dest => dest.ExcessOvrAmt, opt => opt.MapFrom(src => src.ExcessOverAmoutt))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => src.FilingStatus.GetDbName()));
			CreateMap<MTSITTaxTableRow, Models.DataModel.MTSITTaxTable>()
				.ForMember(dest => dest.PayrollPeriodID, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.StartRange, opt => opt.MapFrom(src => src.RangeStart))
				.ForMember(dest => dest.EndRange, opt => opt.MapFrom(src => src.RangeEnd))
				.ForMember(dest => dest.ExcessOvrAmt, opt => opt.MapFrom(src => src.ExcessOverAmoutt));

			CreateMap<FITTaxTableRow, Models.DataModel.HISITTaxTable>()
                .ForMember(dest => dest.PayrollPeriodID, opt => opt.MapFrom(src => src.PayrollSchedule))
                .ForMember(dest => dest.StartRange, opt => opt.MapFrom(src => src.RangeStart))
                .ForMember(dest => dest.EndRange, opt => opt.MapFrom(src => src.RangeEnd))
                .ForMember(dest => dest.ExcessOvrAmt, opt => opt.MapFrom(src => src.ExcessOverAmoutt))
                .ForMember(dest => dest.FilingStatus,
                    opt => opt.MapFrom(src => src.FilingStatus.GetDbName()));

            CreateMap<Models.DataModel.FITWithholdingAllowanceTable, FITWithholdingAllowanceTableRow>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.AmoutForOneWithholdingAllowance, opt => opt.MapFrom(src => src.AmtForOneWithholdingAllow));

			CreateMap<FITWithholdingAllowanceTableRow, Models.DataModel.FITWithholdingAllowanceTable>()
				.ForMember(dest => dest.PayrollPeriodID, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.AmtForOneWithholdingAllow, opt => opt.MapFrom(src => src.AmoutForOneWithholdingAllowance));

			CreateMap<Models.DataModel.MTSITExemptionConstantTable, MTSITExemptionConstantTableRow>()
			   .ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
			   .ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
			   .ForMember(dest => dest.Amount, opt => opt.MapFrom(src => src.Amount));

			CreateMap<MTSITExemptionConstantTableRow, Models.DataModel.MTSITExemptionConstantTable>()
				.ForMember(dest => dest.PayrollPeriodID, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.Amount, opt => opt.MapFrom(src => src.Amount));

			CreateMap<Models.DataModel.FITAlienAdjustmentTable, FITAlienAdjustmentTableRow>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodId));

			CreateMap<FITAlienAdjustmentTableRow, Models.DataModel.FITAlienAdjustmentTable>()
				.ForMember(dest => dest.PayrollPeriodId, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.Amount, opt => opt.MapFrom(src => src.Amount));

			CreateMap<Models.DataModel.FITW4Table, FITW4TaxTableRow>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.FilingStatus, opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<USFederalFilingStatus>(src.FilingStatus.Trim())));
			CreateMap<FITW4TaxTableRow, Models.DataModel.FITW4Table>()
				.ForMember(dest => dest.FilingStatus, opt => opt.MapFrom(src => src.FilingStatus.GetDbName()));

			CreateMap<Models.DataModel.HISITWithholdingAllowanceTable, FITWithholdingAllowanceTableRow>()
                .ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
                .ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
                .ForMember(dest => dest.AmoutForOneWithholdingAllowance, opt => opt.MapFrom(src => src.AmtForOneWithholdingAllow));

            CreateMap<FITWithholdingAllowanceTableRow, Models.DataModel.HISITWithholdingAllowanceTable>()
				.ForMember(dest => dest.PayrollPeriodID, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.AmtForOneWithholdingAllow, opt => opt.MapFrom(src => src.AmoutForOneWithholdingAllowance));

			CreateMap<Models.DataModel.SITTaxTable, CASITTaxTableRow>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.RangeStart, opt => opt.MapFrom(src => src.StartRange))
				.ForMember(dest => dest.RangeEnd, opt => opt.MapFrom(src => src.EndRange))
				.ForMember(dest => dest.ExcessOverAmoutt, opt => opt.MapFrom(src => src.ExcessOvrAmt))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<CAStateFilingStatus>(src.FilingStatus.Trim())));

			CreateMap<CASITTaxTableRow, Models.DataModel.SITTaxTable>()
				.ForMember(dest => dest.PayrollPeriodID, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.StartRange, opt => opt.MapFrom(src => src.RangeStart))
				.ForMember(dest => dest.EndRange, opt => opt.MapFrom(src => src.RangeEnd))
				.ForMember(dest => dest.ExcessOvrAmt, opt => opt.MapFrom(src => src.ExcessOverAmoutt))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => src.FilingStatus.GetDbName()));

			CreateMap<Models.DataModel.SITLowIncomeTaxTable, CASITLowIncomeTaxTableRow>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodId))
				.ForMember(dest => dest.AmountIfExemptGreaterThan2, opt => opt.MapFrom(src => src.AmtIfExmpGrtThan2))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<CAStateLowIncomeFilingStatus>(src.FilingStatus.Trim())));

			CreateMap<CASITLowIncomeTaxTableRow, Models.DataModel.SITLowIncomeTaxTable>()
				.ForMember(dest => dest.PayrollPeriodId, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.AmtIfExmpGrtThan2, opt => opt.MapFrom(src => src.AmountIfExemptGreaterThan2))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => src.FilingStatus.GetDbName()));

			CreateMap<Models.DataModel.StandardDeductionTable, CAStandardDeductionTableRow>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.AmountIfExemptGreaterThan1, opt => opt.MapFrom(src => src.AmtIfExmpGrtThan1))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => HrMaaxxSecurity.GetEnumFromDbName<CAStateLowIncomeFilingStatus>(src.FilingStatus.Trim())));

			CreateMap<CAStandardDeductionTableRow, Models.DataModel.StandardDeductionTable>()
				.ForMember(dest => dest.PayrollPeriodID, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.AmtIfExmpGrtThan1, opt => opt.MapFrom(src => src.AmountIfExemptGreaterThan1))
				.ForMember(dest => dest.FilingStatus,
					opt => opt.MapFrom(src => src.FilingStatus.GetDbName()));

			CreateMap<Models.DataModel.EstimatedDeductionsTable, EstimatedDeductionTableRow>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.Allowances, opt => opt.MapFrom(src => src.NoOfAllowances));

			CreateMap<EstimatedDeductionTableRow, Models.DataModel.EstimatedDeductionsTable>()
				.ForMember(dest => dest.PayrollPeriodID, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.NoOfAllowances, opt => opt.MapFrom(src => src.Allowances));

			CreateMap<Models.DataModel.ExemptionAllowanceTable, ExemptionAllowanceTableRow>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false))
				.ForMember(dest => dest.PayrollSchedule, opt => opt.MapFrom(src => src.PayrollPeriodID))
				.ForMember(dest => dest.Allowances, opt => opt.MapFrom(src => src.NoOfAllowances));

			CreateMap<ExemptionAllowanceTableRow, Models.DataModel.ExemptionAllowanceTable>()
				.ForMember(dest => dest.PayrollPeriodID, opt => opt.MapFrom(src => src.PayrollSchedule))
				.ForMember(dest => dest.NoOfAllowances, opt => opt.MapFrom(src => src.Allowances));

			CreateMap<Models.DataModel.TaxDeductionPrecedence, TaxDeductionPrecendence>();

			CreateMap<Models.DataModel.MinWageYear, MinWageYearRow>()
				.ForMember(dest => dest.HasChanged, opt => opt.MapFrom(src => false));
			CreateMap<MinWageYearRow, Models.DataModel.MinWageYear>();

		}
	}
}


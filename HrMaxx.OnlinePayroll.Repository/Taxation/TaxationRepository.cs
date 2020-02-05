using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using Dapper;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using HrMaxx.OnlinePayroll.Models.USTaxModels;

namespace HrMaxx.OnlinePayroll.Repository.Taxation
{
	public class TaxationRepository : BaseDapperRepository, ITaxationRepository
	{
		private readonly USTaxTableEntities _dbContext;
		private readonly IMapper _mapper;

		public TaxationRepository(IMapper mapper, USTaxTableEntities dbContext, DbConnection connection)
			: base(connection)
		{
			_dbContext = dbContext;
			_mapper = mapper;
		}

		public USTaxTables FillTaxTables(int year)
		{
			const string selectTaxYearRates = @"select * from TaxYearRate where TaxYear=@Year;";
			const string selectTaxes = @"select * from Tax";
			const string selectFIT = @"select * from FITTaxTable  where Year=@Year order by PayrollPeriodId, ForMultiJobs, FilingStatus, StartRange, EndRange;";
			const string selectFITW4 = @"select * from FITW4Table  where Year=@Year order by FilingStatus;";
			const string selectFITAlien = @"select * from FITAlienAdjustmentTable  where Year=@Year order by Pre2020, PayrollPeriodId;";
			const string selectFITWithholding = @"select * from FITWithholdingAllowanceTable  where Year=@Year ;";
            const string selectHISIT = @"select * from HISITTaxTable  where Year=@Year order by PayrollPeriodId, FilingStatus, StartRange, EndRange;";
            const string selectHISITWithholding = @"select * from HISITWithholdingAllowanceTable  where Year=@Year ;";
            const string selectSIT = @"select * from SITTaxTable  where Year=@Year  order by PayrollPeriodId, FilingStatus, StartRange, EndRange;";
			const string selectSITLowIncome = @"select * from SITLowIncomeTaxTable  where Year=@Year ;";
			const string selectStdDed = @"select * from StandardDeductionTable  where Year=@Year ;";
			const string selectEstDed = @"select * from EstimatedDeductionsTable  where Year=@Year ;";
			const string selectExmpAllow = @"select * from ExemptionAllowanceTable  where Year=@Year ;";
			const string selectDeductionPrecedence = @"select * from TaxDeductionPrecedence;";
			const string selectMinWageYear = @"select * from MinWageYear;";

			using (var conn = GetConnection())
			{
				var taxyearrates = conn.Query<TaxYearRate>(selectTaxYearRates, new {Year = year}).ToList();
				var taxes = conn.Query<Models.DataModel.Tax>(selectTaxes).ToList();
				taxyearrates.ForEach(t =>
				{
					t.Tax = taxes.First(t1 => t1.Id == t.TaxId);
				});
				var fit = conn.Query<Models.DataModel.FITTaxTable>(selectFIT, new { Year = year }).ToList();
				var fitwithholding = conn.Query<Models.DataModel.FITWithholdingAllowanceTable>(selectFITWithholding, new { Year = year }).ToList();
                var hisit = conn.Query<Models.DataModel.FITTaxTable>(selectHISIT, new { Year = year }).ToList();
                var hisitwithholding = conn.Query<Models.DataModel.FITWithholdingAllowanceTable>(selectHISITWithholding, new { Year = year }).ToList();
                var sit = conn.Query<Models.DataModel.SITTaxTable>(selectSIT, new { Year = year }).ToList();
				var sitlow = conn.Query<Models.DataModel.SITLowIncomeTaxTable>(selectSITLowIncome, new { Year = year }).ToList();
				var stddeds = conn.Query<Models.DataModel.StandardDeductionTable>(selectStdDed, new { Year = year }).ToList();
				var estded = conn.Query<Models.DataModel.EstimatedDeductionsTable>(selectEstDed, new { Year = year }).ToList();
				var exempallow = conn.Query<Models.DataModel.ExemptionAllowanceTable>(selectExmpAllow, new { Year = year }).ToList();
				var dedpre = conn.Query<Models.DataModel.TaxDeductionPrecedence>(selectDeductionPrecedence).ToList();
				var fitw4 = conn.Query<Models.DataModel.FITW4Table>(selectFITW4, new { Year = year }).ToList();
				var fitalien = conn.Query<Models.DataModel.FITAlienAdjustmentTable>(selectFITAlien, new { Year = year }).ToList();
				var minwage = conn.Query<Models.DataModel.MinWageYear>(selectMinWageYear, new { Year = year }).ToList();

				return new USTaxTables
				{
					Taxes = _mapper.Map<List<TaxYearRate>, List<TaxByYear>>(taxyearrates.ToList()),
					FITTaxTable = _mapper.Map<List<FITTaxTable>, List<FITTaxTableRow>>(fit.ToList()),
					FitWithholdingAllowanceTable = _mapper.Map<List<FITWithholdingAllowanceTable>, List<FITWithholdingAllowanceTableRow>>(fitwithholding.ToList()),
                    HISITTaxTable = _mapper.Map<List<FITTaxTable>, List<FITTaxTableRow>>(hisit.ToList()),
                    HISitWithholdingAllowanceTable = _mapper.Map<List<FITWithholdingAllowanceTable>, List<FITWithholdingAllowanceTableRow>>(hisitwithholding.ToList()),
                    CASITTaxTable = _mapper.Map<List<SITTaxTable>, List<CASITTaxTableRow>>(sit.ToList()),
					CASITLowIncomeTaxTable = _mapper.Map<List<SITLowIncomeTaxTable>, List<CASITLowIncomeTaxTableRow>>(sitlow.ToList()),
					CAStandardDeductionTable = _mapper.Map<List<StandardDeductionTable>, List<CAStandardDeductionTableRow>>(stddeds.ToList()),
					EstimatedDeductionTable = _mapper.Map<List<EstimatedDeductionsTable>, List<EstimatedDeductionTableRow>>(estded.ToList()),
					ExemptionAllowanceTable = _mapper.Map<List<ExemptionAllowanceTable>, List<ExemptionAllowanceTableRow>>(exempallow.ToList()),
					TaxDeductionPrecendences = _mapper.Map<List<Models.DataModel.TaxDeductionPrecedence>, List<Models.USTaxModels.TaxDeductionPrecendence>>(dedpre.ToList()),
					FITW4Table = _mapper.Map<List<Models.DataModel.FITW4Table>, List<Models.USTaxModels.FITW4TaxTableRow>>(fitw4.ToList()),
					FITAlienAdjustmentTable = _mapper.Map<List<Models.DataModel.FITAlienAdjustmentTable>, List<Models.USTaxModels.FITAlienAdjustmentTableRow>>(fitalien.ToList()),
					MinWageYearTable = _mapper.Map<List<Models.DataModel.MinWageYear>, List<Models.USTaxModels.MinWageYearRow>>(minwage.ToList()),
				};

			}
			

			
		}

		public USTaxTables FillTaxTablesByContext()
		{
			var fit = _dbContext.FITTaxTables;
			var fitwithholding = _dbContext.FITWithholdingAllowanceTables;
			var fitw4 = _dbContext.FITW4Table;
			var fitalien = _dbContext.FITAlienAdjustmentTables;
            var hisit = _dbContext.HISITTaxTables;
            var hisitwithholding = _dbContext.HISITWithholdingAllowanceTables;
            var stddeds = _dbContext.StandardDeductionTables;
			var sit = _dbContext.SITTaxTables;
			var sitlow = _dbContext.SITLowIncomeTaxTables;
			var estded = _dbContext.EstimatedDeductionsTables;
			var exempallow = _dbContext.ExemptionAllowanceTables;
			var dedpre = _dbContext.TaxDeductionPrecedences;
			var minwage = _dbContext.MinWageYears;

			return new USTaxTables
			{
				FITTaxTable = _mapper.Map<List<FITTaxTable>, List<FITTaxTableRow>>(fit.ToList()),
				FitWithholdingAllowanceTable = _mapper.Map<List<FITWithholdingAllowanceTable>, List<FITWithholdingAllowanceTableRow>>(fitwithholding.ToList()),
                HISITTaxTable = _mapper.Map<List<HISITTaxTable>, List<FITTaxTableRow>>(hisit.ToList()),
                HISitWithholdingAllowanceTable = _mapper.Map<List<HISITWithholdingAllowanceTable>, List<FITWithholdingAllowanceTableRow>>(hisitwithholding.ToList()),
                CASITTaxTable = _mapper.Map<List<SITTaxTable>, List<CASITTaxTableRow>>(sit.ToList()),
				CASITLowIncomeTaxTable = _mapper.Map<List<SITLowIncomeTaxTable>, List<CASITLowIncomeTaxTableRow>>(sitlow.ToList()),
				CAStandardDeductionTable = _mapper.Map<List<StandardDeductionTable>, List<CAStandardDeductionTableRow>>(stddeds.ToList()),
				EstimatedDeductionTable = _mapper.Map<List<EstimatedDeductionsTable>, List<EstimatedDeductionTableRow>>(estded.ToList()),
				ExemptionAllowanceTable = _mapper.Map<List<ExemptionAllowanceTable>, List<ExemptionAllowanceTableRow>>(exempallow.ToList()),
				TaxDeductionPrecendences = _mapper.Map<List<Models.DataModel.TaxDeductionPrecedence>, List<Models.USTaxModels.TaxDeductionPrecendence>>(dedpre.ToList()),
				FITW4Table = _mapper.Map<List<Models.DataModel.FITW4Table>, List<Models.USTaxModels.FITW4TaxTableRow>>(fitw4.ToList()),
				FITAlienAdjustmentTable = _mapper.Map<List<Models.DataModel.FITAlienAdjustmentTable>, List<Models.USTaxModels.FITAlienAdjustmentTableRow>>(fitalien.ToList()),
				MinWageYearTable = _mapper.Map<List<Models.DataModel.MinWageYear>, List<Models.USTaxModels.MinWageYearRow>>(minwage.ToList()),
			};
		}

		public void SaveTaxTables(int year, USTaxTables taxTables, USTaxTables original)
		{
			const string insertTaxYearRate = @"update TaxYearRate set Rate=@Rate, AnnualMaxPerEmployee=@AnnualMaxPerEmployee, TaxRateLimit= @TaxRateLimit where Id=@Id;";
			const string insertFit = @"if exists(select 'x' from FITTaxTable Where Id=@Id) update FITTaxTable set StartRange=@StartRange, EndRange=@EndRange, FlatRate=@FlatRate, AdditionalPercentage=@AdditionalPercentage, ExcessOvrAmt=@ExcessOvrAmt, ForMultiJobs=@ForMultiJobs where Id=@Id; else insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year, ForMultiJobs) values(@PayrollPeriodId, @FilingStatus, @StartRange, @EndRange, @FlatRate, @AdditionalPercentage, @ExcessOvrAmt, @Year, @ForMultiJobs);";
			const string insertHISitWithholding = @"update HISITWithholdingAllowanceTable set AmtForOneWithholdingAllow=@AmtForOneWithholdingAllow where Id=@Id;";
            const string insertHISit = @"if exists(select 'x' from HISITTaxTable Where Id=@Id) update HISITTaxTable set StartRange=@StartRange, EndRange=@EndRange, FlatRate=@FlatRate, AdditionalPercentage=@AdditionalPercentage, ExcessOvrAmt=@ExcessOvrAmt where Id=@Id; else insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(@PayrollPeriodId, @FilingStatus, @StartRange, @EndRange, @FlatRate, @AdditionalPercentage, @ExcessOvrAmt, @Year);";
            const string insertFitWithholding = @"update FITWithholdingAllowanceTable set AmtForOneWithholdingAllow=@AmtForOneWithholdingAllow where Id=@Id;";
			const string insertFitAlien = @"if exists(select 'x' from FITAlienAdjustmentTable Where Id=@Id) update FITAlienAdjustmentTable set Amount=@Amount where Id=@Id; else insert into FITAlienAdjustmentTable (PayrollPeriodId, Amount, Pre2020, Year) values (@PayrollPeriodId, @Amount, @Pre2020, @Year);";
			const string insertSit = @"if exists(select 'x' from SITTaxTable Where Id=@Id) update FITTaxTable set StartRange=@StartRange, EndRange=@EndRange, FlatRate=@FlatRate, AdditionalPercentage=@AdditionalPercentage, ExcessOvrAmt=@ExcessOvrAmt where Id=@Id; else insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(@PayrollPeriodId, @FilingStatus, @StartRange, @EndRange, @FlatRate, @AdditionalPercentage, @ExcessOvrAmt, @Year);";
			const string insertSitLow = @"update SITLowIncomeTaxTable set Amount=@Amount, AmtIfExmpGrtThan2=@AmtIfExmpGrtThan2 where Id=@Id;";
			const string insertStdDed = @"update StandardDeductionTable set Amount=@Amount, AmtIfExmpGrtThan1=@AmtIfExmpGrtThan1 where Id=@Id;";
			const string insertEstDed = @"update EstimatedDeductionsTable set Amount=@Amount where Id=@Id";
			const string insertExmpAllow = @"update ExemptionAllowanceTable set Amount=@Amount where Id=@Id;";
			const string insertFitW4 = @"if exists(select 'x' from FITW4Table Where Id=@Id) update FITW4Table set DependentWageLimit=@DependentWageLimit, DependentAllowance1=@DependentAllowance1, DependentAllowance2=@DependentAllowance2, AdditionalDeductionW4=@AdditionalDeductionW4, DeductionForExemption=@DeductionForExemption where Id=@Id; else insert into FITW4Table(FilingStatus, DependentWageLimit, DependentAllowance1, DependentAllowance2, AdditionalDeductionW4, DeductionForExemption, Year) values (@FilingStatus, @DependentWageLimit, @DependentAllowance1, @DependentAllowance2, @AdditionalDeductionW4, @DeductionForExemption, @Year);";
			const string insertMinWage = @"if exists(select 'x' from MinWageYear where Id=@Id) update MinWageYear set StateId=@StateId, MinWage=@MinWage, TippedMinWage=@TippedMinWage, MaxTipCredit=@MaxTipCredit where Id=@Id;  else insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) values(@Year, @StateId, @MinWage, @TippedMinWage, @MaxTipCredit);";

			const string deleteFIT = @"delete from FITTaxTable where Id=@Id;";
            const string deleteHISIT = @"delete from HISITTaxTable where Id=@Id;";
            const string deleteSIT = @"delete from SITTaxTable where Id=@Id;";


			var taxyearrate = _mapper.Map<List<TaxByYear>, List<TaxYearRate>>(taxTables.Taxes.Where(t=>t.TaxYear==year && t.HasChanged).ToList());
			var fit = _mapper.Map<List<FITTaxTableRow>, List<FITTaxTable>>(taxTables.FITTaxTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var fitWithholding = _mapper.Map<List<FITWithholdingAllowanceTableRow>, List<FITWithholdingAllowanceTable>>(taxTables.FitWithholdingAllowanceTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var fitalien = _mapper.Map<List<FITAlienAdjustmentTableRow>, List<FITAlienAdjustmentTable>>(taxTables.FITAlienAdjustmentTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var fitW4 = _mapper.Map<List<FITW4TaxTableRow>, List<FITW4Table>>(taxTables.FITW4Table.Where(t => t.Year == year && t.HasChanged).ToList());
			var hisit = _mapper.Map<List<FITTaxTableRow>, List<HISITTaxTable>>(taxTables.HISITTaxTable.Where(t => t.Year == year && t.HasChanged).ToList());
            var hisitWithholding = _mapper.Map<List<FITWithholdingAllowanceTableRow>, List<HISITWithholdingAllowanceTable>>(taxTables.HISitWithholdingAllowanceTable.Where(t => t.Year == year && t.HasChanged).ToList());
            var stddeds = _mapper.Map<List<CAStandardDeductionTableRow>, List<StandardDeductionTable>>(taxTables.CAStandardDeductionTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var sit = _mapper.Map<List<CASITTaxTableRow>, List<SITTaxTable>>(taxTables.CASITTaxTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var sitLow = _mapper.Map<List<CASITLowIncomeTaxTableRow>, List<SITLowIncomeTaxTable>>(taxTables.CASITLowIncomeTaxTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var estded = _mapper.Map<List<EstimatedDeductionTableRow>, List<EstimatedDeductionsTable>>(taxTables.EstimatedDeductionTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var exempallow = _mapper.Map<List<ExemptionAllowanceTableRow>, List<ExemptionAllowanceTable>>(taxTables.ExemptionAllowanceTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var minwageyear = _mapper.Map<List<MinWageYearRow>, List<MinWageYear>>(taxTables.MinWageYearTable.Where(t => t.Year == year && t.HasChanged).ToList());

			using (var conn = GetConnection())
			{
				if(taxyearrate.Any())
					conn.Execute(insertTaxYearRate, taxyearrate);
				if(fit.Any())
					conn.Execute(insertFit, fit);
                if (hisit.Any())
                    conn.Execute(insertHISit, hisit);
                if (taxTables.FITTaxTable.Count < original.FITTaxTable.Count)
				{
					var missing = original.FITTaxTable.Where(t => taxTables.FITTaxTable.All(t1 => t.Id != t1.Id)).ToList();
					conn.Execute(deleteFIT, missing);
				}
                if (taxTables.HISITTaxTable.Count < original.HISITTaxTable.Count)
                {
                    var missing = original.HISITTaxTable.Where(t => taxTables.HISITTaxTable.All(t1 => t.Id != t1.Id)).ToList();
                    conn.Execute(deleteHISIT, missing);
                }
                if (fitWithholding.Any())
					conn.Execute(insertFitWithholding, fitWithholding);
				if (fitW4.Any())
					conn.Execute(insertFitW4, fitW4);
				if (fitalien.Any())
					conn.Execute(insertFitAlien, fitalien);

				if (hisitWithholding.Any())
                    conn.Execute(insertHISitWithholding, hisitWithholding);
                if (sit.Any())
					conn.Execute(insertSit, sit);

				if (taxTables.CASITTaxTable.Count < original.FITTaxTable.Count)
				{
					var missing = original.CASITTaxTable.Where(t => taxTables.CASITTaxTable.All(t1 => t.Id != t1.Id)).ToList();
					conn.Execute(deleteSIT, missing);
				}
				if (sitLow.Any())
					conn.Execute(insertSitLow, sitLow);
				if (stddeds.Any())
					conn.Execute(insertStdDed, stddeds);
				if (estded.Any())
					conn.Execute(insertEstDed, estded);
				if (exempallow.Any())
					conn.Execute(insertExmpAllow, exempallow);
				if (minwageyear.Any())
					conn.Execute(insertMinWage, minwageyear);
			}
		}

		public void CreateTaxes(int year)
		{
			const string createTaxes = @"if not exists(select 'x' from TaxYearRate where TaxYear=@Year) 
																begin 
																insert into TaxYearRate(TaxId, TaxYear, Rate, AnnualMaxPerEmployee, TaxRateLimit) select TaxId, @Year, Rate, AnnualMaxPerEmployee, TaxRateLimit from TaxYearRate Where TaxYear=@PYear;
																insert into FITTaxTable(PayrollPeriodID, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) select PayrollPeriodID, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, @Year from FITTaxTable where year=@PYear;
																insert into FITWithholdingAllowanceTable(PayrollPeriodID, AmtForOneWithholdingAllow, Year) select PayrollPeriodID, AmtForOneWithholdingAllow,@Year from FITWithholdingAllowanceTable where Year=@PYear;
																insert into FITW4Table(FilingStatus, DependentWageLimit, DependentAllowance1, DependentAllowance2, AdditionalDeductionW4, DeductionForExemption, Year) select FilingStatus, DependentWageLimit, DependentAllowance1, DependentAllowance2, AdditionalDeductionW4, DeductionForExemption, @Year from FITW4Table where Year=@PYear;
                                                                insert into HISITTaxTable(PayrollPeriodID, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) select PayrollPeriodID, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, @Year from HISITTaxTable where year=@PYear;
																insert into HISITWithholdingAllowanceTable(PayrollPeriodID, AmtForOneWithholdingAllow, Year) select PayrollPeriodID, AmtForOneWithholdingAllow,@Year from HISITWithholdingAllowanceTable where Year=@PYear;
																insert into SITTaxTable(PayrollPeriodID, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) select PayrollPeriodID, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, @Year from SITTaxTable where year=@PYear;
																insert into SITLowIncomeTaxTable(PayrollPeriodID, FilingStatus, Amount, AmtIfExmpGrtThan2, Year) select PayrollPeriodID, FilingStatus, Amount, AmtIfExmpGrtThan2, @Year from SITLowIncomeTaxTable where Year=@PYear;
																insert into StandardDeductionTable( PayrollPeriodID, FilingStatus, Amount, AmtIfExmpGrtThan1, Year) select PayrollPeriodID, FilingStatus, Amount, AmtIfExmpGrtThan1, @Year from StandardDeductionTable where Year=@PYear;
																insert into EstimatedDeductionsTable(PayrollPeriodID, NoOfAllowances, Amount, Year) select PayrollPeriodID, NoOfAllowances, Amount, @Year from EstimatedDeductionsTable where Year=@PYear;
																insert into ExemptionAllowanceTable(PayrollPeriodID, NoOfAllowances, Amount, Year) select PayrollPeriodID, NoOfAllowances, Amount, @Year from ExemptionAllowanceTable where Year=@PYear;
																insert into MinWageYear(Year, StateId, MinWage, TippedMinWage, MaxTipCredit) select @Year, StateId, MinWage, TippedMinWage, MaxTipCredit from MinWageYear where Year=@PYear;
																end";
			using (var conn = GetConnection())
			{

				conn.Execute(createTaxes, new {Year=year, PYear=(year-1)});
			}
		}

		public List<int> GetTaxTableYears()
		{
			const string selectTaxYearRates = @"select distinct TaxYear from TaxYearRate;";
			using (var conn = GetConnection())
			{
				return conn.Query<int>
				(selectTaxYearRates).ToList();
			}
		}
	}
}

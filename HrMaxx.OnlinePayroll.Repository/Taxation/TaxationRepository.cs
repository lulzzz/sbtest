﻿using System.Collections.Generic;
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

		public USTaxTables FillTaxTables()
		{
			const string selectTaxYearRates = @"select * from TaxYearRate";
			const string selectTaxes = @"select * from Tax";
			const string selectFIT = @"select * from FITTaxTable order by PayrollPeriodId, FilingStatus, StartRange, EndRange;";
			const string selectFITWithholding = @"select * from FITWithholdingAllowanceTable;";
			const string selectSIT = @"select * from SITTaxTable order by PayrollPeriodId, FilingStatus, StartRange, EndRange;";
			const string selectSITLowIncome = @"select * from SITLowIncomeTaxTable;";
			const string selectStdDed = @"select * from StandardDeductionTable;";
			const string selectEstDed = @"select * from EstimatedDeductionsTable;";
			const string selectExmpAllow = @"select * from ExemptionAllowanceTable;";
			const string selectDeductionPrecedence = @"select * from TaxDeductionPrecedence;";

			using (var conn = GetConnection())
			{
				var taxyearrates = conn.Query<TaxYearRate>(selectTaxYearRates).ToList();
				var taxes = conn.Query<Models.DataModel.Tax>(selectTaxes).ToList();
				taxyearrates.ForEach(t =>
				{
					t.Tax = taxes.First(t1 => t1.Id == t.TaxId);
				});
				var fit = conn.Query<Models.DataModel.FITTaxTable>(selectFIT).ToList();
				var fitwithholding = conn.Query<Models.DataModel.FITWithholdingAllowanceTable>(selectFITWithholding).ToList();
				var sit = conn.Query<Models.DataModel.SITTaxTable>(selectSIT).ToList();
				var sitlow = conn.Query<Models.DataModel.SITLowIncomeTaxTable>(selectSITLowIncome).ToList();
				var stddeds = conn.Query<Models.DataModel.StandardDeductionTable>(selectStdDed).ToList();
				var estded = conn.Query<Models.DataModel.EstimatedDeductionsTable>(selectEstDed).ToList();
				var exempallow = conn.Query<Models.DataModel.ExemptionAllowanceTable>(selectExmpAllow).ToList();
				var dedpre = conn.Query<Models.DataModel.TaxDeductionPrecedence>(selectDeductionPrecedence).ToList();
				return new USTaxTables
				{
					Taxes = _mapper.Map<List<TaxYearRate>, List<TaxByYear>>(taxyearrates.ToList()),
					FITTaxTable = _mapper.Map<List<FITTaxTable>, List<FITTaxTableRow>>(fit.ToList()),
					FitWithholdingAllowanceTable = _mapper.Map<List<FITWithholdingAllowanceTable>, List<FITWithholdingAllowanceTableRow>>(fitwithholding.ToList()),
					CASITTaxTable = _mapper.Map<List<SITTaxTable>, List<CASITTaxTableRow>>(sit.ToList()),
					CASITLowIncomeTaxTable = _mapper.Map<List<SITLowIncomeTaxTable>, List<CASITLowIncomeTaxTableRow>>(sitlow.ToList()),
					CAStandardDeductionTable = _mapper.Map<List<StandardDeductionTable>, List<CAStandardDeductionTableRow>>(stddeds.ToList()),
					EstimatedDeductionTable = _mapper.Map<List<EstimatedDeductionsTable>, List<EstimatedDeductionTableRow>>(estded.ToList()),
					ExemptionAllowanceTable = _mapper.Map<List<ExemptionAllowanceTable>, List<ExemptionAllowanceTableRow>>(exempallow.ToList()),
					TaxDeductionPrecendences = _mapper.Map<List<Models.DataModel.TaxDeductionPrecedence>, List<Models.USTaxModels.TaxDeductionPrecendence>>(dedpre.ToList())
				};

			}
			//var fit = _dbContext.FITTaxTables;
			//var fitwithholding = _dbContext.FITWithholdingAllowanceTables;
			//var stddeds = _dbContext.StandardDeductionTables;
			//var sit = _dbContext.SITTaxTables;
			//var sitlow = _dbContext.SITLowIncomeTaxTables;
			//var estded = _dbContext.EstimatedDeductionsTables;
			//var exempallow = _dbContext.ExemptionAllowanceTables;
			//var dedpre = _dbContext.TaxDeductionPrecedences;


			
		}

		public void SaveTaxTables(int year, USTaxTables taxTables)
		{
			const string insertTaxYearRate = @"update TaxYearRate set Rate=@Rate, AnnualMaxPerEmployee=@AnnualMaxPerEmployee, TaxRateLimit= @TaxRateLimit where Id=@Id;";
			const string insertFit = @"if exists(select 'x' from FITTaxTable Where Id=@Id) update FITTaxTable set StartRange=@StartRange, EndRange=@EndRange, FlatRate=@FlatRate, AdditionalPercentage=@AdditionalPercentage, ExcessOvrAmt=@ExcessOvrAmt where Id=@Id; else insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(@PayrollPeriodId, @FilingStatus, @StartRange, @EndRange, @FlatRate, @AdditionalPercentage, @ExcessOvrAmt, @Year);";
			const string insertFitWithholding = @"update FITWithholdingAllowanceTable set AmtForOneWithholdingAllow=@AmtForOneWithholdingAllow where Id=@Id;";
			const string insertSit = @"if exists(select 'x' from SITTaxTable Where Id=@Id) update FITTaxTable set StartRange=@StartRange, EndRange=@EndRange, FlatRate=@FlatRate, AdditionalPercentage=@AdditionalPercentage, ExcessOvrAmt=@ExcessOvrAmt where Id=@Id; else insert into FITTaxTable(PayrollPeriodId, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) values(@PayrollPeriodId, @FilingStatus, @StartRange, @EndRange, @FlatRate, @AdditionalPercentage, @ExcessOvrAmt, @Year);";
			const string insertSitLow = @"update SITLowIncomeTaxTable set Amount=@Amount, AmtIfExmpGrtThan2=@AmtIfExmpGrtThan2 where Id=@Id;";
			const string insertStdDed = @"update StandardDeductionTable set Amount=@Amount, AmtIfExmpGrtThan1=@AmtIfExmpGrtThan1 where Id=@Id;";
			const string insertEstDed = @"update EstimatedDeductionsTable set Amount=@Amount where Id=@Id";
			const string insertExmpAllow = @"update ExemptionAllowanceTable set Amount=@Amount where Id=@Id;";


			var taxyearrate = _mapper.Map<List<TaxByYear>, List<TaxYearRate>>(taxTables.Taxes.Where(t=>t.TaxYear==year && t.HasChanged).ToList());
			var fit = _mapper.Map<List<FITTaxTableRow>, List<FITTaxTable>>(taxTables.FITTaxTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var fitWithholding = _mapper.Map<List<FITWithholdingAllowanceTableRow>, List<FITWithholdingAllowanceTable>>(taxTables.FitWithholdingAllowanceTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var stddeds = _mapper.Map<List<CAStandardDeductionTableRow>, List<StandardDeductionTable>>(taxTables.CAStandardDeductionTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var sit = _mapper.Map<List<CASITTaxTableRow>, List<SITTaxTable>>(taxTables.CASITTaxTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var sitLow = _mapper.Map<List<CASITLowIncomeTaxTableRow>, List<SITLowIncomeTaxTable>>(taxTables.CASITLowIncomeTaxTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var estded = _mapper.Map<List<EstimatedDeductionTableRow>, List<EstimatedDeductionsTable>>(taxTables.EstimatedDeductionTable.Where(t => t.Year == year && t.HasChanged).ToList());
			var exempallow = _mapper.Map<List<ExemptionAllowanceTableRow>, List<ExemptionAllowanceTable>>(taxTables.ExemptionAllowanceTable.Where(t => t.Year == year && t.HasChanged).ToList());

			using (var conn = GetConnection())
			{
				if(taxyearrate.Any())
					conn.Execute(insertTaxYearRate, taxyearrate);
				if(fit.Any())
					conn.Execute(insertFit, fit);
				if (fitWithholding.Any())
					conn.Execute(insertFitWithholding, fitWithholding);
				if (sit.Any())
					conn.Execute(insertSit, sit);
				if (sitLow.Any())
					conn.Execute(insertSitLow, sitLow);
				if (stddeds.Any())
					conn.Execute(insertStdDed, stddeds);
				if (estded.Any())
					conn.Execute(insertEstDed, estded);
				if (exempallow.Any())
					conn.Execute(insertExmpAllow, exempallow);
			}
		}

		public void CreateTaxes(int year)
		{
			const string createTaxes = @"if not exists(select 'x' from TaxYearRate where TaxYear=@Year) 
																begin 
																insert into TaxYearRate(TaxId, TaxYear, Rate, AnnualMaxPerEmployee, TaxRateLimit) select TaxId, @Year, Rate, AnnualMaxPerEmployee, TaxRateLimit from TaxYearRate Where TaxYear=@PYear;
																insert into FITTaxTable(PayrollPeriodID, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) select PayrollPeriodID, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, @Year from FITTaxTable where year=@PYear;
																insert into FITWithholdingAllowanceTable(PayrollPeriodID, AmtForOneWithholdingAllow, Year) select PayrollPeriodID, AmtForOneWithholdingAllow,@Year from FITWithholdingAllowanceTable where Year=@PYear;
																insert into SITTaxTable(PayrollPeriodID, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, Year) select PayrollPeriodID, FilingStatus, StartRange, EndRange, FlatRate, AdditionalPercentage, ExcessOvrAmt, @Year from SITTaxTable where year=@PYear;
																insert into SITLowIncomeTaxTable(PayrollPeriodID, FilingStatus, Amount, AmtIfExmpGrtThan2, Year) select PayrollPeriodID, FilingStatus, Amount, AmtIfExmpGrtThan2, @Year from SITLowIncomeTaxTable where Year=@PYear;
																insert into StandardDeductionTable( PayrollPeriodID, FilingStatus, Amount, AmtIfExmpGrtThan1, Year) select PayrollPeriodID, FilingStatus, Amount, AmtIfExmpGrtThan1, @Year from StandardDeductionTable where Year=@PYear;
																insert into EstimatedDeductionsTable(PayrollPeriodID, NoOfAllowances, Amount, Year) select PayrollPeriodID, NoOfAllowances, Amount, @Year from EstimatedDeductionsTable where Year=@PYear;
																insert into ExemptionAllowanceTable(PayrollPeriodID, NoOfAllowances, Amount, Year) select PayrollPeriodID, NoOfAllowances, Amount, @Year from ExemptionAllowanceTable where Year=@PYear;
																end";
			using (var conn = GetConnection())
			{

				conn.Execute(createTaxes, new {Year=year, PYear=(year-1)});
			}
		}
	}
}

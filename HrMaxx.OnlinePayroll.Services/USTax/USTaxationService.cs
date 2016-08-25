﻿using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.MetaDataModels;
using HrMaxx.OnlinePayroll.Models.USTaxModels;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Taxation;

namespace HrMaxx.OnlinePayroll.Services.USTax
{
	public class USTaxationService : BaseService, ITaxationService
	{
		private readonly ITaxationRepository _taxationRepository;
		private readonly IMetaDataRepository _metaDataRepository;
		private USTaxTables TaxTables;
		public USTaxationService(ITaxationRepository taxationRepository, IMetaDataRepository metaDataRepository)
		{
			_taxationRepository = taxationRepository;
			_metaDataRepository = metaDataRepository;
			FillTaxTables();
		}

		private void FillTaxTables()
		{
			try
			{
				TaxTables = _taxationRepository.FillTaxTables();
				TaxTables.Taxes = _metaDataRepository.GetAllTaxes().ToList();
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " US Tax tables");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
				
			}
		}

		public List<PayrollTax> ProcessTaxes(Company company, PayCheck payCheck, DateTime payDay, decimal grossWage, List<PayCheck> employeePayChecks)
		{
			try
			{
				var returnList = new List<PayrollTax>();
				var applicableTaxes = TaxTables.Taxes.Where(t => t.TaxYear == payDay.Year
																								&& (!t.Tax.StateId.HasValue
																										|| (t.Tax.StateId.Value==payCheck.Employee.State.State.StateId)
																										)
																							).OrderBy(t=>t.Id).ToList();
				foreach (var tax in applicableTaxes)
				{
					returnList.Add(CalculateTax(company, payCheck, payDay, grossWage, employeePayChecks, tax));
				}
				return returnList;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " process taxes for payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);

			}
		}

		private PayrollTax CalculateTax(Company company, PayCheck payCheck, DateTime payDay, decimal grossWage, List<PayCheck> employeePayChecks, TaxByYear tax)
		{
			if (!tax.Tax.StateId.HasValue)
			{
				if (tax.Tax.Code.Equals("FIT"))
					return GetFIT(company, payCheck, grossWage, employeePayChecks, payDay, tax);
				else if (tax.Tax.Code.Equals("MD_Employee"))
					return GetMDEE(company, payCheck, grossWage, employeePayChecks, payDay, tax);
				else if (tax.Tax.Code.Equals("MD_Employer"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax);
				else if (tax.Tax.Code.Equals("SS_Employee"))
					return GetMDEE(company, payCheck, grossWage, employeePayChecks, payDay, tax);
				else if (tax.Tax.Code.Equals("SS_Employer"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax);
				else if (tax.Tax.Code.Equals("FUTA"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax);
			}
			else
			{
				if (tax.Tax.Code.Equals("SIT"))
					return GetCASIT(company, payCheck, grossWage, employeePayChecks, payDay, tax);
				else if (tax.Tax.Code.Equals("SDI"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax);
				else if (tax.Tax.Code.Equals("ETT"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax);
				else if (tax.Tax.Code.Equals("SUI"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax);
			}
			return new PayrollTax();

		}

		private PayrollTax GetFIT(Company company, PayCheck payCheck, decimal grossWage, List<PayCheck> employeePayChecks, DateTime payDay, TaxByYear tax)
		{
			var withholdingAllowance = grossWage -
			                           TaxTables.FitWithholdingAllowanceTable.First(
				                           i => i.Year == payDay.Year && i.PayrollSchedule == payCheck.Employee.PayrollSchedule)
				                           .AmoutForOneWithholdingAllowance * payCheck.Employee.FederalExemptions;

			var taxableWage = GetTaxExemptedDeductionAmount(company, payCheck, grossWage, employeePayChecks, payDay, tax);
			withholdingAllowance -= taxableWage;
			taxableWage = grossWage - taxableWage;
			var fitTaxTableRow =
				TaxTables.FITTaxTable.First(
					r =>
						r.Year == payDay.Year && r.PayrollSchedule == payCheck.Employee.PayrollSchedule &&
						(int) r.FilingStatus == (int) payCheck.Employee.FederalStatus
						&& r.RangeStart<= withholdingAllowance
						&& r.RangeEnd>=withholdingAllowance);

			var taxAmount = (decimal)0;
			if (payCheck.Employee.FederalExemptions == 10)
			{
				taxAmount = payCheck.Employee.FederalAdditionalAmount;
			}
			else
			{
				taxAmount = fitTaxTableRow.FlatRate + payCheck.Employee.FederalAdditionalAmount +
				            ((withholdingAllowance - fitTaxTableRow.ExcessOverAmoutt)*fitTaxTableRow.AdditionalPercentage/100);
			}
			return new PayrollTax
			{
				Amount = Math.Round(taxAmount,2),
				TaxableWage = Math.Round(taxableWage, 2),
				Tax = Mapper.Map<TaxByYear, Tax>(tax),
				YTDTax = Math.Round(employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.Amount) + taxAmount, 2),
				YTDWage = Math.Round(employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.TaxableWage) + taxableWage, 2)
			};
		}
		private PayrollTax GetMDEE(Company company, PayCheck payCheck, decimal grossWage, List<PayCheck> employeePayChecks, DateTime payDay, TaxByYear tax)
		{
			var ytdTax = employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.Amount);
			var ytdWage = employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.TaxableWage);
			if (tax.IsFederal && payCheck.Employee.TaxCategory != EmployeeTaxCategory.USWorkerNonVisa)
			{
				return new PayrollTax
				{
					Amount = 0,
					TaxableWage = 0,
					Tax = Mapper.Map<TaxByYear, Tax>(tax),
					YTDTax = Math.Round(ytdTax, 2),
					YTDWage = Math.Round(ytdWage, 2)
				};
			}
			var taxRate = tax.Rate;
			var taxExemptedDeductions = GetTaxExemptedDeductionAmount(company, payCheck, grossWage, employeePayChecks, payDay, tax);
			
			var taxableWage = grossWage - taxExemptedDeductions;
			
			var special9PercentTax = (decimal) 0;
			if (payDay.Year > 2012 && (ytdWage + taxableWage) > 200000)
			{
				if (ytdWage > 200000)
					special9PercentTax = taxableWage*9/1000;
				else
				{
					special9PercentTax = (ytdWage + taxableWage - 200000)*9/1000;
				}
			}
			var taxAmount = taxableWage*taxRate.Value/100 + special9PercentTax;
			return new PayrollTax
			{
				Amount = Math.Round(taxAmount, 2),
				TaxableWage = Math.Round(taxableWage, 2),
				Tax = Mapper.Map<TaxByYear, Tax>(tax),
				YTDTax = Math.Round(ytdTax + taxAmount, 2),
				YTDWage = Math.Round(ytdWage + taxableWage, 2)
			};
		}
		
		private PayrollTax SimpleTaxCalculator(Company company, PayCheck payCheck, decimal grossWage, List<PayCheck> employeePayChecks, DateTime payDay, TaxByYear tax)
		{
			var ytdTax = employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.Amount);
			var ytdWage = employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.TaxableWage);
			if (tax.IsFederal && payCheck.Employee.TaxCategory != EmployeeTaxCategory.USWorkerNonVisa)
			{
				return new PayrollTax
				{
					Amount = 0,
					TaxableWage = 0,
					Tax = Mapper.Map<TaxByYear, Tax>(tax),
					YTDTax = Math.Round(ytdTax, 2),
					YTDWage = Math.Round(ytdWage, 2)
				};
			}


			var taxExemptedDeductions = GetTaxExemptedDeductionAmount(company, payCheck, grossWage, employeePayChecks, payDay, tax);
			
			
			var taxAmount = (decimal)0;
			var taxableWage = grossWage - taxExemptedDeductions;
			if (tax.AnnualMaxPerEmployee.HasValue && ytdWage < tax.AnnualMaxPerEmployee)
			{
				if ((ytdWage + grossWage - taxExemptedDeductions) > tax.AnnualMaxPerEmployee.Value)
				{
					taxableWage = tax.AnnualMaxPerEmployee.Value - ytdWage;
				}
			}
			var taxRate = !tax.Tax.IsCompanySpecific
				? (tax.Rate.HasValue ? tax.Rate.Value : tax.Tax.DefaultRate )
				: (company.CompanyTaxRates.Any(ct => ct.TaxId == tax.Id && ct.TaxYear == payDay.Year) ? company.CompanyTaxRates.First(ct => ct.TaxId == tax.Id && ct.TaxYear == payDay.Year).Rate : tax.Tax.DefaultRate);

			taxAmount = taxableWage * taxRate / 100;
			return new PayrollTax
			{
				Amount = Math.Round(taxAmount, 2),
				TaxableWage = Math.Round(taxableWage, 2),
				Tax = Mapper.Map<TaxByYear, Tax>(tax),
				YTDTax = Math.Round(ytdTax + taxAmount, 2),
				YTDWage = Math.Round(ytdWage + taxableWage, 2)
			};
		}

		private PayrollTax GetCASIT(Company company, PayCheck payCheck, decimal grossWage, List<PayCheck> employeePayChecks, DateTime payDay, TaxByYear tax)
		{

			var taxExemptedDeductiosn = GetTaxExemptedDeductionAmount(company, payCheck, grossWage, employeePayChecks, payDay, tax);
			var taxableWage = grossWage - taxExemptedDeductiosn;
			var caSITLowIncomeTaxStatus = CAStateLowIncomeFilingStatus.Single;
			if (payCheck.Employee.State.TaxStatus == EmployeeTaxStatus.Married)
				caSITLowIncomeTaxStatus = CAStateLowIncomeFilingStatus.Married;
			else if (payCheck.Employee.State.TaxStatus == EmployeeTaxStatus.UnmarriedHeadofHousehold)
				caSITLowIncomeTaxStatus = CAStateLowIncomeFilingStatus.HeadofHousehold;

			var caSITLowIncomeTaxTableRow =
				TaxTables.CASITLowIncomeTaxTable.First(r => r.PayrollSchedule == payCheck.Employee.PayrollSchedule
				                                            && r.FilingStatus == caSITLowIncomeTaxStatus
				                                            && r.Year == payCheck.PayDay.Year
					);

			var taxAmount = (decimal)0;
			if (payCheck.Employee.State.Exemptions == 10)
				taxAmount = payCheck.Employee.State.AdditionalAmount;
			else if (payCheck.Employee.State.Exemptions < 2 ) 
				if(grossWage <= caSITLowIncomeTaxTableRow.Amount)
					taxAmount = payCheck.Employee.State.AdditionalAmount;
			else if (grossWage <= caSITLowIncomeTaxTableRow.AmountIfExemptGreaterThan2)
				taxAmount = payCheck.Employee.State.AdditionalAmount;
			else
			{
				var stdDeductionRow =
				TaxTables.CAStandardDeductionTable.First(r => r.PayrollSchedule == payCheck.Employee.PayrollSchedule
																										&& r.FilingStatus == caSITLowIncomeTaxStatus
																										&& r.Year == payCheck.PayDay.Year
					);

				var stdDeductionAmt = payCheck.Employee.State.Exemptions <= 1
					? stdDeductionRow.Amount
					: stdDeductionRow.AmountIfExemptGreaterThan1;

				taxableWage -= stdDeductionAmt;

				var sitTaxTableRow =
				TaxTables.CASITTaxTable.First(
					r =>
						r.Year == payDay.Year && r.PayrollSchedule == payCheck.Employee.PayrollSchedule &&
						(int)r.FilingStatus == (int)payCheck.Employee.FederalStatus
						&& r.RangeStart <= taxableWage
						&& r.RangeEnd >= taxableWage);

				taxAmount = sitTaxTableRow.FlatRate +
				            (taxableWage - sitTaxTableRow.ExcessOverAmoutt)*sitTaxTableRow.AdditionalPercentage/100;


				var exemptionAllowanceRow = 
					TaxTables.ExemptionAllowanceTable.First(r => r.PayrollSchedule == payCheck.Employee.PayrollSchedule
					                                             && r.Allowances == payCheck.Employee.State.Exemptions
					                                             && r.Year == payCheck.PayDay.Year
						);

				taxAmount -= exemptionAllowanceRow.Amount;

				taxAmount = Math.Max(0, taxAmount) + payCheck.Employee.State.AdditionalAmount;
				

			}

			
			return new PayrollTax
			{
				Amount = Math.Round(taxAmount, 2),
				TaxableWage = Math.Round(taxableWage, 2),
				Tax = Mapper.Map<TaxByYear, Tax>(tax),
				YTDTax = Math.Round(employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.Amount) + taxAmount, 2),
				YTDWage =Math.Round( employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.TaxableWage) + taxableWage, 2)
			};
		}

		

		private decimal GetTaxExemptedDeductionAmount(Company company, PayCheck payCheck, decimal grossWage,
			List<PayCheck> employeePayChecks, DateTime payDay, TaxByYear tax)
		{
			return Math.Round(payCheck.Deductions.Where(d => TaxTables.TaxDeductionPrecendences.Any(tdp => tdp.DeductionTypeId == d.Deduction.Type.Id && tdp.TaxCode.Equals(tax.Tax.Code))).Sum(ded => ded.Amount), 2);
		}
	}
}
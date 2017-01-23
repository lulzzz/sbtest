using System;
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
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Services.USTax
{
	public class USTaxationService : BaseService, ITaxationService
	{
		private readonly ITaxationRepository _taxationRepository;
		private readonly IMetaDataRepository _metaDataRepository;
		private USTaxTables TaxTables;
		public ApplicationConfig Configurations { get; set; }
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
				Configurations = _metaDataRepository.GetConfigurations();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " US Tax tables");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
				
			}
		}

		
		public List<PayrollTax> ProcessTaxes(Company company, PayCheck payCheck, DateTime payDay, decimal grossWage, List<PayCheck> employeePayChecks, Company hostCompany)
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
					returnList.Add(CalculateTax(company, payCheck, payDay, grossWage, employeePayChecks, tax, hostCompany));
				}
				return returnList;
			}
			catch (Exception e)
			{
				if (e.Message != "Taxes Not Available")
				{
					var info = string.Format("Company {0}, GrossWage={2}, PayCheck={1}", company.Id, JsonConvert.SerializeObject(payCheck), grossWage);
					var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " process taxes for payroll--" + info);
					Log.Error(message, e);
					throw new HrMaxxApplicationException(message, e);
				}
				else
				{
					Log.Error(e.Message, e);
					throw new HrMaxxApplicationException(e.Message, e);
				}
				
				

			}
		}

		public ApplicationConfig GetApplicationConfig()
		{
			if (Configurations != null)
			{
				return Configurations;
			}
			Configurations = _metaDataRepository.GetConfigurations();
			return Configurations;
		}

		public ApplicationConfig SaveApplicationConfiguration(ApplicationConfig configs)
		{
			try
			{
				if (configs != null)
				{
					_metaDataRepository.SaveApplicationConfig(configs);
					Configurations = configs;
				}
				return Configurations;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " save application configs");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		public int PullReportConstant(string form940, int quarterly)
		{
			try
			{
				return _metaDataRepository.PullReportConstat(form940, quarterly);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " pull file sequence for form " + form940);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private PayrollTax CalculateTax(Company company, PayCheck payCheck, DateTime payDay, decimal grossWage, List<PayCheck> employeePayChecks, TaxByYear tax, Company hostCompany)
		{
			if (!tax.Tax.StateId.HasValue)
			{
				if (tax.Tax.Code.Equals("FIT"))
					return GetFIT(company, payCheck, grossWage, employeePayChecks, payDay, tax);
				else if (tax.Tax.Code.Equals("MD_Employee"))
					return GetMDEE(company, payCheck, grossWage, employeePayChecks, payDay, tax);
				else if (tax.Tax.Code.Equals("MD_Employer"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax, hostCompany);
				else if (tax.Tax.Code.Equals("SS_Employee"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax, hostCompany);
				else if (tax.Tax.Code.Equals("SS_Employer"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax, hostCompany);
				else if (tax.Tax.Code.Equals("FUTA"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax, hostCompany);
			}
			else
			{
				if (tax.Tax.Code.Equals("SIT"))
					return GetCASIT(company, payCheck, grossWage, employeePayChecks, payDay, tax);
				else if (tax.Tax.Code.Equals("SDI"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax, hostCompany);
				else if (tax.Tax.Code.Equals("ETT"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax, hostCompany);
				else if (tax.Tax.Code.Equals("SUI"))
					return SimpleTaxCalculator(company, payCheck, grossWage, employeePayChecks, payDay, tax, hostCompany);
			}
			return new PayrollTax();

		}

		private PayrollTax GetFIT(Company company, PayCheck payCheck, decimal grossWage, List<PayCheck> employeePayChecks, DateTime payDay, TaxByYear tax)
		{
			if(!TaxTables.FITTaxTable.Any(t=>t.Year==payDay.Year))
				throw new Exception("Taxes Not Available");
			var withholdingAllowance = grossWage -
			                           TaxTables.FitWithholdingAllowanceTable.First(
				                           i => i.Year == payDay.Year && i.PayrollSchedule == payCheck.Employee.PayrollSchedule)
				                           .AmoutForOneWithholdingAllowance * payCheck.Employee.FederalExemptions;

			var taxableWage = GetTaxExemptedDeductionAmount(company, payCheck, grossWage, employeePayChecks, payDay, tax);
			withholdingAllowance -= taxableWage;
			var withholdingAllowanceTest = withholdingAllowance < 0 ? 0 : withholdingAllowance;
			taxableWage = grossWage - taxableWage;
			var fitTaxTableRow =
				TaxTables.FITTaxTable.First(
					r =>
						r.Year == payDay.Year && r.PayrollSchedule == payCheck.Employee.PayrollSchedule &&
						(int) r.FilingStatus == (int) payCheck.Employee.FederalStatus
						&& r.RangeStart<= withholdingAllowanceTest
						&& (r.RangeEnd >= withholdingAllowanceTest || r.RangeEnd==0));

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
				Amount = Math.Round(taxAmount, 2, MidpointRounding.AwayFromZero),
				TaxableWage = Math.Round(taxableWage, 2, MidpointRounding.AwayFromZero),
				Tax = Mapper.Map<TaxByYear, Tax>(tax),
				YTDTax = Math.Round(employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.Amount) + taxAmount, 2, MidpointRounding.AwayFromZero),
				YTDWage = Math.Round(employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.TaxableWage) + taxableWage, 2, MidpointRounding.AwayFromZero)
			};
		}
		private PayrollTax GetMDEE(Company company, PayCheck payCheck, decimal grossWage, List<PayCheck> employeePayChecks, DateTime payDay, TaxByYear tax)
		{
			var ytdTax = employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.Amount);
			var ytdWage = employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.TaxableWage);
			if (payCheck.Employee.TaxCategory != EmployeeTaxCategory.USWorkerNonVisa)
			{
				return new PayrollTax
				{
					Amount = 0,
					TaxableWage = 0,
					Tax = Mapper.Map<TaxByYear, Tax>(tax),
					YTDTax = Math.Round(ytdTax, 2, MidpointRounding.AwayFromZero),
					YTDWage = Math.Round(ytdWage, 2, MidpointRounding.AwayFromZero)
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
				Amount = Math.Round(taxAmount, 2, MidpointRounding.AwayFromZero),
				TaxableWage = Math.Round(taxableWage, 2, MidpointRounding.AwayFromZero),
				Tax = Mapper.Map<TaxByYear, Tax>(tax),
				YTDTax = Math.Round(ytdTax + taxAmount, 2, MidpointRounding.AwayFromZero),
				YTDWage = Math.Round(ytdWage + taxableWage, 2, MidpointRounding.AwayFromZero)
			};
		}
		
		private PayrollTax SimpleTaxCalculator(Company company, PayCheck payCheck, decimal grossWage, List<PayCheck> employeePayChecks, DateTime payDay, TaxByYear tax, Company hostCompany)
		{
			var ytdTax = employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.Amount);
			var ytdWage = employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.TaxableWage);
			if (payCheck.Employee.TaxCategory != EmployeeTaxCategory.USWorkerNonVisa)
			{
				return new PayrollTax
				{
					Amount = 0,
					TaxableWage = 0,
					Tax = Mapper.Map<TaxByYear, Tax>(tax),
					YTDTax = Math.Round(ytdTax, 2, MidpointRounding.AwayFromZero),
					YTDWage = Math.Round(ytdWage, 2, MidpointRounding.AwayFromZero)
				};
			}


			var taxExemptedDeductions = GetTaxExemptedDeductionAmount(company, payCheck, grossWage, employeePayChecks, payDay, tax);
			
			
			var taxAmount = (decimal)0;
			var taxableWage = grossWage - taxExemptedDeductions;
			if (tax.AnnualMaxPerEmployee.HasValue)
			{
				if (ytdWage >= tax.AnnualMaxPerEmployee)
					taxableWage = 0;
				else
				{
					if ((ytdWage + grossWage - taxExemptedDeductions) > tax.AnnualMaxPerEmployee.Value)
					{
						taxableWage = tax.AnnualMaxPerEmployee.Value - ytdWage;
					}
				}
			}

			var taxRate = (decimal)0;

			if (!tax.Tax.IsCompanySpecific)
				taxRate = tax.Rate.HasValue ? tax.Rate.Value : tax.Tax.DefaultRate;
			else
			{
				if (!company.FileUnderHost)
				{
					if (company.CompanyTaxRates.Any(ct => ct.TaxCode == tax.Tax.Code && ct.TaxYear == payDay.Year))
					{
						taxRate = company.CompanyTaxRates.First(ct => ct.TaxCode == tax.Tax.Code && ct.TaxYear == payDay.Year).Rate;
					}
					else
					{
						taxRate = tax.Tax.DefaultRate;
					}
				}
				else
				{
					if (hostCompany.CompanyTaxRates.Any(ct => ct.TaxCode == tax.Tax.Code && ct.TaxYear == payDay.Year))
					{
						taxRate = hostCompany.CompanyTaxRates.First(ct => ct.TaxCode == tax.Tax.Code && ct.TaxYear == payDay.Year).Rate;
					}
					else
					{
						taxRate = tax.Tax.DefaultRate;
					}
				}
			}
			taxAmount = taxableWage * taxRate / 100;
			return new PayrollTax
			{
				Amount = Math.Round(taxAmount, 2, MidpointRounding.AwayFromZero),
				TaxableWage = Math.Round(taxableWage, 2, MidpointRounding.AwayFromZero),
				Tax = Mapper.Map<TaxByYear, Tax>(tax),
				YTDTax = Math.Round(ytdTax + taxAmount, 2, MidpointRounding.AwayFromZero),
				YTDWage = Math.Round(ytdWage + taxableWage, 2, MidpointRounding.AwayFromZero)
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
			else
			{
				if (payCheck.Employee.State.Exemptions < 2 && grossWage <= caSITLowIncomeTaxTableRow.Amount)
				{
					taxAmount = payCheck.Employee.State.AdditionalAmount;
					
				}
				else if (grossWage <= caSITLowIncomeTaxTableRow.AmountIfExemptGreaterThan2)
				{
					taxAmount = payCheck.Employee.State.AdditionalAmount;
				}
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
					var withholding = taxableWage;
					withholding -= stdDeductionAmt;

					var sitTaxTableRow =
					TaxTables.CASITTaxTable.First(
						r =>
							r.Year == payDay.Year && r.PayrollSchedule == payCheck.Employee.PayrollSchedule &&
							(int)r.FilingStatus == (int)payCheck.Employee.FederalStatus
							&& r.RangeStart <= withholding
							&& (r.RangeEnd >= withholding || r.RangeEnd == 0));

					taxAmount = sitTaxTableRow.FlatRate +
											(withholding - sitTaxTableRow.ExcessOverAmoutt) * sitTaxTableRow.AdditionalPercentage / 100;


					var exemptionAllowanceRow =
						TaxTables.ExemptionAllowanceTable.First(r => r.PayrollSchedule == payCheck.Employee.PayrollSchedule
																												 && r.Allowances == payCheck.Employee.State.Exemptions
																												 && r.Year == payCheck.PayDay.Year
							);

					taxAmount -= exemptionAllowanceRow.Amount;

					taxAmount = Math.Max(0, taxAmount) + payCheck.Employee.State.AdditionalAmount;


				}

			}
			
				
				

			
			return new PayrollTax
			{
				Amount = Math.Round(taxAmount, 2, MidpointRounding.AwayFromZero),
				TaxableWage = Math.Round(taxableWage, 2, MidpointRounding.AwayFromZero),
				Tax = Mapper.Map<TaxByYear, Tax>(tax),
				YTDTax = Math.Round(employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.Amount) + taxAmount, 2, MidpointRounding.AwayFromZero),
				YTDWage = Math.Round(employeePayChecks.SelectMany(p => p.Taxes.Where(t => t.Tax.Code == tax.Tax.Code)).Sum(t => t.TaxableWage) + taxableWage, 2, MidpointRounding.AwayFromZero)
			};
		}

		

		private decimal GetTaxExemptedDeductionAmount(Company company, PayCheck payCheck, decimal grossWage,
			List<PayCheck> employeePayChecks, DateTime payDay, TaxByYear tax)
		{
			var exempt =
				payCheck.Deductions.Where(
					d =>
						TaxTables.TaxDeductionPrecendences.Any(
							tdp => tdp.DeductionTypeId == d.Deduction.Type.Id && tdp.TaxCode.Equals(tax.Tax.Code))).ToList();
			if (exempt.Any())
			{
				var exempted = exempt.Sum(ded => ded.Amount);
				if (exempted > grossWage)
					return grossWage;
				return Math.Round(exempted, 2, MidpointRounding.AwayFromZero);
			}
			else
			{
				return 0;
			}
		}
	}
}
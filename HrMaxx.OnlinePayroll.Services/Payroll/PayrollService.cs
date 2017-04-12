using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using Magnum;
using Magnum.Extensions;
using Newtonsoft.Json;
using CompanyTaxRate = HrMaxx.OnlinePayroll.Models.CompanyTaxRate;

namespace HrMaxx.OnlinePayroll.Services.Payroll
{
	public class PayrollService : BaseService, IPayrollService
	{
		private readonly IPayrollRepository _payrollRepository;
		private readonly ITaxationService _taxationService;
		private readonly ICompanyService _companyService;
		private readonly ICompanyRepository _companyRepository;
		private readonly IJournalService _journalService;
		private readonly IPDFService _pdfService;
		private readonly IFileRepository _fileRepository;
		private readonly IHostService _hostService;
		private readonly IReportService _reportService;
		private readonly ICommonService _commonService;
		private readonly IMementoDataService _mementoDataService;
		private readonly IStagingDataService _stagingDataService;
		private readonly IMetaDataRepository _metaDataRepository;
		private readonly IReaderService _readerService;
		public IBus Bus { get; set; }

		public PayrollService(IPayrollRepository payrollRepository, ITaxationService taxationService, ICompanyService companyService, IJournalService journalService, IPDFService pdfService, IFileRepository fileRepository, IHostService hostService, IReportService reportService, ICommonService commonService, ICompanyRepository companyRepository, IMementoDataService mementoDataService, IStagingDataService stagingDataService, IMetaDataRepository metaDataRepository, IReaderService readerService)
		{
			_payrollRepository = payrollRepository;
			_taxationService = taxationService;
			_companyService = companyService;
			_journalService = journalService;
			_pdfService = pdfService;
			_fileRepository = fileRepository;
			_hostService = hostService;
			_reportService = reportService;
			_commonService = commonService;
			_companyRepository = companyRepository;
			_mementoDataService = mementoDataService;
			_stagingDataService = stagingDataService;
			_metaDataRepository = metaDataRepository;
			_readerService = readerService;
		}


		public Models.Payroll ProcessPayroll(Models.Payroll payroll)
		{
			try
			{
				var payTypes = _metaDataRepository.GetAllPayTypes();
				using (var txn = TransactionScopeHelper.Transaction())
				{
					//var companyPayChecks = _payrollRepository.GetPayChecksTillPayDay(payroll.Company.Id, payroll.PayDay);
					payroll.TaxPayDay = payroll.PayDay;
					var employeeAccumulations = _readerService.GetAccumulations(company: payroll.Company.Id,
						startdate: new DateTime(payroll.PayDay.Year, 1, 1), enddate: payroll.PayDay);
					
					var payCheckCount = 0;
					if (payroll.Company.IsLocation)
					{
						var parentCompany = _readerService.GetCompany(payroll.Company.ParentId.Value);
						payroll.Company.CompanyTaxRates = JsonConvert.DeserializeObject<List<CompanyTaxRate>>(JsonConvert.SerializeObject(parentCompany.CompanyTaxRates));
					}
					foreach (var paycheck in payroll.PayChecks.Where(pc=>pc.Included).OrderBy(pc=>pc.Employee.CompanyEmployeeNo))
					{
						paycheck.TaxPayDay = payroll.TaxPayDay;
						paycheck.IsHistory = payroll.IsHistory;
						var employeeAccumulation = employeeAccumulations.First(e => e.EmployeeId.Value == paycheck.Employee.Id);
						employeeAccumulation.PayCodes = employeeAccumulation.PayCodes ?? new List<PayCheckPayCode>();
						if (paycheck.Employee.PayType == EmployeeType.Hourly)
						{
							paycheck.Salary = 0;
							var defPayCode = paycheck.PayCodes.FirstOrDefault(pc => pc.PayCode.Id == 0);
							if (defPayCode != null)
							{
								paycheck.Employee.Rate = defPayCode.PayCode.HourlyRate;
								var empDefCode = paycheck.Employee.PayCodes.FirstOrDefault(pc => pc.Id == 0);
								if(empDefCode==null)
									paycheck.Employee.PayCodes.Add(defPayCode.PayCode);
								else
								{
									empDefCode.HourlyRate = defPayCode.PayCode.HourlyRate;
								}
							}
						}
						else if (paycheck.Employee.PayType == EmployeeType.Salary)
						{
							paycheck.Salary = Math.Round(paycheck.Salary, 2, MidpointRounding.AwayFromZero);
							paycheck.PayCodes = new List<PayrollPayCode>();
						}
						else if (paycheck.Employee.PayType == EmployeeType.JobCost)
						{
							paycheck.Salary = Math.Round(paycheck.Salary, 2, MidpointRounding.AwayFromZero);
						}
						else
						{
							const decimal overtimequotiant = (decimal)1.5;

							var previousPayCodes = employeeAccumulation.PayCodes;// employeePayChecks.SelectMany(p => p.PayCodes).ToList();
							var regularBreakPay = (decimal) 0;
							var regularWage = (decimal) 0;
							var regularHours = (decimal) 0;
							var regularOvertime = (decimal) 0;
							var regularBreaktime = (decimal) 0;
							var regularRate = (decimal) 0;
							paycheck.PayCodes.Where(pcode=>pcode.PayCode.Id==0).ToList().ForEach(pc1 =>
							{
								pc1.Amount = Math.Round(pc1.Hours * pc1.PayCode.HourlyRate, 2, MidpointRounding.AwayFromZero);
								pc1.OvertimeAmount = Math.Round(pc1.OvertimeHours * pc1.PayCode.HourlyRate * overtimequotiant, 2,
									MidpointRounding.AwayFromZero);
								pc1.YTD =
									Math.Round(previousPayCodes.Where(ppc => ppc.PayCodeId == pc1.PayCode.Id).Sum(ppc => ppc.Amount) + pc1.Amount, 2,
										MidpointRounding.AwayFromZero);
								pc1.YTDOvertime =
									Math.Round(
										previousPayCodes.Where(ppc => ppc.PayCodeId == pc1.PayCode.Id).Sum(ppc => ppc.Overtime) + pc1.OvertimeAmount,
										2, MidpointRounding.AwayFromZero);

								regularWage = Math.Round(pc1.Amount + pc1.OvertimeAmount, 2, MidpointRounding.AwayFromZero);
								regularBreakPay = Math.Round(pc1.BreakTime * pc1.PayCode.HourlyRate, 2, MidpointRounding.AwayFromZero);
								regularHours = pc1.Hours;
								regularOvertime = pc1.OvertimeHours;
								regularRate = pc1.PayCode.HourlyRate;
								regularBreaktime = pc1.BreakTime;
							});
							var pc = paycheck.PayCodes.First(pcode=>pcode.PayCode.Id==-1);
							if (paycheck.Notes.Contains("Piece-work:"))
							{
								paycheck.Notes = paycheck.Notes.Substring(0, paycheck.Notes.IndexOf("Piece-work:")) + string.Format("Piece-work: {0} piece @ {1} Reg Hr {2} OT Hr", pc.PWAmount.ToString("c"),
								pc.Hours.ToString("##.00"), pc.OvertimeHours.ToString("##.00"));
							}
							else
							{
								paycheck.Notes += string.Format(" Piece-work: {0} piece @ {1} Reg Hr {2} OT Hr", pc.PWAmount.ToString("c"),
								pc.Hours.ToString("##.00"), pc.OvertimeHours.ToString("##.00"));
							}
							var breakRate =
								Math.Round(
									((pc.PWAmount + regularWage - regularBreakPay)/
									 (pc.Hours + pc.OvertimeHours + regularHours + regularOvertime - (pc.BreakTime + regularBreaktime))), 2, MidpointRounding.AwayFromZero);

							if (breakRate < payroll.Company.MinWage)
							{
								breakRate = payroll.Company.MinWage;
							}
							var PRBreakPay = Math.Round(breakRate * pc.BreakTime, 2, MidpointRounding.AwayFromZero);
							var breakMakeup = Math.Round(((breakRate - regularRate)*regularBreaktime), 2, MidpointRounding.AwayFromZero);
							

							var prCalculatedRate = (pc.Hours + pc.OvertimeHours)>0 ? Math.Round((pc.PWAmount + PRBreakPay) / (pc.Hours + pc.OvertimeHours), 2, MidpointRounding.AwayFromZero) : 0;
							var prApplicableRate = (decimal) 0 + prCalculatedRate;
							if (prCalculatedRate>0 && prCalculatedRate < payroll.Company.MinWage && (pc.Hours + pc.OvertimeHours)>0)
							{
								prApplicableRate = payroll.Company.MinWage;
								var makeUpComp = paycheck.Compensations.FirstOrDefault(c => c.PayType.Id == 12);
								var finalAmount = Math.Round(prApplicableRate*(pc.Hours + pc.OvertimeHours), 2, MidpointRounding.AwayFromZero);
								var makeUpAmount = Math.Round(finalAmount - pc.PWAmount, 2, MidpointRounding.AwayFromZero);
								
								if (makeUpComp != null)
								{
									makeUpComp.Amount = makeUpAmount;
									makeUpComp.Hours = Math.Round(pc.Hours + pc.OvertimeHours, 2, MidpointRounding.AwayFromZero);
									makeUpComp.Rate = Math.Round(makeUpAmount/(pc.Hours + pc.OvertimeHours), 2, MidpointRounding.AwayFromZero);
								}
								else
								{
									paycheck.Compensations.Add(new PayrollPayType() { Amount = makeUpAmount, Hours = 0, Rate = 0, PayType = payTypes.First(pt=>pt.Id==12), YTD = 0 });
								}
							}

							if (PRBreakPay > 0)
							{
								var breakComp = paycheck.Compensations.FirstOrDefault(c => c.PayType.Id == 13);
								if (breakComp != null)
								{
									breakComp.Amount = PRBreakPay;
									breakComp.Hours = pc.BreakTime;
									breakComp.Rate = breakRate;
								}
								else
								{
									paycheck.Compensations.Add(new PayrollPayType() { Amount = PRBreakPay, Hours = pc.BreakTime, Rate = breakRate, PayType = payTypes.First(pt => pt.Id == 13), YTD = 0 });
								}

							}
							if (breakMakeup > 0)
							{
								var breakComp = paycheck.Compensations.FirstOrDefault(c => c.PayType.Id == 14);
								var breakmakeuprate = Math.Round(breakRate - regularRate, 2, MidpointRounding.AwayFromZero);
								if (breakComp != null)
								{
									breakComp.Amount = breakMakeup;
									breakComp.Hours = regularBreaktime;
									breakComp.Rate = breakmakeuprate;
								}
								else
								{
									paycheck.Compensations.Add(new PayrollPayType() { Amount = breakMakeup, Hours = regularBreaktime, Rate = breakmakeuprate, PayType = payTypes.First(pt => pt.Id == 14), YTD = 0 });
								}

							}
							
							paycheck.Employee.Rate = prApplicableRate;
							pc.PayCode.HourlyRate = prApplicableRate;
							
							if (pc.SickLeaveTime > 0)
							{
								var sickComp = paycheck.Compensations.FirstOrDefault(c => c.PayType.Id == 6);
								if (sickComp != null)
								{
									sickComp.Amount = Math.Round(Math.Max(prApplicableRate,regularRate) * pc.SickLeaveTime, 2, MidpointRounding.AwayFromZero);
									sickComp.Hours = pc.SickLeaveTime;
									sickComp.Rate = Math.Max(prApplicableRate, regularRate);
								}
								else
								{
									paycheck.Compensations.Add(new PayrollPayType() { Amount = Math.Round(Math.Max(prApplicableRate, regularRate) * pc.SickLeaveTime, 2, MidpointRounding.AwayFromZero), Hours = pc.SickLeaveTime, Rate = Math.Max(prApplicableRate, regularRate), PayType = payTypes.First(pt => pt.Id == 6), YTD = 0 });
								}

							}
						}
						
						paycheck.PayCodes = ProcessPayCodes(paycheck.PayCodes, paycheck, employeeAccumulation);
						paycheck.YTDSalary = Math.Round(employeeAccumulation.PayCheckWages.Salary + paycheck.Salary, 2, MidpointRounding.AwayFromZero);
						
						var grossWage = GetGrossWage(paycheck);
						paycheck.Compensations = ProcessCompensations(paycheck.Compensations, employeeAccumulation);
						paycheck.Accumulations = ProcessAccumulations(paycheck, payroll.Company.AccumulatedPayTypes, employeeAccumulation);
						grossWage = Math.Round(grossWage + paycheck.CompensationTaxableAmount, 2, MidpointRounding.AwayFromZero);

						var host = _hostService.GetHost(payroll.Company.HostId);
						paycheck.Deductions.ForEach(d=>d.Amount = d.Method==DeductionMethod.Amount ? d.Rate : d.Rate*grossWage/100);
						
						paycheck.Taxes = _taxationService.ProcessTaxes(payroll.Company, paycheck, paycheck.PayDay, grossWage, host.Company, employeeAccumulation);
						paycheck.Deductions = ApplyDeductions(grossWage, paycheck, employeeAccumulation);
						paycheck.GrossWage = grossWage;
						paycheck.NetWage = Math.Round( paycheck.GrossWage - paycheck.DeductionAmount -
															 paycheck.EmployeeTaxes + paycheck.CompensationNonTaxableAmount, 2, MidpointRounding.AwayFromZero);

						if (paycheck.Employee.WorkerCompensation != null)
						{
							employeeAccumulation.WorkerCompensations = employeeAccumulation.WorkerCompensations ??
							                                           new List<PayCheckWorkerCompensation>();
							paycheck.WCAmount = Math.Round(paycheck.GrossWage * paycheck.Employee.WorkerCompensation.Rate /100, 2, MidpointRounding.AwayFromZero);
							paycheck.WorkerCompensation = new PayrollWorkerCompensation
							{
								Wage = paycheck.GrossWage,
								WorkerCompensation = paycheck.Employee.WorkerCompensation,
								Amount = paycheck.WCAmount,
								YTD =
									Math.Round(employeeAccumulation.WorkerCompensations.Where(w=>w.WorkerCompensationId==paycheck.Employee.WorkerCompensation.Id).Sum(w=>w.YTD) + paycheck.WCAmount, 2,
										MidpointRounding.AwayFromZero)
							};
						}
						else
						{
							paycheck.WCAmount = 0;
						}
						paycheck.Status = PaycheckStatus.Processed;
						paycheck.IsVoid = false;
						paycheck.PaymentMethod = paycheck.Employee.PaymentMethod;
						paycheck.CheckNumber = payroll.StartingCheckNumber + payCheckCount++;

						paycheck.YTDGrossWage = Math.Round(employeeAccumulation.PayCheckWages.GrossWage + paycheck.GrossWage, 2, MidpointRounding.AwayFromZero);
						paycheck.YTDNetWage = Math.Round(employeeAccumulation.PayCheckWages.NetWage + paycheck.NetWage, 2, MidpointRounding.AwayFromZero);

						paycheck.PEOASOCoCheck = (payroll.Company.Contract.BillingOption == BillingOptions.Invoice &&
																	 payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck);
					}
					//PEO/ASO Co Check
					payroll.PEOASOCoCheck = (payroll.Company.Contract.BillingOption == BillingOptions.Invoice &&
					                         payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck);
					
					payroll.Status = PayrollStatus.Processed;
					txn.Complete();
					return payroll;
				}
			}
			catch (Exception e)
			{
				var message = string.Empty;
				if (e.Message.Contains("Taxes Not Available"))
					message = e.Message;
				else
					message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Process Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private List<PayTypeAccumulation> ProcessAccumulations(PayCheck paycheck, IEnumerable<AccumulatedPayType> accumulatedPayTypes, Accumulation employeeAccumulation)
		{
			var result = new List<PayTypeAccumulation>();
			var fiscalStartDate = CalculateFiscalStartDate(paycheck.Employee.SickLeaveHireDate, paycheck.PayDay);
			var fiscalEndDate = fiscalStartDate.AddYears(1).AddDays(-1);

			
			
			foreach (var payType in accumulatedPayTypes)	
			{
				if (!payType.CompanyManaged)
				{
					var ytdAccumulation = (decimal) 0;
					var ytdUsed = (decimal) 0;

					var carryOver = (decimal)0;

					if (employeeAccumulation.Accumulations != null && employeeAccumulation.Accumulations.Any(ac => ac.PayTypeId == payType.PayType.Id))
					{
						var accum = employeeAccumulation.Accumulations.First(ac => ac.PayTypeId == payType.PayType.Id);
						ytdAccumulation = accum.YTDFiscal;
						ytdUsed = accum.YTDUsed;
						carryOver = accum.CarryOver;
						
					}
					else if (employeeAccumulation.PreviousAccumulations!=null && employeeAccumulation.PreviousAccumulations.Any(ac => ac.PayTypeId == payType.PayType.Id))
					{
						carryOver = employeeAccumulation.PreviousAccumulations.First(ac => ac.PayTypeId == payType.PayType.Id).Available;
						
					}
					else
					{
						carryOver = paycheck.Employee.CarryOver;
					}

					var thisCheckValue = CalculatePayTypeAccumulation(paycheck, payType.RatePerHour);
					var thisCheckUsed = paycheck.Compensations.Any(p => p.PayType.Id == payType.PayType.Id)
						? CalculatePayTypeUsage(paycheck.Employee,
							paycheck.Compensations.First(p => p.PayType.Id == payType.PayType.Id).Amount)
						: (decimal) 0;
					var accumulationValue = (decimal) 0;
					if ((ytdAccumulation + thisCheckValue) >= payType.AnnualLimit)
						accumulationValue = Math.Max(payType.AnnualLimit - ytdAccumulation,0);
					else
					{
						accumulationValue = thisCheckValue;
					}

					result.Add(new PayTypeAccumulation
					{
						PayType = payType,
						AccumulatedValue = Math.Round(accumulationValue, 2, MidpointRounding.AwayFromZero),
						YTDFiscal = Math.Round(ytdAccumulation + accumulationValue, 2, MidpointRounding.AwayFromZero),
						FiscalStart = fiscalStartDate,
						FiscalEnd = fiscalEndDate,
						Used = Math.Round(thisCheckUsed, 2, MidpointRounding.AwayFromZero),
						YTDUsed = Math.Round(ytdUsed + thisCheckUsed, 2, MidpointRounding.AwayFromZero),
						CarryOver = Math.Round(carryOver, 2, MidpointRounding.AwayFromZero)
					});
				}
				else if(paycheck.Accumulations.Any(apt=>apt.PayType.Id==payType.Id))
				{
					var pt = paycheck.Accumulations.First(apt => apt.PayType.Id == payType.Id);
					pt.FiscalStart = fiscalStartDate;
					pt.FiscalEnd = fiscalEndDate;
					result.Add(pt);
				}
				

			}
			return result;
		}

		private decimal CalculatePayTypeUsage(Employee employee, decimal compnesaitonAmount)
		{
			var quotient = employee.Rate;
			if (employee.PayType == EmployeeType.Salary)
			{
				if (employee.PayrollSchedule == PayrollSchedule.Weekly)
					quotient = employee.Rate/(40);
				else if (employee.PayrollSchedule == PayrollSchedule.BiWeekly)
					quotient = (employee.Rate*26)/(40*52);
				else if (employee.PayrollSchedule == PayrollSchedule.SemiMonthly)
					quotient = (employee.Rate*24)/(40*52);
				else if (employee.PayrollSchedule == PayrollSchedule.Monthly)
					quotient = (employee.Rate*12)/(40*52);
			}
			else if (employee.PayType == EmployeeType.PieceWork || employee.PayType == EmployeeType.JobCost)
			{
				quotient = employee.Rate;
			}
			else
			{
				if (employee.PayCodes.Any(pc => pc.Id == 0 && pc.HourlyRate > 0))
					quotient = employee.PayCodes.First(pc => pc.Id == 0).HourlyRate;
				else
				{
					quotient = employee.PayCodes.Any() ?  employee.PayCodes.OrderBy(pc => pc.HourlyRate).First().HourlyRate : 0;
				}
			}
			return quotient==0 ? 0 : Convert.ToDecimal(Math.Round(compnesaitonAmount / quotient, 2, MidpointRounding.AwayFromZero));
		}

		private decimal CalculatePayTypeAccumulation(PayCheck paycheck, decimal ratePerHour)
		{
			if (paycheck.Employee.PayType == EmployeeType.Hourly || paycheck.Employee.PayType == EmployeeType.PieceWork)
			{
				return paycheck.PayCodes.Sum(pc => pc.Hours + pc.OvertimeHours)*ratePerHour;
			}
			else
			{
				if (paycheck.Employee.Rate <= 0)
					return 0;
				var val = (paycheck.Salary/paycheck.Employee.Rate)*(40*52/365)*ratePerHour;
				if (paycheck.Employee.PayrollSchedule == PayrollSchedule.Weekly)
					return 7*val;
				else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.BiWeekly)
					return 14*val;
				else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.SemiMonthly)
					return 15*val;
				else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.Monthly)
					return DateTime.DaysInMonth(paycheck.PayDay.Year, paycheck.PayDay.Month) * val;
				else
				{
					return 0;
				}
			}
		}

		private DateTime CalculateFiscalStartDate(DateTime hireDate, DateTime payDay)
		{
			DateTime result;
			var accumulationBaseDate = new DateTime(2015, 7, 1);
			if (hireDate <= accumulationBaseDate)
			{
				if (payDay.Month < 7)
					result = new DateTime(payDay.Year - 1, 7, 1);
				else
					result = new DateTime(payDay.Year, 7, 1);

			}
			else
			{
				if(payDay.Month<hireDate.Month)
					result = new DateTime(payDay.Year-1, hireDate.Month, hireDate.Day);
				else
				{
					result = new DateTime(payDay.Year, hireDate.Month, hireDate.Day);
				}
			}
			return result;
		}

		public Models.Payroll ConfirmPayroll(Models.Payroll payroll)
		{
			Models.Payroll savedPayroll;
			var affectedChecks = new List<PayCheck>();
			try
			{
				var companyPayChecks = _readerService.GetPayChecks(companyId: payroll.Company.Id, startDate: payroll.PayDay, year: payroll.PayDay.Year, isvoid: 0);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					payroll.TaxPayDay = payroll.PayDay;
					payroll.Status = PayrollStatus.Committed;
					payroll.PayChecks.ForEach(pc => { 
						pc.Status = PaycheckStatus.Saved;
						pc.IsHistory = payroll.IsHistory;
					});
					var companyIdForPayrollAccount = payroll.Company.Id;

					var coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
					savedPayroll = _payrollRepository.SavePayroll(payroll);
					var ptaccums = new List<PayCheckPayTypeAccumulation>();
					var pttaxes = new List<PayCheckTax>();
					var ptcomps = new List<PayCheckCompensation>();
					var ptdeds = new List<PayCheckDeduction>();
					var ptcodes = new List<PayCheckPayCode>();
					var ptwcs = new List<PayCheckWorkerCompensation>();
					savedPayroll.PayChecks.OrderBy(pc=>pc.Employee.CompanyEmployeeNo).ToList().ForEach(pc =>
					{
						
						pc.Accumulations.ForEach(a =>
						{
							var ptaccum = new PayCheckPayTypeAccumulation
							{
								PayCheckId = pc.Id,
								PayTypeId = a.PayType.PayType.Id,
								FiscalEnd = a.FiscalEnd,
								FiscalStart = a.FiscalStart,
								AccumulatedValue = a.AccumulatedValue,
								Used = a.Used,
								CarryOver = a.CarryOver
							};
							ptaccums.Add(ptaccum);
						});
						pc.Taxes.ForEach(t =>
						{
							var pt = new PayCheckTax()
							{
								PayCheckId = pc.Id,
								TaxId = t.Tax.Id,
								TaxableWage = t.TaxableWage,
								Amount = t.Amount
							};
							pttaxes.Add(pt);
						});
						pc.Compensations.ForEach(t =>
						{
							var pt = new PayCheckCompensation()
							{
								PayCheckId = pc.Id,
								PayTypeId = t.PayType.Id,
								Amount = t.Amount
							};
							ptcomps.Add(pt);
						});
						pc.Deductions.ForEach(t =>
						{
							var pt = new PayCheckDeduction()
							{
								PayCheckId = pc.Id,
								EmployeeDeductionId = t.EmployeeDeduction.Id,
								CompanyDeductionId = t.Deduction.Id,
								EmployeeDeductionFlat = JsonConvert.SerializeObject(t.EmployeeDeduction),
								Method = t.Method,
								Rate = t.Rate,
								AnnualMax = t.AnnualMax,
								Amount = t.Amount,
								Wage = t.Wage
							};
							ptdeds.Add(pt);
						});
						pc.PayCodes.ForEach(t =>
						{
							var pt = new PayCheckPayCode()
							{
								PayCheckId = pc.Id,
								PayCodeId = t.PayCode.Id,
								PayCodeFlat = JsonConvert.SerializeObject(t.PayCode),
								Amount = t.Amount,
								Overtime = t.OvertimeAmount
							};
							ptcodes.Add(pt);
						});
						if(pc.WorkerCompensation!=null)
						{
							var pt = new PayCheckWorkerCompensation()
							{
								PayCheckId = pc.Id,
								WorkerCompensationId = pc.WorkerCompensation.WorkerCompensation.Id,
								WorkerCompensationFlat = JsonConvert.SerializeObject(pc.WorkerCompensation.WorkerCompensation),
								Amount = pc.WorkerCompensation.Amount,
								Wage = pc.WorkerCompensation.Wage
							};
							ptwcs.Add(pt);
						};
				
						var j = CreateJournalEntry(payroll.Company, pc, coaList, payroll.UserName);
						pc.DocumentId = j.DocumentId;
						pc.CheckNumber = j.CheckNumber;

					});
					_payrollRepository.SavePayCheckPayTypeAccumulations(ptaccums);
					_payrollRepository.SavePayCheckTaxes(pttaxes);
					_payrollRepository.SavePayCheckWorkerCompensations(ptwcs);
					_payrollRepository.SavePayCheckPayCodes(ptcodes);
					_payrollRepository.SavePayCheckCompensations(ptcomps);
					_payrollRepository.SavePayCheckDeductions(ptdeds);
					//PEO/ASO Co Check
					if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice &&
					    payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
					{
						var host = _hostService.GetHost(payroll.Company.HostId);
						companyIdForPayrollAccount = host.Company.Id;
						coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
						savedPayroll.PayChecks.ForEach(pc =>
						{
							var j = CreateJournalEntry(payroll.Company, pc, coaList, payroll.UserName, true, companyIdForPayrollAccount);
							pc.DocumentId = j.DocumentId;
							pc.CheckNumber = j.CheckNumber;
						});
					}

					//var companyPayChecks = _payrollRepository.GetPayChecksPostPayDay(savedPayroll.Company.Id, savedPayroll.PayDay);
					
					
					foreach (var paycheck in savedPayroll.PayChecks)
					{
						var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id && p.PayDay>paycheck.PayDay && p.Id!=paycheck.Id).ToList();
						foreach (var employeeFutureCheck in employeeFutureChecks)
						{
							employeeFutureCheck.AddToYTD(paycheck);
							_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
							affectedChecks.Add(employeeFutureCheck);
						}
					}
					if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice)
					{
						var inv = CreatePayrollInvoice(savedPayroll, payroll.UserName, payroll.UserId, false);
						savedPayroll.InvoiceId = inv.Id;
						savedPayroll.InvoiceNumber = inv.InvoiceNumber;
						savedPayroll.InvoiceStatus = inv.Status;
						savedPayroll.Total = inv.Total;
					}
					var draftPayroll =
							_stagingDataService.GetMostRecentStagingData<PayrollStaging>(payroll.Company.Id);
					if (draftPayroll != null)
					{
						_stagingDataService.DeleteStagingData<PayrollStaging>(draftPayroll.MementoId);
					}
					txn.Complete();
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Confirm Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
				
				Bus.Publish<PayrollSavedEvent>(new PayrollSavedEvent
				{
					SavedObject = savedPayroll,
					TimeStamp = DateTime.Now,
					EventType = NotificationTypeEnum.Created,
					AffectedChecks = affectedChecks,
					UserName = savedPayroll.UserName,
					UserId = payroll.UserId
				});

				
		
			return savedPayroll;
			
				
				

			
		}

		public Models.Payroll ConfirmPayrollForMigration(Models.Payroll payroll)
		{
			try
			{
				
					payroll.Status = PayrollStatus.Committed;
					payroll.PayChecks.ForEach(pc => pc.Status = PaycheckStatus.Saved);
					var companyIdForPayrollAccount = payroll.Company.Id;

					var coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
					var savedPayroll = _payrollRepository.SavePayroll(payroll);
					savedPayroll.PayChecks.ForEach(pc =>
					{
						var j = CreateJournalEntry(payroll.Company, pc, coaList, payroll.UserName);
						pc.DocumentId = j.DocumentId;
					});

					//PEO/ASO Co Check
					if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice && payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
					{
						var host = _hostService.GetHost(payroll.Company.HostId);
						companyIdForPayrollAccount = host.Company.Id;
						coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
						savedPayroll.PayChecks.ForEach(pc =>
						{
							var j = CreateJournalEntry(payroll.Company, pc, coaList, payroll.UserName, true, companyIdForPayrollAccount);
							pc.DocumentId = j.DocumentId;
						});
					}

					//var companyPayChecks = _payrollRepository.GetPayChecksPostPayDay(savedPayroll.Company.Id, savedPayroll.PayDay);
					var companyPayChecks = _readerService.GetPayChecks(companyId: savedPayroll.Company.Id, startDate: savedPayroll.PayDay, year: savedPayroll.PayDay.Year, isvoid:0);
					var affectedChecks = new List<PayCheck>();
					foreach (var paycheck in savedPayroll.PayChecks)
					{
						var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id && p.Id!=paycheck.Id).ToList();
						foreach (var employeeFutureCheck in employeeFutureChecks)
						{
							employeeFutureCheck.AddToYTD(paycheck);
							_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
							affectedChecks.Add(employeeFutureCheck);
						}
					}
					
					return savedPayroll;
				


			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Confirm Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Models.Payroll VoidPayCheck(Guid payrollId, int payCheckId, string name, string user)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var payroll = _readerService.GetPayroll(payrollId);
					var paycheck = payroll.PayChecks.First(pc=>pc.Id==payCheckId);
					var journal = _journalService.GetPayCheckJournal(payCheckId, paycheck.PEOASOCoCheck);
					paycheck.Status = PaycheckStatus.Void;
					paycheck.IsVoid = true;
					var savedPaycheck = _payrollRepository.VoidPayCheck(paycheck, name);

					journal.IsVoid = true;
					var savedJournal = _journalService.VoidJournal(journal.Id, TransactionType.PayCheck, name, new Guid(user));
					if (paycheck.PEOASOCoCheck)
					{
						var journal1 = _journalService.GetPayCheckJournal(payCheckId, !paycheck.PEOASOCoCheck);
						if (journal1 != null)
						{
							journal1.IsVoid = true;
							_journalService.VoidJournal(journal1.Id, TransactionType.PayCheck, name, new Guid(user));
						}

					}
				
					//var companyPayChecks = _payrollRepository.GetPayChecksPostPayDay(savedPaycheck.Employee.CompanyId, savedPaycheck.PayDay);
					var companyPayChecks = _readerService.GetPayChecks(companyId: savedPaycheck.Employee.CompanyId, startDate: savedPaycheck.PayDay, year: savedPaycheck.PayDay.Year, isvoid:0);
					var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id && p.Id!=savedPaycheck.Id).ToList();
					foreach (var employeeFutureCheck in employeeFutureChecks)
					{
						employeeFutureCheck.SubtractFromYTD(paycheck);
						_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
					}


					
					txn.Complete();
					
					Bus.Publish<PayCheckVoidedEvent>(new PayCheckVoidedEvent
					{
						SavedObject = savedPaycheck,
						HostId = payroll.Company.HostId,
						UserId = new Guid(user),
						TimeStamp = DateTime.Now,
						EventType = NotificationTypeEnum.Updated,
						AffectedChecks = employeeFutureChecks,
						UserName = name
					});
				}
				return _readerService.GetPayroll(payrollId);


			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Confirm Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Models.Payroll VoidPayroll(Models.Payroll payroll1, string userName, string userId)
		{
			try
			{
				var affectedChecks = new List<PayCheck>();
				using (var txn = TransactionScopeHelper.Transaction())
				{

					var payroll = _readerService.GetPayroll(payroll1.Id);
					//var companyPayChecks = _payrollRepository.GetPayChecksPostPayDay(payroll1.Company.Id, payroll1.PayDay);
					var companyPayChecks = _readerService.GetPayChecks(companyId: payroll1.Company.Id, startDate: payroll1.PayDay, year: payroll1.PayDay.Year, isvoid:0);
					if (payroll.InvoiceId.HasValue)
					{
						var invoice = _readerService.GetPayrollInvoice(payroll.InvoiceId.Value);
						if(invoice.Status==InvoiceStatus.Draft || invoice.Status==InvoiceStatus.Submitted)
							DeletePayrollInvoice(payroll.InvoiceId.Value);
					}
					
						
					payroll.PayChecks.Where(pc=>!pc.IsVoid).ToList().ForEach(paycheck =>
					{
						var journal = _journalService.GetPayCheckJournal(paycheck.Id, paycheck.PEOASOCoCheck);
						paycheck.Status = PaycheckStatus.Void;
						paycheck.IsVoid = true;
						var savedPaycheck = _payrollRepository.VoidPayCheck(paycheck, userName);

						journal.IsVoid = true;
						var savedJournal = _journalService.VoidJournal(journal.Id, TransactionType.PayCheck, userName, new Guid(userId));
						if (paycheck.PEOASOCoCheck)
						{
							var journal1 = _journalService.GetPayCheckJournal(paycheck.Id, !paycheck.PEOASOCoCheck);
							if (journal1 != null)
							{
								journal1.IsVoid = true;
								_journalService.VoidJournal(journal1.Id, TransactionType.PayCheck, userName, new Guid(userId));
							}

						}

						
						var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id && p.Id!=paycheck.Id).ToList();
						foreach (var employeeFutureCheck in employeeFutureChecks)
						{
							employeeFutureCheck.SubtractFromYTD(paycheck);
							_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
							affectedChecks.Add(employeeFutureCheck);
						}
					});

					txn.Complete();
					
				}
				payroll1 = _readerService.GetPayroll(payroll1.Id);
				foreach (var payCheck in payroll1.PayChecks)
				{
					Bus.Publish<PayCheckVoidedEvent>(new PayCheckVoidedEvent
					{
						SavedObject = payCheck,
						HostId = payroll1.Company.HostId,
						UserId = new Guid(userId),
						TimeStamp = DateTime.Now,
						EventType = NotificationTypeEnum.Updated,
						AffectedChecks = affectedChecks.Where(pc=>pc.Employee.Id==payCheck.Employee.Id).ToList(),
						UserName = userName
					});	
				}
				

				return payroll1;


			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Confirm Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private Models.Payroll VoidPayCheckForMigration(Guid payrollId, int payCheckId, string name, Guid userId)
		{
			try
			{
				
					var paycheck = _readerService.GetPaycheck(payCheckId);
					var journal = _journalService.GetPayCheckJournal(payCheckId, paycheck.PEOASOCoCheck);
					paycheck.Status = PaycheckStatus.Void;
					paycheck.IsVoid = true;
					var savedPaycheck = _payrollRepository.VoidPayCheck(paycheck, name);

					journal.IsVoid = true;
					var savedJournal = _journalService.VoidJournal(journal.Id, TransactionType.PayCheck, name, userId);
					if (paycheck.PEOASOCoCheck)
					{
						var journal1 = _journalService.GetPayCheckJournal(payCheckId, !paycheck.PEOASOCoCheck);
						if (journal1 != null)
						{
							journal1.IsVoid = true;
							_journalService.VoidJournal(journal1.Id, TransactionType.PayCheck, name, userId);
						}

					}

					//var companyPayChecks = _payrollRepository.GetPayChecksPostPayDay(savedPaycheck.Employee.CompanyId, savedPaycheck.PayDay);
					var companyPayChecks = _readerService.GetPayChecks(companyId:savedPaycheck.Employee.CompanyId, startDate:savedPaycheck.PayDay, year:savedPaycheck.PayDay.Year, isvoid:0);
					var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id && p.Id!=paycheck.Id).ToList();
					foreach (var employeeFutureCheck in employeeFutureChecks)
					{
						employeeFutureCheck.SubtractFromYTD(paycheck);
						_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
					}



					return _readerService.GetPayroll(payrollId);


			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Confirm Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto PrintPayCheck(int payCheckId)
		{
			try
			{
				var payCheck = _readerService.GetPaycheck(payCheckId);
				var payroll = _readerService.GetPayroll(payCheck.PayrollId);
				var journal = _journalService.GetPayCheckJournal(payCheck.Id, payCheck.PEOASOCoCheck);
				return PrintPayCheck(payroll, new List<PayCheck>(){ payCheck}, new List<Journal>(){ journal});
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Payrolls for Invoice By id=" + payCheckId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto PrintPayCheck(PayCheck payCheck)
		{
			try
			{
				var payroll = _readerService.GetPayroll(payCheck.PayrollId);
				var journal = _journalService.GetPayCheckJournal(payCheck.Id, payroll.PEOASOCoCheck);
				return PrintPayCheck(payroll, new List<PayCheck>(){ payCheck }, new List<Journal>(){ journal});
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Payrolls for Invoice By id=" + payCheck.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private FileDto PrintPayCheck(Models.Payroll payroll, PayCheck payCheck)
		{
			try
			{
				var journal = _journalService.GetPayCheckJournal(payCheck.Id, payCheck.PEOASOCoCheck);
				return PrintPayCheck(payroll, new List<PayCheck>() { payCheck }, new List<Journal>() { journal });
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Payrolls for Invoice By id=" + payCheck.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void MarkPayCheckPrinted(int payCheckId)
		{
			var paycheck = _readerService.GetPaycheck(payCheckId);
			if (paycheck.Status == PaycheckStatus.Printed || paycheck.Status==PaycheckStatus.PrintedAndPaid)
				return;
			if (paycheck.Status == PaycheckStatus.Saved)
				_payrollRepository.ChangePayCheckStatus(payCheckId, PaycheckStatus.Printed);
			else if (paycheck.Status==PaycheckStatus.Paid)
				_payrollRepository.ChangePayCheckStatus(payCheckId, PaycheckStatus.PrintedAndPaid);
		}

		public FileDto PrintPayrollReport(Models.Payroll payroll)
		{
			try
			{
				var returnFile = _reportService.PrintPayrollSummary(payroll);
				return returnFile;
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Print Payrolls for id=" + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto PrintPayrollChecks(Models.Payroll payroll)
		{
			try
			{
				
					var documents = new List<FileDto>();
					var updateStatus = false;
					//if ((int)payroll.Status > 2 && (int)payroll.Status < 6)
					//{
					//	foreach (var paychecks in payroll.PayChecks.Where(pc => !pc.IsVoid).OrderBy(pc => pc.CheckNumber))
					//	{
							
					//			var file = PrintPayCheck(payroll, paychecks);
					//			if(paychecks.Status!=PaycheckStatus.Printed && paychecks.Status!=PaycheckStatus.PrintedAndPaid)
					//				updateStatus = true;
							
					//		documents.Add(file);
					//	}
					//}



					//var returnFile = _reportService.PrintPayrollWithoutSummary(payroll, documents);
					//using (var txn = TransactionScopeHelper.Transaction())
					//{
					//	if (payroll.Status == PayrollStatus.Committed || (payroll.Status == PayrollStatus.Printed && updateStatus))
					//		_payrollRepository.MarkPayrollPrinted(payroll.Id);
					//	txn.Complete();
					//}
				var returnFile = new FileDto();
				if ((int) payroll.Status > 2 && (int) payroll.Status < 6)
				{
					var journals = _journalService.GetPayrollJournals(payroll.Id, payroll.PEOASOCoCheck);
					returnFile = PrintPayCheck(payroll, payroll.PayChecks.Where(pc => !pc.IsVoid).OrderBy(pc=>pc.Employee.CompanyEmployeeNo).ToList(), journals);
				}
				using (var txn = TransactionScopeHelper.Transaction())
				{
					if (payroll.Status == PayrollStatus.Committed || (payroll.Status == PayrollStatus.Printed && payroll.PayChecks.Any(pc=>!pc.IsVoid && pc.Status!=PaycheckStatus.Printed && pc.Status!=PaycheckStatus.PrintedAndPaid)))
						_payrollRepository.MarkPayrollPrinted(payroll.Id);
					txn.Complete();
				}
				return returnFile;
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Print Payrolls for id=" + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto PrintPayrollTimesheet(Models.Payroll payroll)
		{
			try
			{
				var returnFile = _reportService.PrintPayrollTimesheet(payroll);
				return returnFile;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Print Payroll Timesheet for id=" + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		

		public PayrollInvoice CreatePayrollInvoice(Models.Payroll payroll, string fullName, Guid userId, bool fetchCompany)
		{
			var payrollInvoice = new PayrollInvoice { Id = CombGuid.Generate(), UserId = userId, UserName = fullName, LastModified = DateTime.Now, ProcessedBy = fullName };
			return CreateInvoice(payroll, payrollInvoice, fetchCompany);
		}

		private PayrollInvoice CreateInvoice(Models.Payroll payroll, PayrollInvoice payrollInvoice, bool fetchCompany)
		{
			try
			{
				var company = fetchCompany ? _readerService.GetCompany(payroll.Company.Id) : payroll.Company;
				var previousInvoices = _readerService.GetPayrollInvoices(companyId:payroll.Company.Id);
				//var voidedPayChecks = _payrollRepository.GetUnclaimedVoidedchecks(payroll.Company.Id);
				var voidedPayChecks = _readerService.GetPayChecks(companyId: payroll.Company.Id, isvoid: 1);
				
				payrollInvoice.Initialize(payroll, previousInvoices, _taxationService.GetApplicationConfig().EnvironmentalChargeRate, company, voidedPayChecks);

				var savedInvoice = _payrollRepository.SavePayrollInvoice(payrollInvoice);
				if (savedInvoice.Company == null)
					savedInvoice.Company = company;
				if (!string.IsNullOrWhiteSpace(payroll.Notes))
				{
					_commonService.AddToList<Comment>(EntityTypeEnum.Company, EntityTypeEnum.Comment, company.Id, new Comment { Content = string.Format("Invoice #{0}: {1}", payrollInvoice.InvoiceNumber, payroll.Notes), TimeStamp = savedInvoice.LastModified });
				}
				var memento = Memento<PayrollInvoice>.Create(savedInvoice, EntityTypeEnum.Invoice, savedInvoice.UserName, string.Format("Invoice created"), payrollInvoice.UserId);
				_mementoDataService.AddMementoData(memento);
				Bus.Publish<InvoiceCreatedEvent>(new InvoiceCreatedEvent
				{
					SavedObject = savedInvoice,
					EventType = NotificationTypeEnum.Created,
					TimeStamp = DateTime.Now,
					UserId = payrollInvoice.UserId,
					UserName = savedInvoice.UserName
				});
				return savedInvoice;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " create invoice for payroll id=" + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public PayrollInvoice RecreateInvoice(Guid invoiceId, string fullName, Guid userId)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var invoice = _readerService.GetPayrollInvoice(invoiceId);
					var payroll = _readerService.GetPayrolls(null, invoiceId:invoice.Id).First();
					var payrollInvoice = new PayrollInvoice { Id = invoice.Id, UserName = fullName, UserId = userId, LastModified = DateTime.Now, ProcessedBy = payroll.UserName, InvoiceNumber = invoice.InvoiceNumber};
					_payrollRepository.DeletePayrollInvoice(invoiceId);
					var recreated = CreateInvoice(payroll, payrollInvoice, true);
					txn.Complete();

					return recreated;
				}
			
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " re-create invoice for invoice id=" + invoiceId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public PayrollInvoice SavePayrollInvoice(PayrollInvoice invoice)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					invoice.InvoicePayments.ForEach(p =>
					{
						if (p.Status == PaymentStatus.Draft)
						{
							p.Status = (p.Method == InvoicePaymentMethod.Cash || p.Method == InvoicePaymentMethod.CertFund || p.Method == InvoicePaymentMethod.CorpCheck) ? PaymentStatus.Paid : PaymentStatus.Submitted;
						}

					});
					var dbIncvoice = _readerService.GetPayrollInvoice(invoice.Id);
					if (dbIncvoice.MiscCharges.Any(dbmc => dbmc.RecurringChargeId>0 && (!invoice.MiscCharges.Any(mc=>mc.RecurringChargeId==dbmc.RecurringChargeId) || invoice.MiscCharges.Any(mc=>mc.RecurringChargeId==dbmc.RecurringChargeId && mc.Amount!=dbmc.Amount))))
					{
						var deleted =
							dbIncvoice.MiscCharges.Where(
								dbmc =>
									dbmc.RecurringChargeId > 0 &&
									!invoice.MiscCharges.Any(mc => mc.RecurringChargeId == dbmc.RecurringChargeId))
								.ToList();
						var updated =
							dbIncvoice.MiscCharges.Where(
								dbmc =>
									dbmc.RecurringChargeId > 0 &&
									invoice.MiscCharges.Any(mc => mc.RecurringChargeId == dbmc.RecurringChargeId &&  mc.Amount!=dbmc.Amount))
								.ToList();
						var futureInvoices = _readerService.GetPayrollInvoices(Guid.Empty, companyId: invoice.CompanyId)
								.Where(ci => ci.InvoiceNumber > invoice.InvoiceNumber)
								.ToList();
						futureInvoices.ForEach(fi=>
						{
							var update = false;
							fi.MiscCharges.ForEach(mc =>
							{
								if (mc.RecurringChargeId > 0)
								{
									var del = deleted.FirstOrDefault(mc1 => mc1.RecurringChargeId == mc.RecurringChargeId);
									var upd = updated.FirstOrDefault(mc1 => mc1.RecurringChargeId == mc.RecurringChargeId);
									if (del != null)
									{
										update = true;
										mc.PreviouslyClaimed -= del.Amount;
									}
									else if (upd != null)
									{
										update = true;
										mc.PreviouslyClaimed = mc.PreviouslyClaimed - upd.Amount +
										                       invoice.MiscCharges.First(mc2 => mc2.RecurringChargeId == mc.RecurringChargeId).Amount;
									}

								}
							});
							if (update)
								_payrollRepository.SavePayrollInvoice(fi);
						});
					}
					
					if (dbIncvoice != null)
					{
						invoice.CalculateTotal();
						if (dbIncvoice.Status == InvoiceStatus.Draft && invoice.Status == InvoiceStatus.Submitted)
						{
							invoice.SubmittedOn = DateTime.Now;
							invoice.InvoiceDate = invoice.SubmittedOn.Value;
							invoice.SubmittedBy = invoice.UserName;
						}
						if (dbIncvoice.Status == InvoiceStatus.Submitted && invoice.Status == InvoiceStatus.Delivered)
						{
							invoice.DeliveredOn = DateTime.Now;
							invoice.DeliveredBy = invoice.UserName;
						}

						if (invoice.Status != InvoiceStatus.OnHold && (invoice.Status == InvoiceStatus.Delivered || invoice.Status == InvoiceStatus.PartialPayment || invoice.Status == InvoiceStatus.PaymentBounced || invoice.Status == InvoiceStatus.Paid || invoice.Status == InvoiceStatus.Deposited || invoice.Status == InvoiceStatus.NotDeposited || invoice.Status == InvoiceStatus.ACHPending ))
						{
							if (invoice.Balance == 0)
								invoice.Status = InvoiceStatus.Paid;
							else if (invoice.Balance <= invoice.Total)
							{
								if (invoice.InvoicePayments.Any(p => p.Status == PaymentStatus.PaymentBounced))
								{
									invoice.Status = InvoiceStatus.PaymentBounced;
									_commonService.AddToList(EntityTypeEnum.Company, EntityTypeEnum.Comment, invoice.CompanyId, new Comment{ Content = string.Format("Invoice #{0} - Payment Bounced",invoice.InvoiceNumber), LastModified = DateTime.Now, UserName = invoice.UserName});
								}
								else if (invoice.InvoicePayments.Any(p => p.Status == PaymentStatus.Submitted))
								{
									invoice.Status = InvoiceStatus.NotDeposited;
								}
								else if (invoice.InvoicePayments.Any(p => p.Status == PaymentStatus.Deposited))
								{
									invoice.Status = InvoiceStatus.Deposited;
									
								}
								else if (invoice.InvoicePayments.Any(p => p.Method==InvoicePaymentMethod.ACH && p.Status == PaymentStatus.Submitted))
								{
									invoice.Status = InvoiceStatus.ACHPending;
								}
								else if (invoice.InvoicePayments.Any())
								{
									invoice.Status = InvoiceStatus.PartialPayment;
								}
								else
								{
									invoice.Status = InvoiceStatus.Delivered;
								}
							}
						}

					}
					var savedInvoice = _payrollRepository.SavePayrollInvoice(invoice);
					var memento = Memento<PayrollInvoice>.Create(savedInvoice, EntityTypeEnum.Invoice, savedInvoice.UserName, string.Format("Invoice updated"), invoice.UserId);
					_mementoDataService.AddMementoData(memento);
					txn.Complete();

					return savedInvoice;
				}

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Save Invoice for company id=" + invoice.CompanyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void DeletePayrollInvoice(Guid invoiceId)
		{
			try
			{
				_payrollRepository.DeletePayrollInvoice(invoiceId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Delete Invoice with id=" + invoiceId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<Models.Payroll> FixPayrollData(Guid? companyId)
		{
			try
			{
				var payrolls = _readerService.GetPayrolls(companyId);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					
					var paychecks = payrolls.SelectMany(p => p.PayChecks).Where(pc => pc.Employee.PayType == EmployeeType.PieceWork).ToList();

					var paychecksWithBoth =
						paychecks.Where(
							pc =>
								pc.PayCodes.Any(pcc => pcc.PayCode.Id == 0 && pcc.BreakTime > 0) && pc.PayCodes.Any(pcc => pcc.PayCode.Id == -1 && pcc.BreakTime > 0))
							.ToList();
					var paychecksWithOnlyRegular =
						paychecks.Where(
							pc =>
								pc.PayCodes.Any(pcc => pcc.PayCode.Id == 0 && pcc.BreakTime > 0) && !pc.PayCodes.Any(pcc => pcc.PayCode.Id == -1 && pcc.BreakTime > 0))
							.ToList();
					var paychecksWithOnlyPW =
						paychecks.Where(
							pc =>
								!pc.PayCodes.Any(pcc => pcc.PayCode.Id == 0 && pcc.BreakTime > 0) && pc.PayCodes.Any(pcc => pcc.PayCode.Id == -1 && pcc.BreakTime > 0))
							.ToList();
					var breakcompChecks = paychecks.Where(pc => pc.Compensations.Any(c => c.PayType.Id == 13 || c.PayType.Id == 12)).ToList();
					breakcompChecks.ForEach(pc =>
					{
						var breakComp = pc.Compensations.FirstOrDefault(c => c.PayType.Id == 13);
						if (breakComp != null)
							breakComp.PayType.Description = "Piece-Work Break Pay";
						var makeupComp = pc.Compensations.FirstOrDefault(c => c.PayType.Id == 12);
						if (makeupComp != null)
							makeupComp.PayType.Description = "Piece-Work Break Pay";

						_payrollRepository.SavePayCheck(pc);
					});
					txn.Complete();
				}
				
				//var payrolls = _payrollRepository.GetAllPayrolls(companyId);
				//var companyPayChecks = payrolls.SelectMany(p => p.PayChecks).ToList();
				//payrolls.OrderBy(p=>p.PayDay).ToList().ForEach(payroll => payroll.PayChecks.ForEach(pc =>
				//{
				//	var employee = employees.First(e => e.Id == pc.Employee.Id);
				//	pc.Accumulations = ProcessAccumulations(pc, payroll.Company.AccumulatedPayTypes);
				//	pc.Employee.HostId = employee.HostId;
				//	if (pc.WorkerCompensation != null)
				//	{
				//		pc.WorkerCompensation.Wage = pc.GrossWage;
						
				//	}
				//	if (!string.IsNullOrWhiteSpace(pc.Notes))
				//	{
				//		try
				//		{
				//			var comments = JsonConvert.DeserializeObject<List<Comment>>(pc.Notes);
				//			if (comments != null && comments.Any())
				//			{
				//				var last = comments.OrderByDescending(c => c.TimeStamp).FirstOrDefault();
				//				if (last != null)
				//					pc.Notes = last.Content;

				//			}
				//			else
				//				pc.Notes = string.Empty;
				//		}
				//		catch (Exception ex)
				//		{
				//			pc.Notes = pc.Notes;
				//		}
						
				//	}
				//	pc.Deductions.ForEach(d =>
				//	{
				//		if (employee.Deductions.Any(ed => ed.Deduction.Id == d.Deduction.Id))
				//			d.EmployeeDeduction = employee.Deductions.First(ed => ed.Deduction.Id == d.Deduction.Id);
				//	});
				//	pc.Taxes.ForEach(t =>
				//	{
				//		if (t.Tax.Code.Equals("SIT"))
				//		{
				//			t.TaxableWage = pc.Taxes.First(t1 => t1.Tax.Code.Equals("FIT")).TaxableWage;
				//		}
				//	});
				//	if (pc.Employee.PayType == EmployeeType.JobCost)
				//	{
				//		var jobCostCodeId = -2;
				//		pc.PayCodes.Where(p=>p.PayCode.Id<0).ToList().ForEach(p=>p.PayCode.Id=jobCostCodeId--);
				//	}
				//	var affectedChecks = new List<PayCheck>();
				//	pc.ResetYTD();
				//	var employeePreviousChecks = companyPayChecks.Where(p => p.Employee.Id == pc.Employee.Id && p.PayDay<pc.PayDay).ToList();
				//	if (employeePreviousChecks.Any())
				//	{
				//		foreach (var a in employeePreviousChecks)
				//		{
				//			pc.AddToYTD(a);
				//		}
				//	}
					
					
					
				//	_payrollRepository.SavePayCheck(pc);
				//}));
				
				return payrolls;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Fix Payroll Data for all" );
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private PDFModel GetPdfModel(Models.Payroll payroll, PayCheck payCheck, Journal journal, Company company,
			Company nameCompany, Company company1, Account bankcoa, DocumentDto signature)
		{
			var pdf = new PDFModel
			{
				Name = string.Format("Pay Check_{1}_{2} {0}.pdf", payCheck.PayDay.ToString("MMddyyyy"), payCheck.PayrollId, payCheck.Id),
				TargetId = payCheck.Id,
				NormalFontFields = new List<KeyValuePair<string, string>>(),
				BoldFontFields = new List<KeyValuePair<string, string>>(),
				TargetType = EntityTypeEnum.PayCheck,
				Template = company1.PayCheckStock.GetHrMaxxName(),
				DocumentId = journal.DocumentId,
				Signature = null
			};

			if (payCheck.PaymentMethod == EmployeePaymentMethod.Check)
			{
				if (signature != null)
				{
					pdf.Signature = new PDFSignature
					{
						Path = _fileRepository.GetDocumentLocation(signature.Doc),
						X = 375,
						Y =
							company1.PayCheckStock == PayCheckStock.LaserTop || company1.PayCheckStock == PayCheckStock.MICREncodedTop ||
							company1.PayCheckStock == PayCheckStock.MICRQb
								? 587
								: 330,
						ScaleX = (float)0.7,
						ScaleY = (float)0.7

					};

				}
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("dd-spec", string.Empty));
			}
			else
			{
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("dd-spec", "NON-NEGOTIABLE     DIRECT DEPOSIT"));
			}

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Bank", bankcoa.BankAccount.BankName));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("BankfractionId", bankcoa.BankAccount.FractionId));


			pdf.BoldFontFields.Add(new KeyValuePair<string, string>("Name", nameCompany.Name));
			if (payroll.Company.PayCheckStock == PayCheckStock.LaserMiddle)
			{
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("Name-2", nameCompany.Name));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo-2", payCheck.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : payCheck.CheckNumber.ToString()));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date-3", payCheck.PayDay.ToString("MM/dd/yyyy")));
			}
			pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo", payCheck.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : payCheck.CheckNumber.ToString()));
			pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo2", payCheck.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : payCheck.CheckNumber.ToString()));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Address", nameCompany.CompanyAddress.AddressLine1));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("City", nameCompany.CompanyAddress.AddressLine2));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName", payCheck.Employee.FullName));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName2", payCheck.Employee.FullName));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("CompanyMemo", payroll.Company.Memo.Replace(Environment.NewLine, string.Empty).Replace("\n", string.Empty)));
			if (payroll.Company.PayCheckStock == PayCheckStock.MICREncodedTop || payroll.Company.PayCheckStock == PayCheckStock.MICRQb)
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName3", payCheck.Employee.FullName));
			}
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text1", payCheck.Employee.Contact.Address.AddressLine1));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text3", payCheck.Employee.Contact.Address.AddressLine2));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date1", payCheck.PayDay.ToString("MM/dd/yyyy")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date2", payCheck.PayDay.ToString("MM/dd/yyyy")));

			var words = Utilities.NumberToWords(Math.Floor(payCheck.NetWage));
			var decPlaces = (int)(((decimal)payCheck.NetWage % 1) * 100);
			if (payroll.Company.PayCheckStock == PayCheckStock.MICREncodedTop ||
					payroll.Company.PayCheckStock == PayCheckStock.MICRQb)
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Amount", "****" + payCheck.NetWage.ToString("F")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("AmtInWords", string.Format("{0} {1}/100 {2}", words, decPlaces, "****")));
			}
			else
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Amount", payCheck.NetWage.ToString("F")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("AmtInWords", string.Format("{0} {1}/100 {2}", words, decPlaces, string.Empty)));

				if (payCheck.PaymentMethod == EmployeePaymentMethod.Check)
				{
					var micr = "00000000";
					micr =
						micr.Substring(0,
							(8 - payCheck.CheckNumber.ToString().Length) < 0 ? 0 : 8 - payCheck.CheckNumber.ToString().Length) +
						payCheck.CheckNumber.ToString();
					var micrVal = string.Format("C{0}C A{1}A {2}C", micr, bankcoa.BankAccount.RoutingNumber,
						bankcoa.BankAccount.AccountNumber);
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("MICR", micrVal));
				}

			}

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Memo", string.Format("Pay Period {0}-{1}", payCheck.StartDate.ToString("d"), payCheck.EndDate.ToString("d"))));
			var caption8 = string.Format("****-**-{0}                                                {1} {2}",
				payCheck.Employee.SSN.Substring(payCheck.Employee.SSN.Length - 4), "Employee No:", (payCheck.Employee.CompanyEmployeeNo.HasValue ? payCheck.Employee.CompanyEmployeeNo.Value.ToString() : string.Empty));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Caption8", caption8));
			pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CompName", nameCompany.Name));

			if (payroll.Company.PayCheckStock != PayCheckStock.MICRQb)
			{
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo-2",
					payCheck.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : payCheck.CheckNumber.ToString()));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compAddress", nameCompany.CompanyAddress.AddressLine1));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compCity", nameCompany.CompanyAddress.AddressLine2));

				var sum2 = string.Format("Federal Status: {0}{1}Federal Exemptions: {2}{3}Additional Fed Withholding: {4}",
					payCheck.Employee.FederalStatus.GetDbName(), "".PadRight(57 - payCheck.Employee.FederalStatus.GetDbName().Length),
					payCheck.Employee.FederalExemptions,
					"".PadRight(66 - payCheck.Employee.FederalAdditionalAmount.ToString("C").Length),
					payCheck.Employee.FederalAdditionalAmount.ToString("C"));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum2", sum2));

				var text8 = string.Format("State Status:    {0}{1}State Exemptions:    {2}{3}Additional State Withholding: {4}",
					payCheck.Employee.State.TaxStatus.GetDbName(),
					"".PadRight(57 - payCheck.Employee.State.TaxStatus.GetDbName().Length), payCheck.Employee.State.Exemptions,
					"".PadRight(66 - payCheck.Employee.State.AdditionalAmount.ToString("C").Length),
					payCheck.Employee.State.AdditionalAmount.ToString("C"));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text8", text8));
			}
			else
			{
				var sum2 = string.Format("Federal Status: {0}      Federal Exemptions: {1}      Additional Fed Withholding: {2}",
					payCheck.Employee.FederalStatus.GetDbName(),
					payCheck.Employee.FederalExemptions,
					payCheck.Employee.FederalAdditionalAmount.ToString("C"));


				var text8 = string.Format("State Status: {0}      State Exemptions: {1}      Additional State Withholding: {2}",
					payCheck.Employee.State.TaxStatus.GetDbName(),
					payCheck.Employee.State.Exemptions,
					payCheck.Employee.State.AdditionalAmount.ToString("C"));

				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum2", sum2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text8", text8));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum2-1", sum2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text8-1", text8));


				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName2-1", payCheck.Employee.FullName));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum1-1", string.Format("Pay Period {0} - {1}", payCheck.StartDate.ToString("d"), payCheck.EndDate.ToString("d"))));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("CompanyMemo-1", payroll.Company.Memo));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CompName-1", company.Name));
				if (payCheck.Employee.PayType == EmployeeType.Salary || payCheck.Employee.PayType == EmployeeType.JobCost)
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr1-s-1", "Salary"));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("am-1-1", payCheck.Salary.ToString("C")));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdam-1-1", payCheck.YTDSalary.ToString("C")));
				}
				else
				{

					var hrcounter = 1;
					var otcounter = 1;
					foreach (var payCode in payCheck.PayCodes.Where(p => p.Hours > 0 || p.OvertimeHours > 0 || p.YTD > 0 || p.YTDOvertime > 0)
						.OrderBy(p=>p.PayCode.Id)
						.ThenBy(p => p.Hours)
						.ThenByDescending(p => p.OvertimeHours)
						.ThenByDescending(p => p.YTD)
						.ThenByDescending(p => p.YTDOvertime).ToList())
					{
						if (hrcounter < 4 && (payCode.Amount > 0 || payCode.YTD > 0))
						{
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + hrcounter + "-s-1", payCode.PayCode.Description));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("hr-" + hrcounter + "-1", payCode.Hours.ToString()));
							if(payCode.PayCode.Id!=-1)
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("r-" + hrcounter + "-1",
									payCode.PayCode.HourlyRate.ToString("C")));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("am-" + hrcounter + "-1", payCode.Amount.ToString("c")));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdam-" + hrcounter + "-1", payCode.YTD.ToString("C")));

							hrcounter++;
						}
						if (otcounter < 4 && (payCode.OvertimeAmount > 0 || payCode.YTDOvertime > 0))
						{
							if (payCode.PayCode.Id!=-1)
							{
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + otcounter + "-ot-1",
									payCode.PayCode.Description + " Overtime"));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ot-" + otcounter + "-1",
									payCode.OvertimeHours.ToString()));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("or-" + otcounter + "-1",
									(payCode.PayCode.HourlyRate * (decimal)1.5).ToString("C")));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("otam-" + otcounter + "-1",
									payCode.OvertimeAmount.ToString("c")));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdot-" + otcounter + "-1",
									payCode.YTDOvertime.ToString("c")));
							}
							else
							{
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + otcounter + "-ot-1",
									payCode.PayCode.Description + " 0.5 OT"));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ot-" + otcounter + "-1",
									payCode.OvertimeHours.ToString()));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("otam-" + otcounter + "-1",
									payCode.OvertimeAmount.ToString("c")));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdot-" + otcounter + "-1",
									payCode.YTDOvertime.ToString("c")));
							}


							otcounter++;
						}

					}
				}
				var compCounter1 = 1;
				foreach (var compensation in payCheck.Compensations.Where(compensation => compensation.Amount > 0 || compensation.YTD > 0))
				{
					if (payCheck.Employee.PayType == EmployeeType.PieceWork && (compensation.PayType.Id == 6 || compensation.PayType.Id == 13))
					{
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pcomp" + compCounter1 + "-1", string.Format("{0}{1}", compensation.PayType.Description, compensation.Hours>0? " - " + compensation.Hours.ToString() + " hrs" : string.Empty)));
					}
					else
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pcomp" + compCounter1 + "-1", compensation.PayType.Description));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compytd" + compCounter1 + "-1", compensation.YTD.ToString("C")));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compamt" + compCounter1 + "-1", compensation.Amount.ToString("C")));
					compCounter1++;
				}
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("11-1", payCheck.CompensationTaxableAmount.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("12-1", payCheck.CompensationTaxableYTD.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("15-2-1", payCheck.CompensationNonTaxableAmount.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("16-2-1", payCheck.CompensationNonTaxableYTD.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("15_1", payCheck.GrossWage.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("16_1", payCheck.YTDGrossWage.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("15-1-1", (payCheck.NetWage - payCheck.CompensationNonTaxableAmount).ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("16-1-1", (payCheck.YTDNetWage - payCheck.CompensationNonTaxableYTD).ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("15-3-1", payCheck.NetWage.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("16-3-1", payCheck.YTDNetWage.ToString("C")));


			}
			decimal prwytd = 0;
			if (payCheck.Employee.PayType == EmployeeType.Salary)
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr1-s", "Salary"));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("am-1", payCheck.Salary.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdam-1", payCheck.YTDSalary.ToString("C")));
			}
			else
			{
				var hrcounter = 1;
				var otcounter = 1;

				foreach (var payCode in payCheck.PayCodes.Where(p => p.Hours > 0 || p.OvertimeHours > 0 || p.YTD > 0 || p.YTDOvertime > 0)
					.OrderBy(p=>p.PayCode.Id)
					.ThenByDescending(p => p.Hours)
					.ThenByDescending(p => p.OvertimeHours)
					.ThenByDescending(p => p.YTD)
					.ThenByDescending(p => p.YTDOvertime).ToList())
				{
					prwytd += Math.Round(payCode.YTD + payCode.YTDOvertime - payCode.Amount - payCode.OvertimeAmount, 2,
						MidpointRounding.AwayFromZero);
					if (hrcounter < 4 && (payCode.Amount > 0 || payCode.YTD > 0))
					{
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + hrcounter + "-s", payCode.PayCode.Description));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("hr-" + hrcounter, payCode.Hours.ToString()));
						if(payCode.PayCode.Id!=-1)
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("r-" + hrcounter, payCode.PayCode.HourlyRate.ToString("C")));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("am-" + hrcounter, payCode.Amount.ToString("c")));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdam-" + hrcounter, payCode.YTD.ToString("C")));

						hrcounter++;
					}
					if (otcounter < 4 && (payCode.OvertimeAmount > 0 || payCode.YTDOvertime > 0))
					{

						if (payCode.PayCode.Id!=-1)
						{
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + otcounter + "-ot",
								payCode.PayCode.Description + " Overtime"));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ot-" + otcounter, payCode.OvertimeHours.ToString()));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("or-" + otcounter,
								(payCode.PayCode.HourlyRate * (decimal)1.5).ToString("C")));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("otam-" + otcounter,
								payCode.OvertimeAmount.ToString("c")));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdot-" + otcounter,
								payCode.YTDOvertime.ToString("c")));
						}
						else
						{
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + otcounter + "-ot",
								payCode.PayCode.Description + " 0.5 OT"));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ot-" + otcounter, payCode.OvertimeHours.ToString()));
							
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("otam-" + otcounter,
								payCode.OvertimeAmount.ToString("c")));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdot-" + otcounter,
								payCode.YTDOvertime.ToString("c")));
						}




						otcounter++;
					}

				}
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("prwytd", prwytd.ToString("C")));
				if (payCheck.Employee.PayType == EmployeeType.PieceWork)
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum3-1", !string.IsNullOrWhiteSpace(payCheck.Notes) ? payCheck.Notes : string.Empty));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum3", !string.IsNullOrWhiteSpace(payCheck.Notes) ? payCheck.Notes : string.Empty));
				}
			}

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum1", string.Format("Pay Period {0} - {1}", payCheck.StartDate.ToString("d"), payCheck.EndDate.ToString("d"))));
			var compCounter = 1;
			foreach (var compensation in payCheck.Compensations.Where(compensation => compensation.Amount > 0 || compensation.YTD > 0))
			{
				if (payCheck.Employee.PayType == EmployeeType.PieceWork && (compensation.PayType.Id == 6 || compensation.PayType.Id == 13))
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pcomp" + compCounter, string.Format("{0}{1}", compensation.PayType.Description, compensation.Hours>0? " - " + compensation.Hours.ToString() + " hrs" : string.Empty)));
				}
				else
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pcomp" + compCounter, compensation.PayType.Description));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compytd" + compCounter, compensation.YTD.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compamt" + compCounter, compensation.Amount.ToString("C")));
				compCounter++;
			}
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("11", payCheck.CompensationTaxableAmount.ToString("C")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("12", payCheck.CompensationTaxableYTD.ToString("C")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("15-2", payCheck.CompensationNonTaxableAmount.ToString("C")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("16-2", payCheck.CompensationNonTaxableYTD.ToString("C")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("15", payCheck.GrossWage.ToString("C")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("16", payCheck.YTDGrossWage.ToString("C")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("15-1", (payCheck.NetWage - payCheck.CompensationNonTaxableAmount).ToString("C")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("16-1", (payCheck.YTDNetWage - payCheck.CompensationNonTaxableYTD).ToString("C")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("15-3", payCheck.NetWage.ToString("C")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("16-3", payCheck.YTDNetWage.ToString("C")));

			var taxCounter = 17;
			foreach (var employeeTax in payCheck.Taxes.Where(t => t.IsEmployeeTax).OrderBy(t => t.Tax.Id))
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), employeeTax.Tax.Name));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), employeeTax.Amount.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter.ToString() + "-1", employeeTax.YTDWage.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), employeeTax.YTDTax.ToString("C")));

			}
			foreach (var ded in payCheck.Deductions)
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), ded.Deduction.Description));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), ded.Amount.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), ded.YTD.ToString("C")));
			}

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("95", (payCheck.EmployeeTaxes + payCheck.DeductionAmount).ToString("C")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("96", (payCheck.EmployeeTaxesYTD + payCheck.DeductionYTD).ToString("C")));

			if (payroll.Company.PayCheckStock == PayCheckStock.MICRQb)
			{
				taxCounter = 17;
				foreach (var employeeTax in payCheck.Taxes.Where(t => t.IsEmployeeTax).OrderBy(t => t.Tax.Id))
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString() + "-1", employeeTax.Tax.Name));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString() + "-1", employeeTax.Amount.ToString("C")));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter.ToString() + "-1-1", employeeTax.YTDWage.ToString("C")));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString() + "_1", employeeTax.YTDTax.ToString("C")));

				}
				foreach (var ded in payCheck.Deductions)
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString() + "-1", ded.Deduction.Description));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString() + "-1", ded.Amount.ToString("C")));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString() + "_1", ded.YTD.ToString("C")));
				}

				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("95-1", (payCheck.EmployeeTaxes + payCheck.DeductionAmount).ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("96_1", (payCheck.EmployeeTaxesYTD + payCheck.DeductionYTD).ToString("C")));

				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("prwytd-1", prwytd.ToString("C")));
			}

			if (payCheck.Accumulations.Any())
			{
				var scl = payCheck.Accumulations.First();
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("scltype", string.Format("{0} ({1} - {2})", scl.PayType.PayType.Description, scl.FiscalStart.ToString("d"), scl.FiscalEnd.ToString("d"))));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclhours-1", scl.Used.ToString()));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclcurrent-1", scl.AccumulatedValue.ToString()));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclytd-1", scl.YTDFiscal.ToString()));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclnet-1", scl.Available.ToString()));
			}
			return pdf;
		}

		private PDFModel GetPdfModelJobCost(Models.Payroll payroll, PayCheck payCheck, Journal journal, Company company,
			Company nameCompany, Company company1, Account bankcoa, DocumentDto signature)
		{
			var pdf = new PDFModel
				{
					Name = string.Format("Pay Check_{1}_{2} {0}.pdf", payCheck.PayDay.ToString("MMddyyyy"), payCheck.PayrollId, payCheck.Id),
					TargetId = payCheck.Id,
					NormalFontFields = new List<KeyValuePair<string, string>>(),
					BoldFontFields = new List<KeyValuePair<string, string>>(),
					TargetType = EntityTypeEnum.PayCheck,
					Template = PayCheckStock.JobCost.GetHrMaxxName(),
					DocumentId = journal.DocumentId
				};
				
				int jcCounter = 0;
				payCheck.PayCodes.Where(pc=>pc.PayCode.Id<=-2).ToList().ForEach(pc=>
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("jcr1-" + (jcCounter + 1), pc.PayCode.HourlyRate.ToString("c")));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("jcp1-" + (jcCounter + 1), pc.Hours.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("jcam1-" + (jcCounter + 1), pc.Amount.ToString("c")));
					jcCounter++;
				});
				
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Bank", bankcoa.BankAccount.BankName));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("BankfractionId", bankcoa.BankAccount.FractionId));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("comp", nameCompany.Name + Environment.NewLine + nameCompany.CompanyAddress.AddressLine1 + Environment.NewLine + company1.CompanyAddress.AddressLine2));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("ee", "Emp No" + Environment.NewLine + (payCheck.Employee.CompanyEmployeeNo.HasValue ? payCheck.Employee.CompanyEmployeeNo.Value.ToString() : string.Empty)));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("pp", "Period Begin                   Period End" + Environment.NewLine + payCheck.StartDate.ToString("MM/dd/yyyy") + "                     " + payCheck.EndDate.ToString("MM/dd/yyyy")));
				if (payCheck.Employee.PaymentMethod == EmployeePaymentMethod.DirectDebit)
					pdf.BoldFontFields.Add(new KeyValuePair<string, string>("dd-spec", "NON-NEGOTIABLE     DIRECT DEPOSIT"));
				else
				{
					pdf.BoldFontFields.Add(new KeyValuePair<string, string>("dd-spec", string.Empty));
				}
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("Name", company.Name));
				
				
				
				
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo1-1", payCheck.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : payCheck.CheckNumber.ToString()));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Address", nameCompany.CompanyAddress.AddressLine1));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("City", nameCompany.CompanyAddress.AddressLine2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName", payCheck.Employee.FullName));
				
				
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text1", payCheck.Employee.Contact.Address.AddressLine1));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text3", payCheck.Employee.Contact.Address.AddressLine2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date", payCheck.PayDay.ToString("MM/dd/yyyy")));
				var words = Utilities.NumberToWords(Math.Floor(payCheck.NetWage));
				var decPlaces = (int)(((decimal)payCheck.NetWage % 1) * 100);
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Amount", payCheck.NetWage.ToString("F")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("AmtInWords", string.Format("{0} {1}/100 {2}", words, decPlaces, string.Empty)));
				if (payCheck.PaymentMethod == EmployeePaymentMethod.Check)
				{
					var micr = "00000000";
					micr =
						micr.Substring(0,
							(8 - payCheck.CheckNumber.ToString().Length) < 0 ? 0 : 8 - payCheck.CheckNumber.ToString().Length) +
						payCheck.CheckNumber.ToString();
					var micrVal = string.Format("C{0}C A{1}A {2}C", micr, bankcoa.BankAccount.RoutingNumber,
						bankcoa.BankAccount.AccountNumber);
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("MICR", micrVal));


					
					if (signature!=null)
					{
						
						pdf.Signature = new PDFSignature
						{
							Path = _fileRepository.GetDocumentLocation(signature.Doc),
							X = 375,
							Y = 325,
							ScaleX = (float)0.7,
							ScaleY = (float)0.7

						};

					}
				}
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Memo", string.Format("Pay Period {0}-{1}", payCheck.StartDate.ToString("d"), payCheck.EndDate.ToString("d"))));

				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CompName", nameCompany.Name));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo-2", payCheck.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : payCheck.CheckNumber.ToString()));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("EmpNo", payCheck.Employee.CompanyEmployeeNo.HasValue ? payCheck.Employee.CompanyEmployeeNo.Value.ToString():string.Empty));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName2", payCheck.Employee.FullName));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("gross", payCheck.GrossWage.ToString("c")));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("startdate", payCheck.StartDate.ToString("MM/dd/yyyy")));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("enddate", payCheck.EndDate.ToString("MM/dd/yyyy")));


				var taxCounter = 17;
				foreach (var employeeTax in payCheck.Taxes.Where(t => t.IsEmployeeTax).OrderBy(t => t.Tax.Id))
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), employeeTax.Tax.Name));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), employeeTax.Amount.ToString("C")));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter.ToString() + "-1", employeeTax.YTDWage.ToString("C")));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), employeeTax.YTDTax.ToString("C")));

				}
				foreach (var ded in payCheck.Deductions)
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), ded.Deduction.Description));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), ded.Amount.ToString("C")));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter.ToString() + "-1", ded.YTDWage.ToString("C")));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>(taxCounter++.ToString(), ded.YTD.ToString("C")));
				}

				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("95", (payCheck.EmployeeTaxes + payCheck.DeductionAmount).ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("96", (payCheck.EmployeeTaxesYTD + payCheck.DeductionYTD).ToString("C")));
				

				var payrate = payCheck.Salary;
				
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("summary1", payrate.ToString("c")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("summary2", payCheck.GrossWage.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("summary3", (payCheck.EmployeeTaxes + payCheck.DeductionAmount).ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("summary4", payCheck.NetWage.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("summary5", payCheck.YTDGrossWage.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("summary6", (payCheck.EmployeeTaxesYTD + payCheck.DeductionYTD).ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("summary7", payCheck.YTDNetWage.ToString("C")));


				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr-s", "Salary/Job/Piece Total"));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("am", payCheck.GrossWage.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdam", payCheck.YTDGrossWage.ToString("C")));

				var hrcounter = 1;
				var otcounter = 1;
				foreach (var payCode in payCheck.PayCodes.Where(p => p.PayCode.Id == 0 && (p.Hours > 0 || p.OvertimeHours > 0 || p.YTD > 0 || p.YTDOvertime > 0)).OrderByDescending(p => p.Hours).ThenByDescending(p => p.OvertimeHours).ThenByDescending(p => p.YTD).ThenByDescending(p => p.YTDOvertime).ToList())
				{
					if (hrcounter < 4 && (payCode.Amount > 0 || payCode.YTD > 0))
					{
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + hrcounter + "-s", string.Format("Regular @ {0}", payCode.PayCode.HourlyRate.ToString("c"))));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("hr-" + hrcounter, payCode.Hours.ToString()));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("r-" + hrcounter,
							payCode.PayCode.HourlyRate.ToString("C")));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("am-" + hrcounter, payCode.Amount.ToString("c")));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdam-" + hrcounter, payCode.YTD.ToString("C")));

						hrcounter++;
					}
					if (otcounter < 4 && (payCode.OvertimeAmount > 0 || payCode.YTDOvertime > 0))
					{
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + otcounter + "-ot",
							string.Format("0.5 OT @ {0}", (payCode.PayCode.HourlyRate * (decimal)0.5).ToString("c"))));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ot-" + otcounter,
							payCode.OvertimeHours.ToString()));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("or-" + otcounter,
							(payCode.PayCode.HourlyRate * (decimal)0.5).ToString("C")));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("otam-" + otcounter,
							payCode.OvertimeAmount.ToString("c")));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdot-" + otcounter,
							payCode.YTDOvertime.ToString("c")));

						otcounter++;
					}

				}
				
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pcomp6", "Sick Leave Pay"));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compamount6", payCheck.Compensations.Where(c=>c.PayType.Id==6).Sum(c=>c.Amount).ToString("c")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compytd6", payCheck.Compensations.Where(c => c.PayType.Id == 6).Sum(c => c.YTD).ToString("c")));
				
				if (payCheck.Accumulations.Any())
				{
					var scl = payCheck.Accumulations.First();
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("scltype", string.Format("{0} ({1} - {2})", scl.PayType.PayType.Description, scl.FiscalStart.ToString("d"), scl.FiscalEnd.ToString("d"))));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclhours-1", scl.YTDUsed.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclcurrent-1", scl.AccumulatedValue.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclytd-1", scl.YTDFiscal.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclnet-1", scl.Available.ToString()));
				}

				
				var compCounter = 1;
				foreach (var compensation in payCheck.Compensations.Where(compensation => compensation.Amount > 0 || compensation.YTD > 0))
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pcomp" + compCounter, compensation.PayType.Description));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compytd" + compCounter, compensation.YTD.ToString("C")));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compamt" + compCounter, compensation.Amount.ToString("C")));
					compCounter++;
				}
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("15-3", payCheck.GrossWage.ToString("C")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("16-3", payCheck.YTDGrossWage.ToString("C")));
			return pdf;
		}
		private FileDto PrintPayCheck(Models.Payroll payroll, List<PayCheck> payChecks, List<Journal> journals)
		{
			try
			{
				
				var host = _hostService.GetHost(payroll.Company.HostId);
				var company1 = _readerService.GetCompany(payroll.Company.Id);
				var coas = new List<Account>();
				if(payroll.PEOASOCoCheck)
					coas = _companyService.GetComanyAccounts(host.Company.Id);
				else
					coas = _companyService.GetComanyAccounts(payroll.Company.Id);

				var company = payroll.Company;
				if (payroll.PEOASOCoCheck)
					company = host.Company;

				var nameCompany = payroll.Company.Contract.InvoiceSetup.PrintClientName ? payroll.Company : company;

				var bankcoa = coas.First(c => c.Id == journals.First().MainAccountId);
				var companyDocs = _commonService.GetRelatedEntities<DocumentDto>(EntityTypeEnum.Company, EntityTypeEnum.Document,
						company.Id);
				var signature = companyDocs.Where(d => d.DocumentType == DocumentType.Signature).OrderByDescending(d => d.LastModified).FirstOrDefault();
				var pdfs = new List<PDFModel>();
				foreach (var payCheck in payChecks.OrderBy(pc=>pc.CheckNumber))
				{
					if(payCheck.Employee.PayType==EmployeeType.JobCost)
						pdfs.Add(GetPdfModelJobCost(payroll, payCheck, journals.First(j=>j.PayrollPayCheckId==payCheck.Id), company, nameCompany, company1, bankcoa, signature));
					else
					{
						pdfs.Add(GetPdfModel(payroll, payCheck, journals.First(j => j.PayrollPayCheckId == payCheck.Id), company, nameCompany, company1, bankcoa, signature));
					}
					
				}
				var fileName = payChecks.Count == 1
					? string.Format("Pay Check {0}", payChecks.First().CheckNumber)
					: string.Format("Payroll_{0}_{1}_{2}", payroll.StartDate.ToString("MMddyyyy"), payroll.EndDate.ToString("MMddyyyy"),
						payroll.Id);
				
				return _pdfService.Print(fileName, pdfs);	
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Print Pay Check By id=" + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		
		private Journal CreateJournalEntry(Company company, PayCheck pc, List<Account> coaList, string userName, bool PEOASOCoCheck = false, Guid? companyId = null)
		{
			var bankCOA = coaList.First(c => c.UseInPayroll);
			var journal = new Journal
			{
				Id = 0,
				CompanyId = companyId.HasValue ? companyId.Value : pc.Employee.CompanyId,
				Amount = Math.Round(pc.NetWage, 2, MidpointRounding.AwayFromZero),
				CheckNumber = pc.PaymentMethod == EmployeePaymentMethod.Check ? pc.CheckNumber.Value : -1,
				EntityType = EntityTypeEnum.Employee,
				PayeeId = pc.Employee.Id,
				IsDebit = true,
				IsVoid = false,
				LastModified = DateTime.Now,
				LastModifiedBy = userName,
				Memo = string.Format("Pay Period {0} - {1}", pc.StartDate.ToString("d"), pc.EndDate.ToString("d")),
				PaymentMethod = pc.PaymentMethod,
				PayrollPayCheckId = pc.Id,
				TransactionDate = pc.PayDay,
				TransactionType = TransactionType.PayCheck,
				PayeeName = pc.Employee.FullName,
				MainAccountId = bankCOA.Id,
				JournalDetails = new List<JournalDetail>(),
				DocumentId =  CombGuid.Generate(),
				PEOASOCoCheck = PEOASOCoCheck
			};
			//bank account debit
			

			journal.JournalDetails.Add(new JournalDetail{ AccountId = bankCOA.Id, AccountName= bankCOA.AccountName, IsDebit = true, Amount = pc.NetWage, LastModfied = journal.LastModified, LastModifiedBy = userName});
			journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "PAYROLL_EXPENSES").Id, AccountName = coaList.First(c => c.TaxCode == "PAYROLL_EXPENSES").AccountName, IsDebit = false, Amount = pc.NetWage, LastModfied = journal.LastModified, LastModifiedBy = userName });
			pc.Taxes.ForEach(t => journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == t.Tax.Code).Id, AccountName = coaList.First(c => c.TaxCode == t.Tax.Code).AccountName, IsDebit = false, Amount = t.Amount, LastModifiedBy = userName, LastModfied = journal.LastModified }));
			if(pc.CompensationNonTaxableAmount>0)
				journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "MOE").Id, AccountName = coaList.First(c => c.TaxCode == "MOE").AccountName, IsDebit = false, Amount = pc.CompensationNonTaxableAmount, LastModfied = journal.LastModified, LastModifiedBy = userName });
			if (pc.DeductionAmount > 0)
			{
				journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "ED").Id, AccountName = coaList.First(c => c.TaxCode == "ED").AccountName, IsDebit = false, Amount = pc.DeductionAmount, LastModfied = journal.LastModified, LastModifiedBy = userName });
				journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "PD").Id, AccountName = coaList.First(c => c.TaxCode == "PD").AccountName, IsDebit = false, Amount = pc.DeductionAmount, LastModfied = journal.LastModified, LastModifiedBy = userName });
			}
			journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "TP").Id, AccountName = coaList.First(c => c.TaxCode == "TP").AccountName, IsDebit = false, Amount = Math.Round(pc.EmployeeTaxes + pc.EmployerTaxes, 2, MidpointRounding.AwayFromZero), LastModfied = journal.LastModified, LastModifiedBy = userName });
			return _journalService.SaveJournalForPayroll(journal, company);
		}

		private List<PayrollPayType> ProcessCompensations(List<PayrollPayType> compensations, Accumulation employeeAccumulation)
		{
			var previousComps = employeeAccumulation.Compensations ?? new List<PayCheckCompensation>();
			compensations.ForEach(c =>
			{
				c.Amount = Math.Round(c.Amount, 2, MidpointRounding.AwayFromZero);
				c.YTD = Math.Round(previousComps.Where(ppc => c.PayType.Id == ppc.PayTypeId).Sum(ppc => ppc.YTD) + c.Amount, 2, MidpointRounding.AwayFromZero);
			});
			return compensations;
		} 
		private List<PayrollPayCode> ProcessPayCodes(List<PayrollPayCode> payCodes, PayCheck paycheck, Accumulation employeeAccumulation)
		{
			var previousPayCodes = employeeAccumulation.PayCodes;
			if ( paycheck.Employee.PayType == EmployeeType.Hourly)
			{
				const decimal overtimequotiant = (decimal) 1.5;
				
				
				payCodes.ForEach(pc =>
				{
					pc.Amount = Math.Round(pc.Hours*pc.PayCode.HourlyRate, 2, MidpointRounding.AwayFromZero);
					pc.OvertimeAmount = Math.Round(pc.OvertimeHours*pc.PayCode.HourlyRate*overtimequotiant, 2,
						MidpointRounding.AwayFromZero);
					pc.YTD =
						Math.Round(previousPayCodes.Where(ppc => ppc.PayCodeId == pc.PayCode.Id).Sum(ppc => ppc.YTDAmount) + pc.Amount, 2,
							MidpointRounding.AwayFromZero);
					pc.YTDOvertime =
						Math.Round(
							previousPayCodes.Where(ppc => ppc.PayCodeId == pc.PayCode.Id).Sum(ppc => ppc.YTDOvertime) + pc.OvertimeAmount,
							2, MidpointRounding.AwayFromZero);
				});
			}
			else if (paycheck.Employee.PayType == EmployeeType.Salary)
			{
				payCodes = new List<PayrollPayCode>();
			}
			else if (paycheck.Employee.PayType == EmployeeType.PieceWork)
			{
				const decimal overtimequotiantForPieceWork = (decimal)0.5;
				
				payCodes.Where(pc=>pc.PayCode.Id==-1).ToList().ForEach(pc =>
				{
					pc.Amount = pc.PWAmount;
					pc.OvertimeAmount = Math.Round(pc.OvertimeHours * pc.PayCode.HourlyRate * overtimequotiantForPieceWork, 2,
						MidpointRounding.AwayFromZero);
					pc.YTD =
						Math.Round(previousPayCodes.Where(ppc => ppc.PayCodeId == pc.PayCode.Id).Sum(ppc => ppc.YTDAmount) + pc.Amount, 2,
							MidpointRounding.AwayFromZero);
					pc.YTDOvertime =
						Math.Round(
							previousPayCodes.Where(ppc => ppc.PayCodeId == pc.PayCode.Id).Sum(ppc => ppc.YTDOvertime) + pc.OvertimeAmount,
							2, MidpointRounding.AwayFromZero);
				});
			}
			else
			{
				payCodes.ForEach(pc =>
				{
					pc.YTD = Math.Round(previousPayCodes.Where(ppc => ppc.PayCodeId == pc.PayCode.Id).Sum(ppc => ppc.YTDAmount) + pc.Amount, 2, MidpointRounding.AwayFromZero);
					pc.YTDOvertime = Math.Round(previousPayCodes.Where(ppc => ppc.PayCodeId == pc.PayCode.Id).Sum(ppc => ppc.YTDOvertime) + pc.OvertimeAmount, 2, MidpointRounding.AwayFromZero);
				});
			}
			
			return payCodes;
		}
		private decimal GetGrossWage(PayCheck paycheck)
		{
			
			if (paycheck.Employee.PayType == EmployeeType.Salary || paycheck.Employee.PayType == EmployeeType.JobCost)
				return Math.Round(paycheck.Salary, 2);
			else
			{
				return Math.Round(paycheck.PayCodes.Sum(pc => (pc.Amount + pc.OvertimeAmount)), 2, MidpointRounding.AwayFromZero);
			}
		}

		private List<PayrollDeduction> ApplyDeductions(decimal grossWage, PayCheck payCheck, Accumulation employeeAccumulation)
		{
			employeeAccumulation.Deductions = employeeAccumulation.Deductions ?? new List<PayCheckDeduction>();
			var localGrossWage = grossWage;
			var eeApplied = false;
			payCheck.Deductions.OrderBy(d=>d.Deduction.Type.Category.GetDbId()).ThenBy(d=>d.EmployeeDeduction.Priority.HasValue? d.EmployeeDeduction.Priority.Value : int.MaxValue).ThenBy(d=>d.Deduction.Type.Id).ToList().ForEach(d =>
			{
				if ((d.Deduction.Type.Category == DeductionCategory.Other ||
				    d.Deduction.Type.Category == DeductionCategory.PostTaxDeduction) && !eeApplied)
				{
					localGrossWage -= payCheck.EmployeeTaxes;
					eeApplied = true;
				}
				d.Amount = 0;
				
				if ((d.Deduction.FloorPerCheck.HasValue && localGrossWage >= d.Deduction.FloorPerCheck) ||
				    !d.Deduction.FloorPerCheck.HasValue)
				{
					if (d.Method == DeductionMethod.Amount)
						d.Amount = d.Rate;
					else
						d.Amount = localGrossWage*d.Rate/100;
					d.Amount = d.Amount > localGrossWage ? localGrossWage : d.Amount;

					if (d.EmployeeDeduction.CeilingPerCheck.HasValue && d.Amount > (d.EmployeeDeduction.CeilingMethod==2 ? d.EmployeeDeduction.CeilingPerCheck.Value : (d.EmployeeDeduction.CeilingPerCheck*localGrossWage/100) ) )
					{
						d.Amount = d.EmployeeDeduction.CeilingPerCheck.Value;
					}
					if (d.EmployeeDeduction.Limit.HasValue)
					{
						//var allPayChecks = _payrollRepository.GetEmployeePayChecks(payCheck.Employee.Id);
						var allPayChecks = _readerService.GetPayChecks(employeeId: payCheck.Employee.Id);
						var total =
							allPayChecks.Where(pc => pc.Deductions.Any(d1 => d1.EmployeeDeduction.Id == d.EmployeeDeduction.Id))
								.Sum(pc => pc.Deductions.Where(d1 => d1.EmployeeDeduction.Id == d.EmployeeDeduction.Id).Sum(d2 => d2.Amount));
						if (total + d.Amount > d.EmployeeDeduction.Limit.Value)
						{
							d.Amount = Math.Max(0, d.EmployeeDeduction.Limit.Value - total);
						}
							
					}
				}



				var ytdVal = employeeAccumulation.Deductions.Where(d1 => d1.CompanyDeductionId == d.Deduction.Id).Sum(d1 => d1.YTD);
				var ytdWage = employeeAccumulation.Deductions.Where(d1 => d1.CompanyDeductionId == d.Deduction.Id).Sum(d1 => d1.YTDWage);
				if (d.AnnualMax.HasValue)
				{
					if (ytdVal + d.Amount > d.AnnualMax.Value)
						d.Amount = Math.Max(0, d.AnnualMax.Value - d.Amount);
				}
				
				if (d.Amount < 0)
					d.Amount = 0;
				d.Wage = Math.Round(localGrossWage, 2, MidpointRounding.AwayFromZero);
				d.Amount = Math.Round(d.Amount, 2, MidpointRounding.AwayFromZero);
				d.YTD = Math.Round(ytdVal + d.Amount, 2, MidpointRounding.AwayFromZero);
				d.YTDWage = Math.Round(ytdWage + d.Wage, 2, MidpointRounding.AwayFromZero);
				
				localGrossWage -= d.Amount;
			});
			return payCheck.Deductions;
		}
		
		public PayrollInvoice DelayTaxes(Guid invoiceId, string fullName)
		{
			try
			{
				var invoice = _readerService.GetPayrollInvoice(invoiceId);
				invoice.Status = InvoiceStatus.OnHold;
				invoice.LastModified = DateTime.Now;
				invoice.UserName = fullName;
				var saved = _payrollRepository.SavePayrollInvoice(invoice);
				_commonService.AddToList(EntityTypeEnum.Company, EntityTypeEnum.Comment, saved.CompanyId, new Comment
				{
					Content = string.Format("Invoice #{0} has been marked as Taxes Delayed", invoice.InvoiceNumber), LastModified = saved.LastModified, UserName = fullName, TimeStamp = DateTime.Now
				});
				return saved;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Delay Taxes on invoice id=" + invoiceId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public PayrollInvoice RedateInvoice(PayrollInvoice invoice)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					if (invoice.Balance == 0)
						invoice.Status = InvoiceStatus.Paid;
					else if (invoice.Balance <= invoice.Total)
					{
						if (invoice.InvoicePayments.Any(p => p.Status == PaymentStatus.PaymentBounced))
							invoice.Status = InvoiceStatus.PaymentBounced;
						else if (invoice.InvoicePayments.Any(p => p.Status == PaymentStatus.Submitted))
						{
							var totalPayments = invoice.InvoicePayments.Where(p => p.Status != PaymentStatus.PaymentBounced).Sum(p => p.Amount);
									if (totalPayments < invoice.Total)
									{
										invoice.Status = InvoiceStatus.NotDeposited;
									}
									else
									{
										invoice.Status = InvoiceStatus.Deposited;	
									}
						}
						else if (invoice.InvoicePayments.Any())
						{
							invoice.Status = InvoiceStatus.PartialPayment;
						}
						else
						{
							invoice.Status = InvoiceStatus.Delivered;

						}
					}
					
					invoice.LastModified = DateTime.Now;
				
					var saved = _payrollRepository.SavePayrollInvoice(invoice);
					_commonService.AddToList(EntityTypeEnum.Company, EntityTypeEnum.Comment, saved.CompanyId, new Comment
					{
						Content = string.Format("Invoice #{1} and related Payroll and Paychecks have been re-dated to {0}", invoice.InvoiceDate.ToString("MM/dd/yyyy"), invoice.InvoiceNumber),
						LastModified = saved.LastModified,
						UserName = invoice.UserName,
						TimeStamp = DateTime.Now
					});
					//var payroll = _readerService.GetPayroll(invoice.PayrollId);
					////var companyPayChecks = _payrollRepository.GetPayChecksTillPayDay(invoice.CompanyId, invoice.InvoiceDate);
					//var companyPayChecks = _readerService.GetPayChecks(companyId: invoice.CompanyId, endDate: invoice.InvoiceDate, isvoid:0);
					//var affectedChecks = new List<PayCheck>();
					//foreach (var payCheck in payroll.PayChecks)
					//{
					//	var employeeInBetweenChecks = companyPayChecks.Where(p => p.Employee.Id == payCheck.Employee.Id 
					//		&& p.PayDay>payCheck.PayDay && p.PayDay<=invoice.InvoiceDate).ToList();
					//	foreach (var pc1 in employeeInBetweenChecks)
					//	{
					//		pc1.SubtractFromYTD(payCheck);
					//		payCheck.AddToYTD(pc1);
					//		_payrollRepository.UpdatePayCheckYTD(payCheck);
					//		_payrollRepository.UpdatePayCheckYTD(pc1);
					//		affectedChecks.Add(pc1);
					//		affectedChecks.Add(payCheck);
					//	}
					//}
					_payrollRepository.UpdatePayrollPayDay(invoice.PayrollId, invoice.PayChecks, invoice.InvoiceDate);
					txn.Complete();
					
					return saved;
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Delay Taxes on invoice id=" + invoice.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}


		public Company Copy(Guid companyId, Guid hostId, bool copyEmployees, bool copyPayrolls, DateTime? startDate, DateTime? endDate, string fullName, Guid userId)
		{
			try
			{
				var company = _readerService.GetCompany(companyId);
				company.Id = CombGuid.Generate();

				using (var txn = TransactionScopeHelper.Transaction())
				{
					var saved = _companyRepository.CopyCompany(companyId, company.Id, company.HostId, hostId, copyEmployees, copyPayrolls, startDate, endDate, fullName);
					if (copyEmployees)
					{
						var employees = _readerService.GetEmployees(company:company.Id);
						employees.Where(e=>e.PayCodes.Any()).ToList().ForEach(e =>
						{
							e.PayCodes.ForEach(pc =>
							{
								if(pc.Id>0)
									pc.Id = saved.PayCodes.First(pc1 => pc1.Code.Equals(pc.Code)).Id;
								pc.CompanyId = saved.Id;
							});
							_companyService.SaveEmployee(e, false);
							
						});
						if (copyPayrolls)
							MigratePayrolls(companyId, saved, employees, startDate, endDate, userId);
					}
					_commonService.AddToList(EntityTypeEnum.Company, EntityTypeEnum.Comment, saved.Id, new Comment
					{
						Content =
							string.Format("Company {0} copied from another host with Copy Employees={1}, Copy Payrolls={2}", saved.Name,
								copyEmployees ? "Yes" : "No", copyPayrolls ? "Yes" : "No"),
						LastModified = DateTime.Now,
						UserName = fullName
					});
					_commonService.AddToList(EntityTypeEnum.Company, EntityTypeEnum.Comment, saved.Id, new Comment
					{
						Content =
							string.Format("Company {0} copied to another host with Copy Employees={1}, Copy Payrolls={2}", company.Name,
								copyEmployees ? "Yes" : "No", copyPayrolls ? "Yes" : "No"),
						LastModified = DateTime.Now,
						UserName = fullName
					});
					txn.Complete();
					Bus.Publish<CompanyUpdatedEvent>(new CompanyUpdatedEvent
					{
						SavedObject = saved,
						UserId = userId,
						TimeStamp = DateTime.Now,
						NotificationText = string.Format("{0} by {1}", string.Format("Company {0} has been copied", saved.Name), fullName),
						EventType = NotificationTypeEnum.Created
					});
				}
				return company;
			}
			catch (Exception e)
			{
				var message = e.Message;
				if (e.Message.ToLower().StartsWith("subquery"))
					message = "An unexpected error occurred caused by the company data. Please contact your administrator.";
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		public void UpdatePayrollDates(Models.Payroll mappedResource)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_payrollRepository.UpdatePayrollDates(mappedResource);
					txn.Complete();
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " update payroll dates for id = " + mappedResource.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SavePayCheckPayTypeAccumulations(List<PayCheckPayTypeAccumulation> ptaccums)
		{
			try
			{
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					_payrollRepository.SavePayCheckPayTypeAccumulations(ptaccums);
					txn.Complete();
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " update pay check normalized accumulations");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SavePayCheckTaxes(List<PayCheckTax> pttaxes)
		{
			try
			{
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					_payrollRepository.SavePayCheckTaxes(pttaxes);
					txn.Complete();
				}

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " update pay check normalized taxes");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SavePayCheckCompensations(List<PayCheckCompensation> ptcomps)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_payrollRepository.SavePayCheckCompensations(ptcomps);
					txn.Complete();
				}

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " update pay check normalized compensations");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SavePayCheckDeductions(List<PayCheckDeduction> ptdeds)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_payrollRepository.SavePayCheckDeductions(ptdeds);
					txn.Complete();
				}

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " update pay check normalized deductions");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SavePayCheckPayCodes(List<PayCheckPayCode> ptcodes)
		{
			try
			{
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					_payrollRepository.SavePayCheckPayCodes(ptcodes);
					txn.Complete();
				}

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " update pay check normalized pay codes");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SavePayCheckWorkerCompensation(List<PayCheckWorkerCompensation> ptwcs)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_payrollRepository.SavePayCheckWorkerCompensations(ptwcs);
					txn.Complete();
				}

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " update pay check normalized worker comps");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void ReIssuePayCheck(int payCheckId)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_payrollRepository.ReIssueCheck(payCheckId);
					txn.Complete();
					
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " update pay check normalized worker comps");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void UpdatePayCheckAccumulation(int payCheckId, PayTypeAccumulation accumulation, string user, string userId)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var payCheck = _readerService.GetPaycheck(payCheckId);
					payCheck.Accumulations.RemoveAll(a => a.PayType.PayType.Id == accumulation.PayType.PayType.Id);
					payCheck.Accumulations.Add(accumulation);
					_payrollRepository.UpdatePayCheckSickLeaveAccumulation(payCheck);
					var memento = Memento<PayCheck>.Create(payCheck, EntityTypeEnum.PayCheck, user, "Pay Type Accumulation Updated", new Guid(userId));
					_mementoDataService.AddMementoData(memento);
					txn.Complete();
					
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " update pay check accumulation");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public InvoiceDeliveryClaim ClaimDelivery(List<Guid> invoiceIds, string fullName, Guid userId)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var invoices = _payrollRepository.ClaimDelivery(invoiceIds, fullName);
					var invoiceDeliveryClaim = new InvoiceDeliveryClaim
					{
						Id = 0,
						UserName = fullName,
						UserId = userId,
						DeliveryClaimedOn = DateTime.Now,
						Invoices = invoices
					};
					_payrollRepository.SaveInvoiceDeliveryClaim(invoiceDeliveryClaim);
					if(invoices.Any())
						txn.Complete();
					else
					{
						throw new Exception();
					}
					return invoiceDeliveryClaim;
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " claim delivery for invoices " + invoiceIds);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Models.Payroll SaveProcessedPayroll(Models.Payroll payroll)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_stagingDataService.DeleteStagingData<PayrollStaging>(payroll.Company.Id);
					payroll.Status = PayrollStatus.Draft;
					var payrollStaging = new PayrollStaging
					{
						Payroll = payroll,
						CompanyId = payroll.Company.Id
					};
					var memento = Memento<PayrollStaging>.Create(payrollStaging, EntityTypeEnum.Payroll, payroll.UserName, "Payroll saved to staging", payroll.UserId);
					_stagingDataService.AddStagingData(memento);
					
					txn.Complete();
				}
				return payroll;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " save payroll to staging " + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Models.Payroll DeletePayroll(Models.Payroll payroll)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_stagingDataService.DeleteStagingData<PayrollStaging>(payroll.Company.Id);
					txn.Complete();
				}
				return payroll;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " delete draft payroll from staging " + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims()
		{
			try
			{
				return _payrollRepository.GetInvoiceDeliveryClaims();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " get invoice delivery claims " );
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<Guid> FixInvoiceData()
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var payrolls = _readerService.GetPayrolls(null);
					var invoices = _readerService.GetPayrollInvoices(Guid.Empty);
					var paychecks = payrolls.SelectMany(p => p.PayChecks);
					var newpayments = invoices.SelectMany(i => i.InvoicePayments).ToList();
					var invoiceList = new List<Guid>();
					invoices.OrderBy(i => i.PayrollPayDay).ToList().ForEach(i =>
					{
						var payroll = payrolls.First(p => p.Id == i.PayrollId);
						if (payroll.PayChecks.Any(pc => !pc.IsVoid && pc.Deductions.Any(pcd => !i.Deductions.Any(icd=>icd.Deduction.Id==pcd.Deduction.Id))))
						{
							invoiceList.Add(i.Id);
							//i.Deductions = new List<PayrollDeduction>();
							payroll.PayChecks.Where(pc => !pc.IsVoid && pc.Deductions.Any(pcd => !i.Deductions.Any(icd => icd.Deduction.Id == pcd.Deduction.Id))).ToList().ForEach(pc =>
							{
								pc.Deductions.Where(pcd=>!i.Deductions.Any(icd=>icd.Deduction.Id==pcd.Deduction.Id)).ToList().ForEach(d =>
								{
									var d1 = i.Deductions.FirstOrDefault(ded => ded.Deduction.Id == d.Deduction.Id);
									if (d1 != null)
									{
										d1.Amount += Math.Round(d.Amount, 2, MidpointRounding.AwayFromZero);
									}
									else
									{
										var temp = JsonConvert.SerializeObject(d);
										i.Deductions.Add(JsonConvert.DeserializeObject<PayrollDeduction>(temp));
									}
								});
							});

						}
						//var prevInvoices =
						//	invoices.Where(i1 => i1.CompanyId == i.CompanyId && i1.InvoiceNumber < i.InvoiceNumber).ToList();
						//var pcs = paychecks.Where(pc => i.PayChecks.Contains(pc.Id)).ToList();
						//i.NetPay = pcs.Sum(p => p.NetWage);
						//i.CheckPay = pcs.Sum(p => p.CheckPay);
						//i.DDPay = pcs.Sum(p => p.DDPay);
						//i.MiscCharges.Where(mc => mc.RecurringChargeId > 0).ToList().ForEach(mc =>
						//{
						//	var rc = i.CompanyInvoiceSetup.RecurringCharges.First(r => r.Id == mc.RecurringChargeId);
						//	if (!rc.Year.HasValue)
						//	{
						//		mc.PreviouslyClaimed = prevInvoices.SelectMany(i2 => i2.MiscCharges).Where(mc1 => mc1.RecurringChargeId == rc.Id).Sum(mc1 => mc.Amount);
						//	}
						//	else
						//	{
						//		mc.PreviouslyClaimed = prevInvoices.Where(i2 => i2.PayrollPayDay.Year == i.PayrollPayDay.Year).SelectMany(i2 => i2.MiscCharges).Where(mc1 => mc1.RecurringChargeId == rc.Id).Sum(mc1 => mc1.Amount);
						//	}
						//});
						//i.Deductions = new List<PayrollDeduction>();
						//payroll.PayChecks.Where(pc => !pc.IsVoid).ToList().ForEach(pc =>
						//{
						//	pc.Deductions.ToList().ForEach(d =>
						//	{
						//		var d1 = i.Deductions.FirstOrDefault(ded => ded.Deduction.Id == d.Deduction.Id);
						//		if (d1 != null)
						//		{
						//			d1.Amount += Math.Round(d.Amount, 2, MidpointRounding.AwayFromZero);
						//		}
						//		else
						//		{
						//			var temp = JsonConvert.SerializeObject(d);
						//			i.Deductions.Add(JsonConvert.DeserializeObject<PayrollDeduction>(temp));
						//		}
						//	});
						//});
						
						_payrollRepository.SavePayrollInvoice(i);
					});
					txn.Complete();
					return invoiceList;
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " fix invoice data ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private void MigratePayrolls(Guid oldCompanyId, Company company, List<Employee> employees, DateTime? startDate, DateTime? endDate, Guid userId)
		{
			try
			{
				var payrolls = _readerService.GetPayrolls(oldCompanyId, startDate, endDate);
				payrolls.OrderBy(p=>p.LastModified).ToList().ForEach(payroll =>
				{
					var original = Utilities.GetCopy(payroll);
					payroll.Company = company;
					payroll.Id = CombGuid.Generate();
					payroll.PayChecks.ForEach(paycheck =>
					{
						paycheck.Id = 0;
						paycheck.Employee = employees.First(e => e.SSN.Equals(paycheck.Employee.SSN));
						paycheck.PayCodes.ForEach(pc =>
						{
							var hourlyrate = pc.PayCode.HourlyRate;
							pc.PayCode = paycheck.Employee.PayCodes.First(pc1 => pc1.Code.Equals(pc.PayCode.Code));
							pc.PayCode.HourlyRate = hourlyrate;
						});
						paycheck.Deductions.ForEach(ded =>
						{
							ded.Deduction =
								company.Deductions.First(
									d => d.Type.Id == ded.Deduction.Type.Id && d.DeductionName.Equals(ded.Deduction.DeductionName));
							
						});
						if(paycheck.WorkerCompensation!=null)
							paycheck.WorkerCompensation.WorkerCompensation =
								company.WorkerCompensations.First(wc => wc.Code.Equals(paycheck.WorkerCompensation.WorkerCompensation.Code));
					}
					);
					var processed = ProcessPayroll(payroll);
					var confirmed = ConfirmPayrollForMigration(processed);
					original.PayChecks.Where(pc=>pc.IsVoid).ToList().ForEach(pc =>
					{
						var newone = confirmed.PayChecks.First(pc1 => pc1.Employee.SSN.Equals(pc.Employee.SSN));
						VoidPayCheckForMigration(confirmed.Id, newone.Id, pc.LastModifiedBy,userId);
					});
					//if (confirmed.Invoice != null)
					//{
					//	if (payroll.Invoice != null)
					//	{
					//		var oldInvoice = Utilities.GetCopy(payroll.Invoice);
					//		var invoice = confirmed.Invoice;
					//		invoice.InvoiceDate = oldInvoice.InvoiceDate;
					//		invoice.InvoiceNumber = oldInvoice.InvoiceNumber;
					//		invoice.MiscCharges = oldInvoice.MiscCharges;
					//		invoice.ApplyWCMinWageLimit = oldInvoice.ApplyWCMinWageLimit;
					//		invoice.CompanyInvoiceSetup = oldInvoice.CompanyInvoiceSetup;
					//		invoice.VoidedCreditedChecks = oldInvoice.VoidedCreditedChecks;
					//		invoice.CalculateTotal();
					//		invoice.Payments = oldInvoice.Payments;
					//		invoice.Status = oldInvoice.Status;
					//		invoice.SubmittedBy = oldInvoice.SubmittedBy;
					//		invoice.SubmittedOn = oldInvoice.SubmittedOn;
					//		invoice.DeliveredBy = oldInvoice.DeliveredBy;
					//		invoice.DeliveredOn = oldInvoice.DeliveredOn;
					//		invoice.Courier = oldInvoice.Courier;
					//		invoice.Deductions = oldInvoice.Deductions;
					//		invoice.ProcessedBy = oldInvoice.ProcessedBy;
					//		invoice.Notes = oldInvoice.Notes;
					//		SavePayrollInvoiceForMigration(invoice);
					//	}
					//	else
					//	{
					//		DeletePayrollInvoice(confirmed.Invoice.Id);
					//	}
						
					//}
					
				});
			}
			catch (Exception e)
			{
				var message = string.Format("Failed to migrate payrolls during copy. Please make sure that the target host is set up with COA and a payroll bank account.");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void MovePayrolls(Guid source, Guid target, Guid userId, string user)
		{
			try
			{

				try
				{
					_companyService.CopyEmployees(source, target, new List<Guid>(), user);
				}
				catch (Exception)
				{
					
				}
				
				var sourceCompany = _readerService.GetCompany(source);
				var targetCompany = _readerService.GetCompany(target);
				var sourceHost = _hostService.GetHost(sourceCompany.HostId);
				var targetHost = _hostService.GetHost(targetCompany.HostId);
				var sourceEmployees = _readerService.GetEmployees(company:source);
				var targetEmployees = _readerService.GetEmployees(company:target);
				var payrolls = _readerService.GetPayrolls(companyId:source);
				var sourceCOA = _companyRepository.GetCompanyAccounts(source);
				var targetCOA = _companyRepository.GetCompanyAccounts(target);
				var sourceHostCOA = _companyRepository.GetCompanyAccounts(sourceHost.Company.Id);
				var targetHostCOA = _companyRepository.GetCompanyAccounts(targetHost.Company.Id);
				var affectedJournals = new List<Journal>();
				
				payrolls.OrderBy(p => p.LastModified).ToList().ForEach(payroll =>
				{
					var original = Utilities.GetCopy(payroll);
					payroll.MovedFrom = source;
					payroll.Company = targetCompany;
					payroll.PayChecks.ForEach(paycheck =>
						{
							paycheck.Employee = targetEmployees.First(e => e.SSN.Equals(paycheck.Employee.SSN));
							paycheck.PayCodes.ForEach(pc =>
							{
								var hourlyrate = pc.PayCode.HourlyRate;
								pc.PayCode.CompanyId = target;
								pc.PayCode.HourlyRate = hourlyrate;
							});
							paycheck.Deductions.ForEach(ded =>
							{
								ded.Deduction =
									targetCompany.Deductions.First(
										d => d.Type.Id == ded.Deduction.Type.Id && d.DeductionName.Equals(ded.Deduction.DeductionName));
								ded.EmployeeDeduction = paycheck.Employee.Deductions.First(d1 => d1.Deduction.Id == ded.Deduction.Id);

							});
							if (paycheck.WorkerCompensation != null)
								paycheck.WorkerCompensation.WorkerCompensation =
									targetCompany.WorkerCompensations.First(wc => wc.Code.Equals(paycheck.WorkerCompensation.WorkerCompensation.Code));
							paycheck.Accumulations.ForEach(a=>a.PayType.CompanyId = target);

						}
					
					);
					
					var normaljournals = _journalService.GetPayrollJournals(payroll.Id, false);
					normaljournals.ForEach(j =>
					{
						j.CompanyId = target;
						j.PayeeId = targetEmployees.First(te => te.SSN.Equals(sourceEmployees.First(se => se.Id == j.PayeeId).SSN)).Id;
						var scm = sourceCOA.First(ca => ca.Id == j.MainAccountId);
						j.MainAccountId = targetCOA.First(ta => ta.Type == scm.Type && ta.SubType == scm.SubType && ta.UseInPayroll == scm.UseInPayroll && ta.TemplateId==scm.TemplateId).Id;
						j.JournalDetails.ForEach(jd =>
						{
							var sc = sourceCOA.First(ca => ca.Id == jd.AccountId);
							var tc =
								targetCOA.First(ta => ta.Type == sc.Type && ta.SubType == sc.SubType && ta.UseInPayroll == sc.UseInPayroll && ta.TemplateId == sc.TemplateId);
							jd.AccountId = tc.Id;
							jd.AccountName = tc.AccountName;
						});
					});
					affectedJournals.AddRange(normaljournals);
					if (payroll.PEOASOCoCheck)
					{
						var peojournals = _journalService.GetPayrollJournals(payroll.Id, true);
						peojournals.ForEach(j =>
						{
							j.CompanyId = targetHost.Company.Id;
							j.PayeeId = targetEmployees.First(te => te.SSN.Equals(sourceEmployees.First(se => se.Id == j.PayeeId).SSN)).Id;
							var scm = sourceHostCOA.First(ca => ca.Id == j.MainAccountId);
							j.MainAccountId = targetHostCOA.First(ta => ta.Type == scm.Type && ta.SubType == scm.SubType && ta.UseInPayroll == scm.UseInPayroll && ta.TemplateId == scm.TemplateId).Id;
							j.JournalDetails.ForEach(jd =>
							{
								var sc = sourceHostCOA.First(ca => ca.Id == jd.AccountId);
								var tc =
									targetHostCOA.First(ta => ta.Type == sc.Type && ta.SubType == sc.SubType && ta.UseInPayroll == sc.UseInPayroll && ta.TemplateId == sc.TemplateId);
								jd.AccountId = tc.Id;
								jd.AccountName = tc.AccountName;
							});
							
						});
						affectedJournals.AddRange(peojournals);
					}

				});
				var invoices = _readerService.GetPayrollInvoices(companyId: source);
				invoices.ForEach(i =>
				{
					i.Company = targetCompany;
					i.CompanyId = target;
					i.WorkerCompensations.ForEach(wc =>
					{
						wc.WorkerCompensation = targetCompany.WorkerCompensations.First(wc1 => wc1.Code == wc.WorkerCompensation.Code);
					});
				});
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_payrollRepository.DeleteAllPayrolls(target);
					_payrollRepository.MovePayrolls(payrolls, affectedJournals, invoices, source, target);
					txn.Complete();
				}
			}
			catch (Exception e)
			{
				var message = string.Format("Failed to migrate payrolls during copy. Please make sure that the target host is set up with COA and a payroll bank account.");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void CopyPayrolls(Guid source, Guid target, Guid userId, string user)
		{
			try
			{

				try
				{
					_companyService.CopyEmployees(source, target, new List<Guid>(), user);
				}
				catch (Exception)
				{

				}

				var targetCompany = _readerService.GetCompany(target);
				
				var targetHost = _hostService.GetHost(targetCompany.HostId);
				var sourceEmployees = _readerService.GetEmployees(company: source);
				var targetEmployees = _readerService.GetEmployees(company: target);
				var payrolls = _readerService.GetPayrolls(companyId: source);
				
				var targetCOA = _companyRepository.GetCompanyAccounts(target);
				
				var targetHostCOA = _companyRepository.GetCompanyAccounts(targetHost.Company.Id);
				
				using (var txn = TransactionScopeHelper.Transaction())
				{
					_payrollRepository.DeleteAllPayrolls(target);
					payrolls.OrderBy(p => p.LastModified).ToList().ForEach(payroll =>
					{
						
						payroll.CopiedFrom = source;
						payroll.Id = CombGuid.Generate();
						payroll.Company = targetCompany;
						payroll.UserId = userId;
						payroll.UserName = user;
						payroll.PayChecks.ForEach(paycheck =>
						{
							paycheck.Id = 0;
							paycheck.LastModifiedBy = user;
							paycheck.LastModified = DateTime.Now;
							paycheck.Employee = targetEmployees.First(e => e.SSN.Equals(paycheck.Employee.SSN));
							paycheck.PayCodes.ForEach(pc =>
							{
								var hourlyrate = pc.PayCode.HourlyRate;
								pc.PayCode.CompanyId = target;
								pc.PayCode.HourlyRate = hourlyrate;
							});
							paycheck.Deductions.ForEach(ded =>
							{
								ded.Deduction =
									targetCompany.Deductions.First(
										d => d.Type.Id == ded.Deduction.Type.Id && d.DeductionName.Equals(ded.Deduction.DeductionName));
								ded.EmployeeDeduction = paycheck.Employee.Deductions.First(d1 => d1.Deduction.Id == ded.Deduction.Id);

							});
							if (paycheck.WorkerCompensation != null)
								paycheck.WorkerCompensation.WorkerCompensation =
									targetCompany.WorkerCompensations.First(
										wc => wc.Code.Equals(paycheck.WorkerCompensation.WorkerCompensation.Code));
							paycheck.Accumulations.ForEach(a => a.PayType.CompanyId = target);

						});
						payroll.TaxPayDay = payroll.PayDay;
						payroll.Status = PayrollStatus.Committed;
						payroll.PayChecks.ForEach(pc =>
						{
							pc.Status = PaycheckStatus.Saved;
							pc.IsHistory = payroll.IsHistory;
						});
						var companyIdForPayrollAccount = payroll.Company.Id;

						var savedPayroll = _payrollRepository.SavePayroll(payroll);
						var ptaccums = new List<PayCheckPayTypeAccumulation>();
						var pttaxes = new List<PayCheckTax>();
						var ptcomps = new List<PayCheckCompensation>();
						var ptdeds = new List<PayCheckDeduction>();
						var ptcodes = new List<PayCheckPayCode>();
						var ptwcs = new List<PayCheckWorkerCompensation>();
						savedPayroll.PayChecks.OrderBy(pc => pc.Employee.CompanyEmployeeNo).ToList().ForEach(pc =>
						{

							pc.Accumulations.ForEach(a =>
							{
								var ptaccum = new PayCheckPayTypeAccumulation
								{
									PayCheckId = pc.Id,
									PayTypeId = a.PayType.PayType.Id,
									FiscalEnd = a.FiscalEnd,
									FiscalStart = a.FiscalStart,
									AccumulatedValue = a.AccumulatedValue,
									Used = a.Used,
									CarryOver = a.CarryOver
								};
								ptaccums.Add(ptaccum);
							});
							pc.Taxes.ForEach(t =>
							{
								var pt = new PayCheckTax()
								{
									PayCheckId = pc.Id,
									TaxId = t.Tax.Id,
									TaxableWage = t.TaxableWage,
									Amount = t.Amount
								};
								pttaxes.Add(pt);
							});
							pc.Compensations.ForEach(t =>
							{
								var pt = new PayCheckCompensation()
								{
									PayCheckId = pc.Id,
									PayTypeId = t.PayType.Id,
									Amount = t.Amount
								};
								ptcomps.Add(pt);
							});
							pc.Deductions.ForEach(t =>
							{
								var pt = new PayCheckDeduction()
								{
									PayCheckId = pc.Id,
									EmployeeDeductionId = t.EmployeeDeduction.Id,
									CompanyDeductionId = t.Deduction.Id,
									EmployeeDeductionFlat = JsonConvert.SerializeObject(t.EmployeeDeduction),
									Method = t.Method,
									Rate = t.Rate,
									AnnualMax = t.AnnualMax,
									Amount = t.Amount,
									Wage = t.Wage
								};
								ptdeds.Add(pt);
							});
							pc.PayCodes.ForEach(t =>
							{
								var pt = new PayCheckPayCode()
								{
									PayCheckId = pc.Id,
									PayCodeId = t.PayCode.Id,
									PayCodeFlat = JsonConvert.SerializeObject(t.PayCode),
									Amount = t.Amount,
									Overtime = t.OvertimeAmount
								};
								ptcodes.Add(pt);
							});
							if (pc.WorkerCompensation != null)
							{
								var pt = new PayCheckWorkerCompensation()
								{
									PayCheckId = pc.Id,
									WorkerCompensationId = pc.WorkerCompensation.WorkerCompensation.Id,
									WorkerCompensationFlat = JsonConvert.SerializeObject(pc.WorkerCompensation.WorkerCompensation),
									Amount = pc.WorkerCompensation.Amount,
									Wage = pc.WorkerCompensation.Wage
								};
								ptwcs.Add(pt);
							};

							var j = CreateJournalEntry(payroll.Company, pc, targetCOA, payroll.UserName);
							
							pc.DocumentId = j.DocumentId;
							pc.CheckNumber = j.CheckNumber;

						});
						_payrollRepository.SavePayCheckPayTypeAccumulations(ptaccums);
						_payrollRepository.SavePayCheckTaxes(pttaxes);
						_payrollRepository.SavePayCheckWorkerCompensations(ptwcs);
						_payrollRepository.SavePayCheckPayCodes(ptcodes);
						_payrollRepository.SavePayCheckCompensations(ptcomps);
						_payrollRepository.SavePayCheckDeductions(ptdeds);
						if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice &&
							payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
						{
							savedPayroll.PayChecks.ForEach(pc =>
							{
								var j = CreateJournalEntry(payroll.Company, pc, targetHostCOA, user, true, targetHost.Company.Id);
								pc.DocumentId = j.DocumentId;
								pc.CheckNumber = j.CheckNumber;
								
							});
						}
						savedPayroll.PayChecks.Where(px=>px.IsVoid).ToList().ForEach(pc => VoidPayCheck(savedPayroll.Id, pc.Id, user, userId.ToString()));
						Bus.Publish<PayrollSavedEvent>(new PayrollSavedEvent
						{
							SavedObject = savedPayroll,
							TimeStamp = DateTime.Now,
							EventType = NotificationTypeEnum.Created,
							AffectedChecks = new List<PayCheck>(),
							UserName = savedPayroll.UserName,
							UserId = payroll.UserId
						});
					});
				
					
					txn.Complete();
				}
			}
			catch (Exception e)
			{
				var message = string.Format("Failed to copy payrolls");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}
}

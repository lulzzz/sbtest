using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Security;
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
using PayType = HrMaxx.OnlinePayroll.Models.PayType;

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
		private readonly IDocumentService _documentService;
		private readonly IEmailService _emailService;
		
		public IBus Bus { get; set; }

		public PayrollService(IPayrollRepository payrollRepository, ITaxationService taxationService, ICompanyService companyService, IJournalService journalService, IPDFService pdfService, IFileRepository fileRepository, IHostService hostService, IReportService reportService, ICommonService commonService, ICompanyRepository companyRepository, IMementoDataService mementoDataService, IStagingDataService stagingDataService, IMetaDataRepository metaDataRepository, IReaderService readerService, IDocumentService documentService, IEmailService emailService)
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
			_documentService = documentService;
			_emailService = emailService;
			
		}


		public Models.Payroll ProcessPayroll(Models.Payroll payroll)
		{
			try
			{
				payroll.Warnings = string.Empty;
				//Log.Info("Processing start" + DateTime.Now.ToString("hh:mm:ss:fff"));
				var payTypes = _metaDataRepository.GetAllPayTypes();
				//Log.Info("PayTypes " + DateTime.Now.ToString("hh:mm:ss:fff") + " - " + payroll.Company.DescriptiveName);
				var employeeAccumulations = _readerService.GetAccumulations(company: payroll.Company.Id,
						startdate: new DateTime(payroll.PayDay.Year, 1, 1), enddate: payroll.PayDay, ssns: payroll.PayChecks.Where(pc => pc.Included).Select(pc => pc.Employee.SSN).Aggregate(string.Empty, (current, m) => current + Crypto.Encrypt(m) + ","));
				var host = _hostService.GetHost(payroll.Company.HostId);
				//Log.Info("Employee Accumulations " + DateTime.Now.ToString("hh:mm:ss:fff") + " - " + payroll.PayChecks.Count(pc => pc.Included));
				if (payroll.Company.IsLocation)
				{
					var parentCompany = _readerService.GetCompany(payroll.Company.ParentId.Value);
					payroll.Company.CompanyTaxRates = JsonConvert.DeserializeObject<List<CompanyTaxRate>>(JsonConvert.SerializeObject(parentCompany.CompanyTaxRates));
				}
				using (var txn = TransactionScopeHelper.Transaction())
				{
					payroll.CompanyIntId = payroll.Company.CompanyIntId;
					payroll.TaxPayDay = payroll.PayDay;
					
					var payCheckCount = 0;

					if (payroll.Company.CompanyCheckPrintOrder == CompanyCheckPrintOrder.CompanyEmployeeNo)
						payroll.PayChecks = payroll.PayChecks.OrderBy(pc => pc.Employee.CompanyEmployeeNo).ToList();
					else
						payroll.PayChecks = payroll.PayChecks.OrderBy(pc => pc.Employee.LastName).ToList();

					_taxationService.EnsureTaxTablesForPayDay(payroll.PayDay.Year);
					foreach (var paycheck in payroll.PayChecks.Where(pc=>pc.Included))
					{
						paycheck.CompanyIntId = payroll.Company.CompanyIntId;
						paycheck.TaxPayDay = payroll.TaxPayDay;
						paycheck.IsHistory = payroll.IsHistory;
						var employeeAccumulation = employeeAccumulations.First(e => e.EmployeeId.Value == paycheck.Employee.Id);
						var makeup = paycheck.Compensations.FirstOrDefault(pc => pc.PayType.Id == 12);
						if (makeup != null)
							paycheck.Compensations.Remove(makeup);
						var minWage = _taxationService.GetTippedMinimumWage(paycheck.Employee.State.State.StateId, payroll.PayDay.Year);
						ProcessPayments(paycheck, employeeAccumulation, payroll, payTypes, minWage);
						if (paycheck.Employee.IsTipped)
						{
							ProcessTippedEmployee(paycheck, employeeAccumulation, payroll, payTypes, minWage);
						}
						paycheck.YTDSalary = Math.Round(employeeAccumulation.PayCheckWages.Salary + paycheck.Salary, 2, MidpointRounding.AwayFromZero);
						
						var grossWage = GetGrossWage(paycheck);
						paycheck.Compensations = ProcessCompensations(paycheck.Compensations, employeeAccumulation, payTypes);
						paycheck.Accumulations = ProcessAccumulations(paycheck, payroll, employeeAccumulation);
						grossWage = Math.Round(grossWage + paycheck.CompensationTaxableAmount, 2, MidpointRounding.AwayFromZero);

						
						paycheck.Deductions.ForEach(d=>d.Amount = d.Method==DeductionMethod.Amount ? d.Rate : d.Rate*grossWage/100);
						
						paycheck.Taxes = _taxationService.ProcessTaxes(payroll.Company, paycheck, paycheck.PayDay, grossWage, host.Company, employeeAccumulation);
						paycheck.Deductions = ApplyDeductions(grossWage, paycheck, employeeAccumulation, payroll.Company);
						paycheck.GrossWage = grossWage;
						paycheck.NetWage = Math.Round( paycheck.GrossWage - paycheck.DeductionAmount -
															 paycheck.EmployeeTaxes + paycheck.CompensationNonTaxableAmount - paycheck.CompensationPaidInCashAmount, 2, MidpointRounding.AwayFromZero);

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
						paycheck.PaymentMethod = paycheck.ForcePayCheck ? EmployeePaymentMethod.Check : paycheck.Employee.PaymentMethod;
						paycheck.CheckNumber = paycheck.PaymentMethod == EmployeePaymentMethod.Check ? payroll.StartingCheckNumber + payCheckCount++ : -1;

						paycheck.YTDGrossWage = Math.Round(employeeAccumulation.PayCheckWages.GrossWage + paycheck.GrossWage, 2, MidpointRounding.AwayFromZero);
						paycheck.YTDNetWage = Math.Round(employeeAccumulation.PayCheckWages.NetWage + paycheck.NetWage, 2, MidpointRounding.AwayFromZero);

						paycheck.PEOASOCoCheck = (payroll.Company.Contract.BillingOption == BillingOptions.Invoice &&
																	 payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck);
					}
					//PEO/ASO Co Check
					//Log.Info("Processing finished" + DateTime.Now.ToString("hh:mm:ss:fff"));
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
		private void ProcessPayments(PayCheck paycheck, Accumulation employeeAccumulation, Models.Payroll payroll, IList<PayType> payTypes, Models.USTaxModels.MinWageYearRow minWage)
		{
			var applicableMinWage = payroll.Company.MinWage.HasValue ? payroll.Company.MinWage.Value : minWage.MinWage;
			employeeAccumulation.PayCodes = employeeAccumulation.PayCodes ?? new List<PayCheckPayCode>();
			if (paycheck.Employee.PayType == EmployeeType.Hourly)
			{
				paycheck.Salary = 0;
				var defPayCode = paycheck.PayCodes.FirstOrDefault(pc => pc.PayCode.Id == 0);
				if (defPayCode != null)
				{
					if (paycheck.Employee.Rate != defPayCode.PayCode.HourlyRate)
						paycheck.UpdateEmployeeRate = true;
					paycheck.Employee.Rate = defPayCode.PayCode.HourlyRate;
					var empDefCode = paycheck.Employee.PayCodes.FirstOrDefault(pc => pc.Id == 0);
					if (empDefCode == null)
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
				var regularBreakPay = (decimal)0;
				var regularWage = (decimal)0;
				var regularHours = (decimal)0;
				var regularOvertime = (decimal)0;
				var regularBreaktime = (decimal)0;
				var regularRate = (decimal)0;
				paycheck.PayCodes.Where(pcode => pcode.PayCode.Id == 0).ToList().ForEach(pc1 =>
				{
					pc1.AppliedRate = pc1.PayCode.HourlyRate;
					pc1.Amount = Math.Round(pc1.Hours * pc1.PayCode.HourlyRate, 2, MidpointRounding.AwayFromZero);
					pc1.OvertimeAmount = Math.Round(pc1.OvertimeHours * pc1.PayCode.HourlyRate * overtimequotiant, 2,
						MidpointRounding.AwayFromZero);
					pc1.YTD =
						Math.Round(previousPayCodes.Where(ppc => ppc.PayCodeId == pc1.PayCode.Id).Sum(ppc => ppc.YTDAmount) + pc1.Amount, 2,
							MidpointRounding.AwayFromZero);
					pc1.YTDOvertime =
						Math.Round(
							previousPayCodes.Where(ppc => ppc.PayCodeId == pc1.PayCode.Id).Sum(ppc => ppc.YTDOvertime) + pc1.OvertimeAmount,
							2, MidpointRounding.AwayFromZero);

					regularWage = Math.Round(pc1.Amount + pc1.OvertimeAmount, 2, MidpointRounding.AwayFromZero);
					regularBreakPay = Math.Round(pc1.BreakTime * pc1.PayCode.HourlyRate, 2, MidpointRounding.AwayFromZero);
					regularHours = pc1.Hours;
					regularOvertime = pc1.OvertimeHours;
					regularRate = pc1.PayCode.HourlyRate;
					regularBreaktime = pc1.BreakTime;
				});
				var pc = paycheck.PayCodes.First(pcode => pcode.PayCode.Id == -1);
				if (paycheck.Notes.Contains("Piece-work:"))
				{
					paycheck.Notes = paycheck.Notes.Substring(0, paycheck.Notes.IndexOf("Piece-work:")) +
									 $"Piece-work: {pc.PWAmount.ToString("c")} piece @ {pc.Hours.ToString("##.00")} Reg Hr {pc.OvertimeHours.ToString("##.00")} OT Hr";
				}
				else
				{
					paycheck.Notes +=
						$" Piece-work: {pc.PWAmount.ToString("c")} piece @ {pc.Hours.ToString("##.00")} Reg Hr {pc.OvertimeHours.ToString("##.00")} OT Hr";
				}

				var dividend = (pc.Hours + pc.OvertimeHours + regularHours + regularOvertime - (pc.BreakTime + regularBreaktime));
				if (dividend != 0)
				{
					var breakRate =
						Math.Round(
							((pc.PWAmount + regularWage - regularBreakPay) /
							 dividend), 2, MidpointRounding.AwayFromZero);

					if (breakRate < applicableMinWage)
					{
						breakRate = applicableMinWage;
					}
					var PRBreakPay = Math.Round(breakRate * pc.BreakTime, 2, MidpointRounding.AwayFromZero);
					var breakMakeup = Math.Round(((breakRate - regularRate) * regularBreaktime), 2, MidpointRounding.AwayFromZero);


					var prCalculatedRate = (pc.Hours + pc.OvertimeHours) > 0
						? Math.Round((pc.PWAmount + PRBreakPay) / (pc.Hours + pc.OvertimeHours), 2, MidpointRounding.AwayFromZero)
						: 0;
					var prApplicableRate = (decimal)0 + prCalculatedRate;
					if (prCalculatedRate > 0 && prCalculatedRate < applicableMinWage && (pc.Hours + pc.OvertimeHours) > 0)
					{
						prApplicableRate = applicableMinWage;
						var makeUpComp = paycheck.Compensations.FirstOrDefault(c => c.PayType.Id == 12);
						var finalAmount = Math.Round(prApplicableRate * (pc.Hours + pc.OvertimeHours), 2, MidpointRounding.AwayFromZero);
						var makeUpAmount = Math.Round(finalAmount - pc.PWAmount, 2, MidpointRounding.AwayFromZero);

						if (makeUpComp != null)
						{
							makeUpComp.Amount = makeUpAmount;
							makeUpComp.Hours = Math.Round(pc.Hours + pc.OvertimeHours, 2, MidpointRounding.AwayFromZero);
							makeUpComp.Rate = Math.Round(makeUpAmount / (pc.Hours + pc.OvertimeHours), 2, MidpointRounding.AwayFromZero);
						}
						else
						{
							paycheck.Compensations.Add(new PayrollPayType()
							{
								Amount = makeUpAmount,
								Hours = 0,
								Rate = 0,
								PayType = payTypes.First(pt => pt.Id == 12),
								YTD = 0
							});
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
							paycheck.Compensations.Add(new PayrollPayType()
							{
								Amount = PRBreakPay,
								Hours = pc.BreakTime,
								Rate = breakRate,
								PayType = payTypes.First(pt => pt.Id == 13),
								YTD = 0
							});
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
							paycheck.Compensations.Add(new PayrollPayType()
							{
								Amount = breakMakeup,
								Hours = regularBreaktime,
								Rate = breakmakeuprate,
								PayType = payTypes.First(pt => pt.Id == 14),
								YTD = 0
							});
						}

					}



					paycheck.Employee.Rate = prApplicableRate;
					pc.PayCode.HourlyRate = prApplicableRate;
					pc.AppliedRate = prApplicableRate;
					if (pc.SickLeaveTime > 0)
					{
						var sickComp = paycheck.Compensations.FirstOrDefault(c => c.PayType.Id == 6);
						if (sickComp != null)
						{
							sickComp.Amount = Math.Round(Math.Max(prApplicableRate, regularRate) * pc.SickLeaveTime, 2,
								MidpointRounding.AwayFromZero);
							sickComp.Hours = pc.SickLeaveTime;
							sickComp.Rate = Math.Max(prApplicableRate, regularRate);
						}
						else
						{
							paycheck.Compensations.Add(new PayrollPayType()
							{
								Amount =
									Math.Round(Math.Max(prApplicableRate, regularRate) * pc.SickLeaveTime, 2, MidpointRounding.AwayFromZero),
								Hours = pc.SickLeaveTime,
								Rate = Math.Max(prApplicableRate, regularRate),
								PayType = payTypes.First(pt => pt.Id == 6),
								YTD = 0
							});
						}

					}
				}
			}
			paycheck.PayCodes = ProcessPayCodes(paycheck.PayCodes, paycheck, payroll, employeeAccumulation, minWage);
		}
		private List<PayrollPayType> ProcessCompensations(List<PayrollPayType> compensations, Accumulation employeeAccumulation, IList<PayType> payTypes)
		{
			var previousComps = employeeAccumulation.Compensations ?? new List<PayCheckCompensation>();
			compensations.ForEach(c =>
			{
				c.Amount = Math.Round(c.Amount, 2, MidpointRounding.AwayFromZero);
				c.YTD = Math.Round(previousComps.Where(ppc => c.PayType.Id == ppc.PayTypeId).Sum(ppc => ppc.YTD) + c.Amount, 2, MidpointRounding.AwayFromZero);
			});
			previousComps.Where(pc => compensations.All(c => c.PayType.Id != pc.PayTypeId) && pc.YTD > 0).ToList().ForEach(pc => compensations.Add(new PayrollPayType
			{
				Amount = 0,
				Rate = 0,
				YTD = pc.YTD,
				Hours = 0,
				PayType = payTypes.First(t => t.Id == pc.PayTypeId)
			}));
			return compensations;
		}
		private void ProcessTippedEmployee( PayCheck paycheck, Accumulation employeeAccumulation, Models.Payroll payroll, IList<PayType> payTypes, Models.USTaxModels.MinWageYearRow minWage)
		{
			//var minWage = _taxationService.GetTippedMinimumWage(paycheck.Employee.State.State.StateId, payroll.Company.CompanyAddress.City, payroll.Company.MinWage);
			var payCodeSum = GetGrossWage(paycheck);
			var tips = paycheck.Compensations.Where(pc => pc.PayType.IsTip).Sum(pc => pc.Amount);
			var grossWage = Math.Round(payCodeSum + tips, 2, MidpointRounding.AwayFromZero);
			//Min Wage calculation
			var hoursWorked = paycheck.PayCodes.Sum(pc => pc.Hours);
			var overtime = paycheck.PayCodes.Sum(pc => pc.OvertimeHours);
			var applicableMinWage = payroll.Company.MinWage.HasValue ? payroll.Company.MinWage.Value : minWage.MinWage;
			var overtimerate = applicableMinWage * (decimal)1.5 - minWage.MaxTipCredit;
			var hourlyWage = Math.Round(hoursWorked * applicableMinWage, 2, MidpointRounding.AwayFromZero);
			var overtimeWage = Math.Round(overtime * overtimerate, 2, MidpointRounding.AwayFromZero);
			var minGrossWage = Math.Round(hourlyWage, 2, MidpointRounding.AwayFromZero);
			paycheck.Notes = $"Min Wage comparison {minGrossWage.ToString("c")}";
			//
			if (grossWage < minGrossWage)
			{
				var makeUpComp = paycheck.Compensations.FirstOrDefault(c => c.PayType.Id == 12);
				if (makeUpComp != null)
				{
					makeUpComp.Amount += (minGrossWage - grossWage);
					
				}
				else
				{
					paycheck.Compensations.Add(new PayrollPayType()
					{
						Amount = Math.Round(minGrossWage - grossWage, 2, MidpointRounding.AwayFromZero),
						Hours = 0,
						Rate = 0,
						PayType = payTypes.First(pt => pt.Id == 12),
						YTD = 0
					});
				}
				
			}
		}
		private List<PayrollPayCode> ProcessPayCodes(List<PayrollPayCode> payCodes, PayCheck paycheck, Models.Payroll payroll, Accumulation employeeAccumulation, Models.USTaxModels.MinWageYearRow minWage)
		{
			var previousPayCodes = employeeAccumulation.PayCodes;
			if (paycheck.Employee.PayType == EmployeeType.Hourly && !paycheck.Employee.IsTipped)
			{
				const decimal overtimequotiant = (decimal)1.5;


				payCodes.ForEach(pc =>
				{
					pc.AppliedRate = pc.PayCode.RateType == PayCodeRateType.Flat || pc.PayCode.RateType== PayCodeRateType.NA ? pc.PayCode.HourlyRate : Math.Round(pc.PayCode.HourlyRate * paycheck.Employee.Rate,2, MidpointRounding.AwayFromZero);
					pc.Amount = Math.Round(pc.Hours * pc.AppliedRate, 2, MidpointRounding.AwayFromZero);
					pc.AppliedOverTimeRate = Math.Round(pc.AppliedRate * overtimequotiant, 2, MidpointRounding.AwayFromZero);
					pc.OvertimeAmount = Math.Round(pc.OvertimeHours * pc.AppliedOverTimeRate, 2,
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
			else if (paycheck.Employee.PayType == EmployeeType.Hourly && paycheck.Employee.IsTipped)
			{
				const decimal overtimequotiant = (decimal)1.5;
				var applicableMinWage = payroll.Company.MinWage.HasValue ? payroll.Company.MinWage.Value : minWage.MinWage;
				var overtimerate = Math.Round(applicableMinWage * overtimequotiant - minWage.MaxTipCredit, 2, MidpointRounding.AwayFromZero);
				payCodes.ForEach(pc =>
				{
					pc.AppliedRate = pc.PayCode.RateType == PayCodeRateType.Flat || pc.PayCode.RateType == PayCodeRateType.NA ? pc.PayCode.HourlyRate : Math.Round(pc.PayCode.HourlyRate * paycheck.Employee.Rate, 2, MidpointRounding.AwayFromZero);
					pc.Amount = Math.Round(pc.Hours * pc.AppliedRate, 2, MidpointRounding.AwayFromZero);
					pc.AppliedOverTimeRate = overtimerate;
					pc.OvertimeAmount = Math.Round(pc.OvertimeHours * pc.AppliedOverTimeRate, 2,
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

				payCodes.Where(pc => pc.PayCode.Id == -1).ToList().ForEach(pc =>
				{
					pc.Amount = pc.PWAmount;
					pc.AppliedOverTimeRate = Math.Round(pc.PayCode.HourlyRate * overtimequotiantForPieceWork, 2, MidpointRounding.AwayFromZero);
					pc.OvertimeAmount = Math.Round(pc.OvertimeHours * pc.AppliedOverTimeRate, 2,
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

		private List<PayrollDeduction> ApplyDeductions(decimal grossWage, PayCheck payCheck, Accumulation employeeAccumulation, Company company)
		{
			employeeAccumulation.Deductions = employeeAccumulation.Deductions ?? new List<PayCheckDeduction>();
			var localGrossWage = grossWage;
			var eeApplied = false;

			payCheck.Deductions = payCheck.Deductions.Where(d => d.IsApplicable(payCheck.PayDay))
				.OrderBy(d => d.Deduction.Type.Category.GetDbId())
				.ThenBy(d => d.EmployeeDeduction.Priority.HasValue ? d.EmployeeDeduction.Priority.Value : int.MaxValue)
				.ThenBy(d => d.Deduction.Type.Id)
				.ToList();
			payCheck.Deductions.ForEach(d =>
			{
				var companyDeduction = company.Deductions.First(d1 => d1.Id == d.Deduction.Id);
				if ((d.Deduction.Type.Category == DeductionCategory.Other ||
					d.Deduction.Type.Category == DeductionCategory.PostTaxDeduction) && !eeApplied)
				{
					localGrossWage -= payCheck.EmployeeTaxes;
					eeApplied = true;
				}
				d.Amount = 0;
				var ytdVal = employeeAccumulation.Deductions.Where(d1 => d1.CompanyDeductionId == d.Deduction.Id).Sum(d1 => d1.YTD);
				var ytdWage = employeeAccumulation.Deductions.Where(d1 => d1.CompanyDeductionId == d.Deduction.Id).Sum(d1 => d1.YTDWage);
				var ytdEmployer = employeeAccumulation.Deductions.Where(d1 => d1.CompanyDeductionId == d.Deduction.Id).Sum(d1 => d1.YTDEmployer);
				if ((d.Deduction.FloorPerCheck.HasValue && localGrossWage >= d.Deduction.FloorPerCheck) ||
					!d.Deduction.FloorPerCheck.HasValue)
				{
					if (d.Method == DeductionMethod.Amount)
						d.Amount = d.Rate;
					else
						d.Amount = localGrossWage * d.Rate / 100;
					d.Amount = d.Amount > localGrossWage ? localGrossWage : d.Amount;

					if (d.EmployeeDeduction.CeilingPerCheck.HasValue && d.Amount > (d.EmployeeDeduction.CeilingMethod == DeductionMethod.Amount ? d.EmployeeDeduction.CeilingPerCheck.Value : (d.EmployeeDeduction.CeilingPerCheck * localGrossWage / 100)))
					{
						d.Amount = d.EmployeeDeduction.CeilingPerCheck.Value;
					}
					if (d.EmployeeDeduction.Limit.HasValue)
					{
						//var allPayChecks = _payrollRepository.GetEmployeePayChecks(payCheck.Employee.Id);
						var allPayChecks = _readerService.GetPayChecks(employeeId: payCheck.Employee.Id, isvoid: 0);
						var total =
							allPayChecks.Where(pc => pc.Deductions.Any(d1 => d1.EmployeeDeduction.Id == d.EmployeeDeduction.Id))
								.Sum(pc => pc.Deductions.Where(d1 => d1.EmployeeDeduction.Id == d.EmployeeDeduction.Id).Sum(d2 => d2.Amount));
						if (total + d.Amount > d.EmployeeDeduction.Limit.Value)
						{
							d.Amount = Math.Max(0, d.EmployeeDeduction.Limit.Value - total);
						}

					}
				}


				if (d.AnnualMax.HasValue)
				{
					if (ytdVal + d.Amount > d.AnnualMax.Value)
						d.Amount = Math.Max(0, d.AnnualMax.Value - ytdVal);
				}

				if (d.Amount < 0)
					d.Amount = 0;
				if (d.EmployerRate.HasValue && d.EmployerRate > 0)
				{
					d.EmployerAmount = d.Amount * d.EmployerRate / 100;
				}
				d.Wage = Math.Round(localGrossWage, 2, MidpointRounding.AwayFromZero);
				d.Amount = Math.Round(d.Amount, 2, MidpointRounding.AwayFromZero);
				d.YTD = Math.Round(ytdVal + d.Amount, 2, MidpointRounding.AwayFromZero);
				d.YTDWage = Math.Round(ytdWage + d.Wage, 2, MidpointRounding.AwayFromZero);
				d.YTDEmployer = Math.Round(ytdEmployer + (d.EmployerAmount ?? 0), 2, MidpointRounding.AwayFromZero);
				localGrossWage -= d.Amount;
			});

			return payCheck.Deductions.Where(d => d.Rate != 0).ToList();
		}

		private List<PayTypeAccumulation> ProcessAccumulations(PayCheck paycheck, Models.Payroll payroll, Accumulation employeeAccumulation)
		{
			var result = new List<PayTypeAccumulation>();

			foreach (var payType in payroll.Company.AccumulatedPayTypes.Where(at => !at.IsEmployeeSpecific || (paycheck.Employee.PayTypeAccruals != null && paycheck.Employee.PayTypeAccruals.Any(epta=>epta==at.Id))))	
			{
				var fiscalStartDate = CalculateFiscalStartDate(paycheck.Employee.SickLeaveHireDate, paycheck.PayDay, payType);
				var fiscalEndDate = fiscalStartDate.AddYears(1).AddDays(-1);

				if (!payType.CompanyManaged)
				{
					
					var currentAccumulaiton = employeeAccumulation.Accumulations != null &&
					                          employeeAccumulation.Accumulations.Any(
						                          ac =>
							                          ac.PayTypeId == payType.PayType.Id && ac.FiscalStart == fiscalStartDate &&
							                          ac.FiscalEnd == fiscalEndDate)
						? employeeAccumulation.Accumulations.Where(
							ac => ac.PayTypeId == payType.PayType.Id && ac.FiscalStart == fiscalStartDate && ac.FiscalEnd == fiscalEndDate)
							.OrderBy(ac => ac.FiscalStart)
							.Last()
						: null;
					var previousAccumulations = employeeAccumulation.Accumulations != null &&
																		employeeAccumulation.Accumulations.Any(
																			ac =>
																				ac.PayTypeId == payType.PayType.Id && ac.FiscalStart < fiscalStartDate &&
																				ac.FiscalEnd < fiscalEndDate)
						? employeeAccumulation.Accumulations.Where(
							ac => ac.PayTypeId == payType.PayType.Id && ac.FiscalStart < fiscalStartDate && ac.FiscalEnd < fiscalEndDate)
							.ToList()
						: null;
					if (payType.PayType.Id==6 && employeeAccumulation.Accumulations != null &&
					    employeeAccumulation.Accumulations.Count(
						    ac =>
							    ac.PayTypeId == payType.PayType.Id && ac.FiscalStart == fiscalStartDate &&
							    ac.FiscalEnd == fiscalEndDate) > 1)
					{
						payroll.Warnings +=
                            $"Employee #{paycheck.Employee.CompanyEmployeeNo}, {paycheck.Employee.FullName} has multiple leave cycles for this Pay Day<br/>";
					}

					var carryOver = payType.PayType.Id==6 ? paycheck.Employee.CarryOver : 0;
					carryOver += previousAccumulations!=null
						? previousAccumulations.Sum(ac=>ac.YTDFiscal - ac.YTDUsed)
						: 0;

					var ytdAccumulation = (decimal)0;
					var ytdUsed = (decimal)0;

					if (currentAccumulaiton != null)
					{
						ytdAccumulation = currentAccumulaiton.YTDFiscal;
						ytdUsed = currentAccumulaiton.YTDUsed;
						if (payType.PayType.Id != 6)
							carryOver = currentAccumulaiton.CarryOver;

					}
					else
					{
						if (payType.PayType.Id != 6)
						{
							carryOver += previousAccumulations != null
						? previousAccumulations.Sum(ac => ac.CarryOver)
						: 0;
						}
					}

					if (payType.AnnualLimit>0 && ytdAccumulation > payType.AnnualLimit)
						ytdAccumulation = payType.AnnualLimit;

					var thisCheckValue = CalculatePayTypeAccumulation(paycheck, payType, ytdAccumulation);

					var thisCheckUsed = paycheck.Compensations.Any(p => p.PayType.Id == payType.PayType.Id)
						? CalculatePayTypeUsage(paycheck,
							paycheck.Compensations.First(p => p.PayType.Id == payType.PayType.Id).Amount)
						: (decimal) 0;
					var accumulationValue = (decimal) 0;
					if (payType.AnnualLimit > 0 && (ytdAccumulation + thisCheckValue) >= payType.AnnualLimit)
						accumulationValue = Math.Max(payType.AnnualLimit - ytdAccumulation,0);
					else
					{
						accumulationValue = thisCheckValue;
					}

                    if (payType.GlobalLimit.HasValue && payType.GlobalLimit.Value > 0)
                    {
                        if (employeeAccumulation.Accumulations != null)
                        {
                            var globalValue = employeeAccumulation.Accumulations
                                .Where(ac => ac.PayTypeId == payType.PayType.Id).Sum(ac => ac.YTDFiscal) ;
                            if ((globalValue + accumulationValue) >= payType.GlobalLimit.Value)
                            {
                                accumulationValue = Math.Max(payType.GlobalLimit.Value - globalValue, 0);
                            }
                        }
                        else
                        {
                            if (accumulationValue > payType.GlobalLimit.Value)
                                accumulationValue = payType.GlobalLimit.Value;
                        }
                    }

					var acc = new PayTypeAccumulation
					{
						PayType = payType,
						AccumulatedValue = Math.Round(accumulationValue, 2, MidpointRounding.AwayFromZero),
						YTDFiscal = Math.Round(ytdAccumulation + accumulationValue, 2, MidpointRounding.AwayFromZero),
						FiscalStart = fiscalStartDate,
						FiscalEnd = fiscalEndDate,
						Used = Math.Round(thisCheckUsed, 2, MidpointRounding.AwayFromZero),
						YTDUsed = Math.Round(ytdUsed + thisCheckUsed, 2, MidpointRounding.AwayFromZero),
						CarryOver = Math.Round(carryOver, 2, MidpointRounding.AwayFromZero)
					};
					if (acc.PayType.PayType.Id==6 && acc.Available < 0)
					{
						payroll.Warnings +=
                            $"Employee #{paycheck.Employee.CompanyEmployeeNo}, {paycheck.Employee.FullName} available Sick Leave is negative<br/>";
					}
					result.Add(acc);
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

		private List<PayTypeAccumulation> ProcessAccumulations(PayCheck paycheck, Accumulation employeeAccumulation, Company company)
		{
			var result = new List<PayTypeAccumulation>();




			foreach (var payType in company.AccumulatedPayTypes)
			{
				var fiscalStartDate = CalculateFiscalStartDate(paycheck.Employee.SickLeaveHireDate, paycheck.PayDay, payType);
				var fiscalEndDate = fiscalStartDate.AddYears(1).AddDays(-1);

				if (!payType.CompanyManaged)
				{

					var currentAccumulaiton = employeeAccumulation.Accumulations != null &&
																		employeeAccumulation.Accumulations.Any(
																			ac =>
																				ac.PayTypeId == payType.PayType.Id && ac.FiscalStart == fiscalStartDate &&
																				ac.FiscalEnd == fiscalEndDate)
						? employeeAccumulation.Accumulations.Where(
							ac => ac.PayTypeId == payType.PayType.Id && ac.FiscalStart == fiscalStartDate && ac.FiscalEnd == fiscalEndDate)
							.OrderBy(ac => ac.FiscalStart)
							.Last()
						: null;
					///minus this check's accumulation
					if (paycheck.Accumulations.Any(pt => pt.PayType.Id == payType.Id) && currentAccumulaiton!=null)
					{
						currentAccumulaiton.YTDFiscal -= paycheck.Accumulations.First(pt => pt.PayType.Id == payType.Id).AccumulatedValue;
						currentAccumulaiton.YTDUsed -= paycheck.Accumulations.First(pt => pt.PayType.Id == payType.Id).Used;
					}
					var previousAccumulations = employeeAccumulation.Accumulations != null &&
																		employeeAccumulation.Accumulations.Any(
																			ac =>
																				ac.PayTypeId == payType.PayType.Id && ac.FiscalStart < fiscalStartDate &&
																				ac.FiscalEnd < fiscalEndDate)
						? employeeAccumulation.Accumulations.Where(
							ac => ac.PayTypeId == payType.PayType.Id && ac.FiscalStart < fiscalStartDate && ac.FiscalEnd < fiscalEndDate)
							.ToList()
						: null;
					
					var carryOver = paycheck.Employee.CarryOver;
					carryOver += previousAccumulations != null
						? previousAccumulations.Sum(ac => ac.YTDFiscal - ac.YTDUsed)
						: 0;

					var ytdAccumulation = (decimal)0;
					var ytdUsed = (decimal)0;

					if (currentAccumulaiton != null)
					{
						ytdAccumulation = currentAccumulaiton.YTDFiscal;
						ytdUsed = currentAccumulaiton.YTDUsed;
						//carryOver = accum.CarryOver;

					}

					if (ytdAccumulation > payType.AnnualLimit)
						ytdAccumulation = payType.AnnualLimit;

					var thisCheckValue = CalculatePayTypeAccumulation(paycheck, payType, ytdAccumulation);
					var thisCheckUsed = paycheck.Compensations.Any(p => p.PayType.Id == payType.PayType.Id)
						? CalculatePayTypeUsage(paycheck,
							paycheck.Compensations.First(p => p.PayType.Id == payType.PayType.Id).Amount)
						: (decimal)0;
					var accumulationValue = (decimal)0;
					if ((ytdAccumulation + thisCheckValue) >= payType.AnnualLimit)
						accumulationValue = Math.Max(payType.AnnualLimit - ytdAccumulation, 0);
					else
					{
						accumulationValue = thisCheckValue;
					}


					var acc = new PayTypeAccumulation
					{
						PayType = payType,
						AccumulatedValue = Math.Round(accumulationValue, 2, MidpointRounding.AwayFromZero),
						YTDFiscal = Math.Round(ytdAccumulation + accumulationValue, 2, MidpointRounding.AwayFromZero),
						FiscalStart = fiscalStartDate,
						FiscalEnd = fiscalEndDate,
						Used = Math.Round(thisCheckUsed, 2, MidpointRounding.AwayFromZero),
						YTDUsed = Math.Round(ytdUsed + thisCheckUsed, 2, MidpointRounding.AwayFromZero),
						CarryOver = Math.Round(carryOver, 2, MidpointRounding.AwayFromZero)
					};
					
					result.Add(acc);
				}
				else if (paycheck.Accumulations.Any(apt => apt.PayType.Id == payType.Id))
				{
					var pt = paycheck.Accumulations.First(apt => apt.PayType.Id == payType.Id);
					pt.FiscalStart = fiscalStartDate;
					pt.FiscalEnd = fiscalEndDate;
					result.Add(pt);
				}


			}
			return result;
		}

		private decimal CalculatePayTypeUsage(PayCheck payCheck, decimal compnesaitonAmount)
		{
			var employee = payCheck.Employee;
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
				if (employee.PayrollSchedule == PayrollSchedule.Weekly)
					quotient = payCheck.Salary / (40);
				else if (employee.PayrollSchedule == PayrollSchedule.BiWeekly)
					quotient = (payCheck.Salary * 26) / (40 * 52);
				else if (employee.PayrollSchedule == PayrollSchedule.SemiMonthly)
					quotient = (payCheck.Salary * 24) / (40 * 52);
				else if (employee.PayrollSchedule == PayrollSchedule.Monthly)
					quotient = (payCheck.Salary * 12) / (40 * 52);
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

		private decimal CalculatePayTypeAccumulation(PayCheck paycheck, AccumulatedPayType payType, decimal ytd)
		{
			const decimal perDayQuotient = (decimal)5.70;
			if (payType.IsLumpSum)
			{
				return payType.AnnualLimit - ytd;
			}
			else if (payType.Option == AccumulatedPayTypeOption.ByPayPeriodPerDay)
			{
				var days = Convert.ToDecimal((paycheck.EndDate - paycheck.StartDate).TotalDays + 1 );
				return Math.Round(payType.RatePerHour*days, 2);
			}
			else
			{
				if (paycheck.Employee.PayType == EmployeeType.Hourly || paycheck.Employee.PayType == EmployeeType.PieceWork)
				{
					return paycheck.PayCodes.Sum(pc => pc.Hours + pc.OvertimeHours) * payType.RatePerHour;
				}
				else if (paycheck.Employee.PayType == EmployeeType.JobCost)
				{
					var val = perDayQuotient * payType.RatePerHour;
					if (paycheck.Employee.PayrollSchedule == PayrollSchedule.Weekly)
						return 7 * val;
					else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.BiWeekly)
						return 14 * val;
					else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.SemiMonthly)
						return 15 * val;
					else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.Monthly)
						return DateTime.DaysInMonth(paycheck.PayDay.Year, paycheck.PayDay.Month) * val;
					else
					{
						return 0;
					}
				}
				else
				{
					if (paycheck.Employee.Rate <= 0)
						return 0;

					var val = (paycheck.Salary / paycheck.Employee.Rate) * perDayQuotient * payType.RatePerHour;
					if (paycheck.Employee.PayrollSchedule == PayrollSchedule.Weekly)
						return 7 * val;
					else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.BiWeekly)
						return 14 * val;
					else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.SemiMonthly)
						return 15 * val;
					else if (paycheck.Employee.PayrollSchedule == PayrollSchedule.Monthly)
						return DateTime.DaysInMonth(paycheck.PayDay.Year, paycheck.PayDay.Month) * val;
					else
					{
						return 0;
					}
				}
			}
			
		}

		private DateTime CalculateFiscalStartDate(DateTime hireDate, DateTime payDay, AccumulatedPayType payType)
		{
			if(payType.IsLumpSum) 
				return new DateTime(payDay.Year, 1, 1).Date;
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
			var journals = new List<Journal>();
			var peoJournals = new List<Journal>();
			var affectedChecks = new List<PayCheck>();
			try
			{
				//Log.Info(string.Format("Started Confirm Payroll {0} - {3} - {1} - {2}", payroll.Company.Id, payroll.PayDay.ToString("MM/dd/yyyy"), DateTime.Now.ToString("hh:mm:ss:fff"), payroll.Company.Name));
				
				
				var companyIdForPayrollAccount = payroll.Company.Id;
				var coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
				Models.Host host = null;
				if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice &&
							payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
				{
					host = _hostService.GetHost(payroll.Company.HostId);
					payroll.HostCompanyId = host.Company.Id;
				}
				
				using (var txn = TransactionScopeHelper.Transaction())
				{
					payroll.IsQueued = true;
					payroll.QueuedTime = DateTime.Now;
					
					payroll.TaxPayDay = payroll.PayDay;
					payroll.Status = PayrollStatus.Committed;
					payroll.IsPrinted = false;
					payroll.IsVoid = false;
					
					payroll.PayChecks.ForEach(pc => { 
						pc.Status = PaycheckStatus.Saved;
						pc.IsHistory = payroll.IsHistory;
						if (pc.IsHistory)
						{
							var netwage = pc.NetWage;
							pc.NetWage = Math.Round(pc.GrossWage - pc.DeductionAmount - pc.EmployeeTaxes + pc.CompensationNonTaxableAmount, 2, MidpointRounding.AwayFromZero);
							pc.YTDNetWage = Math.Round(pc.YTDNetWage - netwage + pc.NetWage, MidpointRounding.AwayFromZero);
						}
					});


					
					savedPayroll = _payrollRepository.SavePayroll(payroll);
					payroll.PayChecks.Where(pc=>pc.UpdateEmployeeRate).ToList().ForEach(pc=>savedPayroll.PayChecks.First(pc1=>pc1.Employee.Id==pc.Employee.Id).UpdateEmployeeRate = true);
					
					var ptaccums = new List<PayCheckPayTypeAccumulation>();
					var pttaxes = new List<PayCheckTax>();
					var ptcomps = new List<PayCheckCompensation>();
					var ptdeds = new List<PayCheckDeduction>();
					var ptcodes = new List<PayCheckPayCode>();
					var ptwcs = new List<PayCheckWorkerCompensation>();

					if (savedPayroll.Company.CompanyCheckPrintOrder == CompanyCheckPrintOrder.CompanyEmployeeNo)
						savedPayroll.PayChecks = savedPayroll.PayChecks.OrderBy(pc => pc.Employee.CompanyEmployeeNo).ToList();
					else
					{
						savedPayroll.PayChecks = savedPayroll.PayChecks.OrderBy(pc => pc.Employee.LastName).ToList();
					}

					savedPayroll.PayChecks.ForEach(pc =>
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
						pc.Compensations.Where(pcc=>pcc.Amount>0).ToList().ForEach(t =>
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
								Wage = t.Wage,
                                EmployerAmount = t.EmployerAmount,
                                EmployerRate = t.EmployerRate
							};
							ptdeds.Add(pt);
						});
						pc.PayCodes.Where(pcc=>pcc.Amount>0 || pcc.OvertimeAmount>0).ToList().ForEach(t =>
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

						//var j = CreateJournalEntry(payroll, pc, coaList);
						journals.Add(CreateJournalEntry(payroll, pc, coaList));
						//pc.CheckNumber = j.CheckNumber;

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

						companyIdForPayrollAccount = host.Company.Id;
						coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
						savedPayroll.PayChecks.ForEach(pc => peoJournals.Add(CreateJournalEntry(payroll, pc, coaList, true, companyIdForPayrollAccount, host.Company.CompanyIntId)));

					}

					var draftPayroll =
							_stagingDataService.GetMostRecentStagingData<PayrollStaging>(payroll.Company.Id);
					if (draftPayroll != null)
					{
						_stagingDataService.DeleteStagingData<PayrollStaging>(draftPayroll.MementoId);
					}
					//_journalService.UpdateCompanyMaxCheckNumber(payroll.Company.Id, TransactionType.PayCheck);
					txn.Complete();
					//Log.Info(string.Format("Finished Confirm Payroll {0} - {3} - {1} - {2}", payroll.Company.Id, payroll.PayDay.ToString("MM/dd/yyyy"), DateTime.Now.ToString("hh:mm:ss:fff"), payroll.Company.Name));
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Confirm Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			savedPayroll.QueuePosition = _taxationService.AddToConfirmPayrollQueue(new ConfirmPayrollLogItem()
			{
				PayrollId = savedPayroll.Id, CompanyId = savedPayroll.Company.Id, CompanyIntId = savedPayroll.CompanyIntId, QueuedTime = DateTime.Now
			});
			Bus.Publish<ConfirmPayrollEvent>(new ConfirmPayrollEvent()
			{
				Payroll = savedPayroll,
				Journals = journals, PeoJournals = peoJournals
			});
				

				
		
			return savedPayroll;
			
				
				

			
		}
		public Models.Payroll OldConfirmPayroll(Models.Payroll payroll)
		{
			Models.Payroll savedPayroll;
			var affectedChecks = new List<PayCheck>();
			try
			{
				Log.Info(
                    $"Started Confirm Payroll {payroll.Company.Id} - {payroll.PayDay.ToString("MM/dd/yyyy")} - {DateTime.Now.ToString("hh:mm:ss:fff")}");
				var companyPayChecks = _readerService.GetPayChecks(companyId: payroll.Company.Id, startDate: payroll.PayDay, year: payroll.PayDay.Year, isvoid: 0);

				var companyIdForPayrollAccount = payroll.Company.Id;
				var coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
				Models.Host host = null;
				if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice &&
							payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
				{
					host = _hostService.GetHost(payroll.Company.HostId);
					payroll.HostCompanyId = host.Company.Id;
				}
				using (var txn = TransactionScopeHelper.Transaction())
				{
					payroll.TaxPayDay = payroll.PayDay;
					payroll.Status = PayrollStatus.Committed;
					payroll.IsPrinted = false;
					payroll.IsVoid = false;
					payroll.IsConfirmFailed = false;
					payroll.IsQueued = false;
					payroll.QueuedTime = DateTime.Now;
					payroll.ConfirmedTime = DateTime.Now;

					payroll.PayChecks.ForEach(pc =>
					{
						pc.Status = PaycheckStatus.Saved;
						pc.IsHistory = payroll.IsHistory;
						if (pc.IsHistory)
						{
							var netwage = pc.NetWage;
							pc.NetWage = Math.Round(pc.GrossWage - pc.DeductionAmount - pc.EmployeeTaxes + pc.CompensationNonTaxableAmount, 2, MidpointRounding.AwayFromZero);
							pc.YTDNetWage = Math.Round(pc.YTDNetWage - netwage + pc.NetWage, MidpointRounding.AwayFromZero);
						}
					});



					savedPayroll = _payrollRepository.SavePayroll(payroll);

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

						var j = CreateJournalEntry(payroll, pc, coaList);
						j = _journalService.SaveJournalForPayroll(j, payroll.Company);
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

						companyIdForPayrollAccount = host.Company.Id;
						coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
						savedPayroll.PayChecks
							.OrderBy(pc => pc.Employee.CompanyEmployeeNo).ToList()
							.ForEach(pc =>
							{
								var j = CreateJournalEntry(payroll, pc, coaList, true, companyIdForPayrollAccount);
								j = _journalService.SaveJournalForPayroll(j, payroll.Company);
								pc.CheckNumber = j.CheckNumber;
							});


						
					}


					foreach (var paycheck in savedPayroll.PayChecks)
					{
						var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id && p.PayDay > paycheck.PayDay && p.Id != paycheck.Id).ToList();
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
					Log.Info(
                        $"Finished Confirm Payroll {payroll.Company.Id} - {payroll.PayDay.ToString("MM/dd/yyyy")} - {DateTime.Now.ToString("hh:mm:ss:fff")}");
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
		public Models.Payroll ReProcessReConfirmPayroll(Models.Payroll payroll)
		{
			var affectedChecks = new List<PayCheck>();
			try
			{
				payroll = ProcessPayroll(payroll);
				Log.Info(
                    $"Started ReConfirm Payroll {payroll.Company.Id} - {payroll.PayDay.ToString("MM/dd/yyyy")} - {DateTime.Now.ToString("hh:mm:ss:fff")}");
				var companyPayChecks = _readerService.GetPayChecks(companyId: payroll.Company.Id, startDate: payroll.PayDay, year: payroll.PayDay.Year, isvoid: 0);

				var companyIdForPayrollAccount = payroll.Company.Id;
				var coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
				Models.Host host = null;
				if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice &&
							payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
				{
					host = _hostService.GetHost(payroll.Company.HostId);
					payroll.HostCompanyId = host.Company.Id;
				}
				using (var txn = TransactionScopeHelper.Transaction())
				{
					payroll.TaxPayDay = payroll.PayDay;
					payroll.Status = PayrollStatus.Committed;
					payroll.IsPrinted = false;
					payroll.IsVoid = false;

					payroll.PayChecks.ForEach(pc =>
					{
						pc.Status = PaycheckStatus.Saved;
						pc.IsHistory = payroll.IsHistory;
						if (pc.IsHistory)
						{
							var netwage = pc.NetWage;
							pc.NetWage = Math.Round(pc.GrossWage - pc.DeductionAmount - pc.EmployeeTaxes + pc.CompensationNonTaxableAmount, 2, MidpointRounding.AwayFromZero);
							pc.YTDNetWage = Math.Round(pc.YTDNetWage - netwage + pc.NetWage, MidpointRounding.AwayFromZero);
						}
					});

					_payrollRepository.UpdatePayroll(payroll);

					var ptaccums = new List<PayCheckPayTypeAccumulation>();
					var pttaxes = new List<PayCheckTax>();
					var ptcomps = new List<PayCheckCompensation>();
					var ptdeds = new List<PayCheckDeduction>();
					var ptcodes = new List<PayCheckPayCode>();
					var ptwcs = new List<PayCheckWorkerCompensation>();
					var payrollJournals = _readerService.GetJournals(payrollId: payroll.Id, includePayrolls:true, includeDetails:true);
					payroll.PayChecks.OrderBy(pc => pc.Employee.CompanyEmployeeNo).ToList().ForEach(pc =>
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

						
						var journal = payrollJournals.First(j => j.PayrollPayCheckId == pc.Id && !j.PEOASOCoCheck);
						journal.Amount = pc.NetWage;
						journal.LastModified = DateTime.Now;
						journal.LastModifiedBy = payroll.UserName;
						var bankCOA = coaList.First(c => c.UseInPayroll);
						journal.JournalDetails.First(jd => jd.AccountId == bankCOA.Id).Amount = pc.NetWage;
						journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "PAYROLL_EXPENSES").Id).Amount = pc.NetWage;

						pc.Taxes.ForEach(t =>journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == t.Tax.Code).Id).Amount = t.Amount);
						if(pc.CompensationNonTaxableAmount>0)
							journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "MOE").Id).Amount = pc.CompensationNonTaxableAmount;
						else if(journal.JournalDetails.Any(jd=>jd.AccountId==coaList.First(c => c.TaxCode == "MOE").Id))
						{

							journal.JournalDetails.Remove(
								journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "MOE").Id));
						}
	
						if (pc.DeductionAmount > 0)
						{
							journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "ED").Id).Amount = pc.DeductionAmount;
							journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "PD").Id).Amount = pc.DeductionAmount;
						}
						journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "TP").Id).Amount =Math.Round(pc.EmployeeTaxes + pc.EmployerTaxes, 2, MidpointRounding.AwayFromZero);
						_journalService.SaveJournalForPayroll(journal, payroll.Company);

					});
					Log.Info("Stating associations ");
					_payrollRepository.SavePayCheckPayTypeAccumulations(ptaccums);

					_payrollRepository.SavePayCheckTaxes(pttaxes);

					_payrollRepository.SavePayCheckWorkerCompensations(ptwcs);

					_payrollRepository.SavePayCheckPayCodes(ptcodes);

					_payrollRepository.SavePayCheckCompensations(ptcomps);

					_payrollRepository.SavePayCheckDeductions(ptdeds);
					Log.Info("finished associations ");
					//PEO/ASO Co Check


					if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice &&
							payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
					{

						companyIdForPayrollAccount = host.Company.Id;
						coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
						payroll.PayChecks
							.OrderBy(pc => pc.Employee.CompanyEmployeeNo).ToList()
							.ForEach(pc =>
							{
								var journal = payrollJournals.First(j => j.PayrollPayCheckId == pc.Id && j.PEOASOCoCheck);
								journal.Amount = pc.NetWage;
								journal.LastModified = DateTime.Now;
								journal.LastModifiedBy = payroll.UserName;
								var bankCOA = coaList.First(c => c.UseInPayroll);
								journal.JournalDetails.First(jd => jd.AccountId == bankCOA.Id).Amount = pc.NetWage;
								journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "PAYROLL_EXPENSES").Id).Amount = pc.NetWage;

								pc.Taxes.ForEach(t =>journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == t.Tax.Code).Id).Amount = t.Amount);
								if(pc.CompensationNonTaxableAmount>0)
									journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "MOE").Id).Amount = pc.CompensationNonTaxableAmount;
								else if(journal.JournalDetails.Any(jd=>jd.AccountId==coaList.First(c => c.TaxCode == "MOE").Id))
								{

									journal.JournalDetails.Remove(
										journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "MOE").Id));
								}
	
								if (pc.DeductionAmount > 0)
								{
									journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "ED").Id).Amount = pc.DeductionAmount;
									journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "PD").Id).Amount = pc.DeductionAmount;
								}
								journal.JournalDetails.First(jd => jd.AccountId == coaList.First(c => c.TaxCode == "TP").Id).Amount =Math.Round(pc.EmployeeTaxes + pc.EmployerTaxes, 2, MidpointRounding.AwayFromZero);
								_journalService.SaveJournalForPayroll(journal, payroll.Company);
								
							});


						
					}
					else if (payrollJournals.Any(j => j.PEOASOCoCheck))
					{
						_journalService.DeleteJournals(payrollJournals.Where(j => j.PEOASOCoCheck).ToList());
					}


					foreach (var paycheck in payroll.PayChecks)
					{
						var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id && p.PayDay > paycheck.PayDay && p.Id != paycheck.Id).ToList();
						foreach (var employeeFutureCheck in employeeFutureChecks)
						{
							employeeFutureCheck.AddToYTD(paycheck);
							_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
							affectedChecks.Add(employeeFutureCheck);
						}
					}

					if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice)
					{
						var inv = RecreateInvoice(payroll.InvoiceId.Value, payroll.UserName, payroll.UserId);// CreatePayrollInvoice(savedPayroll, payroll.UserName, payroll.UserId, false);
						payroll.InvoiceId = inv.Id;
						payroll.InvoiceNumber = inv.InvoiceNumber;
						payroll.InvoiceStatus = inv.Status;
						payroll.Total = inv.Total;
					}

					
					txn.Complete();
					Log.Info(
                        $"Finished ReConfirm Payroll {payroll.Company.Id} - {payroll.PayDay.ToString("MM/dd/yyyy")} - {DateTime.Now.ToString("hh:mm:ss:fff")}");
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Confirm Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}


			return payroll;





		}

		

		public Models.Payroll VoidPayCheck(Guid payrollId, int payCheckId, string name, string user)
		{
			try
			{
				var payroll = _readerService.GetPayroll(payrollId);
				var paycheck = payroll.PayChecks.First(pc => pc.Id == payCheckId);
				if (payroll.PayChecks.Count(pc=>!pc.IsVoid) == 1 && !paycheck.IsVoid)
				{
					VoidPayroll(payroll, name, user);
				}
				else
				{
					var companyPayChecks = _readerService.GetPayChecks(companyId: paycheck.Employee.CompanyId, employeeId: paycheck.Employee.Id, startDate: paycheck.PayDay, year: paycheck.PayDay.Year, isvoid: 0);
					var employeeFutureChecks = companyPayChecks.Where(p => p.Id != paycheck.Id).ToList();
					using (var txn = TransactionScopeHelper.Transaction())
					{

						paycheck.Status = PaycheckStatus.Void;
						paycheck.IsVoid = true;
						paycheck.LastModified = DateTime.Now;
						paycheck.LastModifiedBy = name;
						_payrollRepository.VoidPayChecks(new List<PayCheck> { paycheck }, name);

						foreach (var employeeFutureCheck in employeeFutureChecks)
						{
							employeeFutureCheck.SubtractFromYTD(paycheck);
							_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
						}

						txn.Complete();

						Bus.Publish<PayCheckVoidedEvent>(new PayCheckVoidedEvent
						{
							SavedObject = paycheck,
							HostId = payroll.Company.HostId,
							UserId = new Guid(user),
							TimeStamp = DateTime.Now,
							EventType = NotificationTypeEnum.Updated,
							AffectedChecks = employeeFutureChecks,
							UserName = name
						});
					}
				}
				
				return _readerService.GetPayroll(payrollId);


			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Void Pay check " + payCheckId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public Models.Payroll UnVoidPayCheck(Guid payrollId, int payCheckId, string name, string user)
		{
			try
			{
				var payroll = _readerService.GetPayroll(payrollId);
				var paycheck = payroll.PayChecks.First(pc => pc.Id == payCheckId);
				
				var companyPayChecks = _readerService.GetPayChecks(companyId: paycheck.Employee.CompanyId, startDate: paycheck.PayDay, year: paycheck.PayDay.Year, isvoid: 0);
				var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id && p.Id != paycheck.Id).ToList();
				using (var txn = TransactionScopeHelper.Transaction())
				{
					paycheck.IsVoid = false;
					paycheck.Status = PaycheckStatus.Saved;
					paycheck.VoidedOn = null;
					paycheck.VoidedBy = null;
					paycheck.LastModified = DateTime.Now;
					paycheck.LastModifiedBy = name;
					var savedPaycheck = _payrollRepository.UnVoidPayCheck(paycheck, name);

					foreach (var employeeFutureCheck in employeeFutureChecks)
					{
						employeeFutureCheck.AddToYTD(paycheck);
						_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
					}

					txn.Complete();

					//Bus.Publish<PayCheckVoidedEvent>(new PayCheckVoidedEvent
					//{
					//	SavedObject = savedPaycheck,
					//	HostId = payroll.Company.HostId,
					//	UserId = new Guid(user),
					//	TimeStamp = DateTime.Now,
					//	EventType = NotificationTypeEnum.Updated,
					//	AffectedChecks = employeeFutureChecks,
					//	UserName = name
					//});
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

		public Models.Payroll VoidPayroll(Models.Payroll payroll, string userName, string userId, bool forceDelete = false)
		{
			try
			{
				Log.Info("Void payroll startded" + DateTime.Now.ToString("hh:mm:ss:fff"));
				var affectedChecks = new List<PayCheck>();
				//var payroll = _readerService.GetPayroll(payroll1.Id);
				var companyPayChecks = _readerService.GetPayChecks(companyId: payroll.Company.Id, startDate: payroll.PayDay, year: payroll.PayDay.Year, isvoid: 0);
				var invoice = (PayrollInvoice)null;
				if (payroll.InvoiceId.HasValue)
				{
					invoice = _readerService.GetPayrollInvoice(payroll.InvoiceId.Value);
					
				}
				
				Log.Info("read finished" + DateTime.Now.ToString("hh:mm:ss:fff"));
				using (var txn = TransactionScopeHelper.Transaction())
				{
					if (payroll.InvoiceId.HasValue && invoice != null && (forceDelete || invoice.Status == InvoiceStatus.Draft || invoice.Status == InvoiceStatus.Submitted))
						DeletePayrollInvoice(payroll.InvoiceId.Value, new Guid(userId), userName, comment:
                            $"Invoice Deleted for Void Payroll {(forceDelete ? " - Move Payroll" : string.Empty)}", invoice: invoice);

					//_payrollRepository.VoidPayChecks(payroll.PayChecks, userName);
					payroll.PayChecks.Where(pc=>!pc.IsVoid).ToList().ForEach(paycheck =>
					{
						var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id && p.Id!=paycheck.Id).ToList();
						foreach (var employeeFutureCheck in employeeFutureChecks)
						{
							employeeFutureCheck.SubtractFromYTD(paycheck);
							_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
							affectedChecks.Add(employeeFutureCheck);
						}
					});
					Log.Info("Checks Voided" + DateTime.Now.ToString("hh:mm:ss:fff"));


					_payrollRepository.VoidPayroll(payroll, userName);
					txn.Complete();
					
				}
				payroll = _readerService.GetPayroll(payroll.Id);
				foreach (var payCheck in payroll.PayChecks)
				{
					Bus.Publish<PayCheckVoidedEvent>(new PayCheckVoidedEvent
					{
						SavedObject = payCheck,
						HostId = payroll.Company.HostId,
						UserId = new Guid(userId),
						TimeStamp = DateTime.Now,
						EventType = NotificationTypeEnum.Updated,
						AffectedChecks = affectedChecks.Where(pc=>pc.Employee.Id==payCheck.Employee.Id).ToList(),
						UserName = userName
					});	
				}
				Log.Info("Void Payroll Finished" + DateTime.Now.ToString("hh:mm:ss:fff"));
				_fileRepository.DeleteDestinationFile(payroll.Id + ".pdf");
				return payroll;


			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Void Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public Models.Payroll UnVoidPayroll(Models.Payroll payroll, string userName, string userId)
		{
			try
			{
				Log.Info("Un Void payroll startded" + DateTime.Now.ToString("hh:mm:ss:fff"));
				var affectedChecks = new List<PayCheck>();
				//var payroll = _readerService.GetPayroll(payroll1.Id);
				var companyPayChecks = _readerService.GetPayChecks(companyId: payroll.Company.Id, startDate: payroll.PayDay, year: payroll.PayDay.Year, isvoid: 0);
				
				Log.Info("read finished" + DateTime.Now.ToString("hh:mm:ss:fff"));
				using (var txn = TransactionScopeHelper.Transaction())
				{
					//_payrollRepository.VoidPayChecks(payroll.PayChecks, userName);
					payroll.PayChecks.Where(pc => pc.IsVoid).ToList().ForEach(paycheck =>
					{
						var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id && p.Id != paycheck.Id).ToList();
						foreach (var employeeFutureCheck in employeeFutureChecks)
						{
							employeeFutureCheck.AddToYTD(paycheck);
							_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
							affectedChecks.Add(employeeFutureCheck);
						}
					});
					Log.Info("Checks Un Voided" + DateTime.Now.ToString("hh:mm:ss:fff"));


					_payrollRepository.UnVoidPayroll(payroll.Id, userName);
					txn.Complete();

				}
				payroll = _readerService.GetPayroll(payroll.Id);
				//foreach (var payCheck in payroll.PayChecks)
				//{
				//	Bus.Publish<PayCheckVoidedEvent>(new PayCheckVoidedEvent
				//	{
				//		SavedObject = payCheck,
				//		HostId = payroll.Company.HostId,
				//		UserId = new Guid(userId),
				//		TimeStamp = DateTime.Now,
				//		EventType = NotificationTypeEnum.Updated,
				//		AffectedChecks = affectedChecks.Where(pc => pc.Employee.Id == payCheck.Employee.Id).ToList(),
				//		UserName = userName,
				//		IsUnVoid=true
				//	});
				//}
				Log.Info("Void Payroll Finished" + DateTime.Now.ToString("hh:mm:ss:fff"));
				_fileRepository.DeleteDestinationFile(payroll.Id + ".pdf");
				return payroll;


			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Un - Void Payroll");
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
		public FileDto PrintPaySlip(int payCheckId)
		{
			try
			{
				var payCheck = _readerService.GetPaycheck(payCheckId);
				var payroll = _readerService.GetPayroll(payCheck.PayrollId);
				
				return PrintPayCheckPaySlip(payroll, new List<PayCheck>() { payCheck });
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

		public FileDto PrintPayrollChecks(Guid payrollId, int companyCheckPrintOrder)
		{
			try
			{
				
				var payroll = _readerService.GetPayroll(payrollId);
				payroll.Company.CompanyCheckPrintOrder = (CompanyCheckPrintOrder)companyCheckPrintOrder;
				var returnFile = new FileDto();
				if ((int) payroll.Status > 2 && (int) payroll.Status < 6)
				{
					var journals = _journalService.GetPayrollJournals(payroll.Id, payroll.PEOASOCoCheck);
					
					//returnFile = PrintPayCheck(payroll, payroll.PayChecks.Where(pc => !pc.IsVoid).OrderBy(pc=>pc.Employee.CompanyEmployeeNo).ToList(), journals);
					returnFile = PrintAndSavePayroll(payroll, journals);
					
				}

				if (!payroll.IsPrinted)
				{
					_payrollRepository.MarkPayrollPrinted(payroll.Id);
					
				}
				
                //txn.Complete();
				
				return returnFile;
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Print Payrolls for id=" + payrollId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public Models.Payroll RecalculatePayrollAccumulations(Guid payrollId)
		{
			try
			{

				var payroll = _readerService.GetPayroll(payrollId);
				var company = _readerService.GetCompany(payroll.Company.Id);
				payroll.Company.AccumulatedPayTypes = company.AccumulatedPayTypes;
				var employeeAccumulations = _readerService.GetAccumulations(company: payroll.Company.Id,
						startdate: new DateTime(payroll.PayDay.Year, 1, 1), enddate: payroll.PayDay, ssns: payroll.PayChecks.Where(pc => pc.Included).Select(pc => pc.Employee.SSN).Aggregate(string.Empty, (current, m) => current + Crypto.Encrypt(m) + ","));
				using(var txn = TransactionScopeHelper.Transaction())
				{
					payroll.PayChecks.Where(pc=>!pc.Accumulations.Any()).ToList().ForEach(pc =>
					{
						pc.Accumulations = ProcessAccumulations(pc, payroll, employeeAccumulations.First(ea => ea.EmployeeId == pc.EmployeeId));
						_payrollRepository.UpdatePayCheckSickLeaveAccumulation(pc);
					});
					txn.Complete();
				}			
				
				return _readerService.GetPayroll(payrollId);

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " ReCalculating Accumulations for id=" + payrollId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto PrintAndSavePayroll(Models.Payroll payroll, List<Journal> journals)
		{
			if ((int)payroll.Status > 2 && (int)payroll.Status < 6)
			{
				journals = journals.Where(j=>j.PEOASOCoCheck==payroll.PEOASOCoCheck).ToList();
				var payChecks = payroll.PayChecks.Where(pc => !pc.IsVoid);
				if (payroll.Company.CompanyCheckPrintOrder == CompanyCheckPrintOrder.CompanyEmployeeNo)
					payChecks = payChecks.OrderBy(pc => pc.Employee.CompanyEmployeeNo);
				else
				{
					payChecks = payChecks.OrderBy(pc => pc.Employee.FullNameSpecial);
				}
				var returnFile = PrintPayCheck(payroll, payChecks.ToList(), journals);
				if (returnFile != null)
				{
					_fileRepository.SaveFile(EntityTypeEnum.Payroll.GetDbName(), payroll.Id.ToString(), "pdf", returnFile.Data);
				}
				return returnFile;
			}
			return null;
			
		}

		public FileDto PrintPayrollPack(Models.Payroll payroll)
		{
			var journals = _journalService.GetPayrollJournals(payroll.Id, payroll.PEOASOCoCheck);
			if ((int)payroll.Status > 2 && (int)payroll.Status < 6)
			{
				journals = journals.Where(j => j.PEOASOCoCheck == payroll.PEOASOCoCheck).ToList();
				var payChecks = payroll.PayChecks.Where(pc => !pc.IsVoid);
				if (payroll.Company.CompanyCheckPrintOrder == CompanyCheckPrintOrder.CompanyEmployeeNo)
					payChecks = payChecks.OrderBy(pc => pc.Employee.CompanyEmployeeNo);
				else
				{
					payChecks = payChecks.OrderBy(pc => pc.Employee.FullNameSpecial);
				}
				var models = PrintPayrollPackPayChecks(payroll, payChecks.ToList(), journals);
				var dir = $"{payroll.Company.Name}_Payroll_{payroll.PayDay.ToString("MMddyyyy")}";
				dir = _documentService.CreateDirectory(dir);
				_pdfService.PrintPayrollPack(dir, models);
				_reportService.PrintPayrollSummary(payroll, true, $"{dir}//PayrollSummary.pdf");
				var returnFile = _documentService.ZipDirectory(dir,
                    $"{payroll.Company.Name}_Payroll_{payroll.PayDay.ToString("MMddyyyy")}.zip");
				_documentService.DeleteDirectory(dir);
				return new FileDto() { Data = returnFile, DocumentExtension = ".zip", Filename =
                    $"{payroll.Company.Name}_Payroll_{payroll.PayDay.ToString("MMddyyyy")}", MimeType = "application/octet-stream" };
			}
			return null;

		}
		public async Task<List<string>>  EmailPayrollPack(Models.Payroll payroll)
		{
			const string employeeEmailBody =
				"Dear {1}, <br/><br/> Please find attached the ACH Pay Check copy for the Pay Date <i>{0}</i> <br/><br/> <i><u>Do Not reply to this message</u></i>";
			const string companyEmailBody = "Dear {1}, <br/><br/> Please find attached the Payroll Pack for the Pay Date <i>{0}</i> <br/><br/> <i><u>Do Not reply to this message</u></i>";
			var dir = $"{payroll.Company.Name}_Payroll_{payroll.PayDay.ToString("MMddyyyy")}";
			try
			{
				var returnList = new List<string>();
				var journals = _journalService.GetPayrollJournals(payroll.Id, payroll.PEOASOCoCheck);
				var employees = _readerService.GetEmployees(company: payroll.Company.Id);
				var company = _readerService.GetCompany(payroll.Company.Id);
				if ((int) payroll.Status > 2 && (int) payroll.Status < 6)
				{
					journals = journals.Where(j => j.PEOASOCoCheck == payroll.PEOASOCoCheck).ToList();
					var payChecks = payroll.PayChecks.Where(pc => !pc.IsVoid);
					if (payroll.Company.CompanyCheckPrintOrder == CompanyCheckPrintOrder.CompanyEmployeeNo)
						payChecks = payChecks.OrderBy(pc => pc.Employee.CompanyEmployeeNo);
					else
					{
						payChecks = payChecks.OrderBy(pc => pc.Employee.FullNameSpecial);
					}
					var models = PrintPayrollPackPayChecks(payroll, payChecks.ToList(), journals);
					
					dir = _documentService.CreateDirectory(dir);
					_pdfService.PrintPayrollPack(dir, models);
					_reportService.PrintPayrollSummary(payroll, true, $"{dir}//PayrollSummary.pdf");
					var returnFile = _documentService.ZipDirectory(dir,
                        $"{payroll.Company.Name}_Payroll_{payroll.PayDay.ToString("MMddyyyy")}.zip", false);
					payChecks.Where(pc => pc.PaymentMethod == EmployeePaymentMethod.DirectDebit).ToList().ForEach(async pc =>
					{
						var employee = employees.First(e => e.Id == pc.EmployeeId);
						if (string.IsNullOrWhiteSpace(employee.Contact.Email))
							returnList.Add($"No Email Sent. Invalid email found for Employee {employee.FullName}");
						else
						{

							await _emailService.SendEmail(to: employee.Contact.Email,
								subject: string.Format(OnlinePayrollStringResources.EMAIL_ACH_EmployeeSubject, employee.FullName),
								body: string.Format(employeeEmailBody, pc.PayDay.ToString("MM/dd/yyyy"), employee.FullName),
								cc: _emailService.GetACHPackCC(),
								fileName: $"{dir}/{pc.Employee.FullName}.pdf");
							returnList.Add(
                                $"Email Sent to {employee.FullName} at {employee.Contact.Email} with ACH Pay Check");
						}

					});
					await _emailService.SendEmail(to: company.Contact.Email,
								subject: OnlinePayrollStringResources.EMAIL_Company_PayrollSubject,
								body: string.Format(companyEmailBody, payroll.PayDay.ToString("MM/dd/yyyy"), company.Contact.FullName),
								cc: _emailService.GetACHPackCC(),
								fileName: $"{dir}.zip");
					
					returnList.Add(
                        $"Email Sent to {company.Contact.FullName} at {company.Contact.Email} with Payroll Pack");


					_fileRepository.DeleteDestinationFile(
                        $"{payroll.Company.Name}_Payroll_{payroll.PayDay.ToString("MMddyyyy")}.zip");
					_documentService.DeleteDirectory(dir);
					
				}
				return returnList;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX,
					" Emails to ACH employees for payroll id=" + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			finally
			{
				
			}
			

		}

		public FileDto PrintPayrollPayslips(Guid payrollId)
		{
			try
			{
				var payroll = _readerService.GetPayroll(payrollId);
				var returnFile = new FileDto();
				if ((int)payroll.Status > 2 && (int)payroll.Status < 6)
				{
					var journals = _journalService.GetPayrollJournals(payroll.Id, payroll.PEOASOCoCheck);
					returnFile = PrintPayCheckPaySlip(payroll, payroll.PayChecks.Where(pc => !pc.IsVoid).OrderBy(pc => pc.Employee.CompanyEmployeeNo).ToList());
				}
				
				return returnFile;

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Print Payrolls for id=" + payrollId);
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
			var invoiceStrLog = new StringBuilder();
			try
			{
				
				var company = fetchCompany ? _readerService.GetCompany(payroll.Company.Id) : payroll.Company;
				if (company.RecurringCharges!=null && company.RecurringCharges.Any())
				{
					company.RecurringCharges = _readerService.GetCompanyRecurringCharges(payroll.Company.Id);
				}
				
				var previousInvoices = _readerService.GetCompanyPreviousInvoiceNumbers(companyId: payroll.Company.Id);
				var voidedPayChecks = _readerService.GetCompanyPayChecksForInvoiceCredit(companyId: payroll.Company.Id);
				payrollInvoice.Initialize(payroll, previousInvoices, _taxationService.GetApplicationConfig().EnvironmentalChargeRate, company, voidedPayChecks);

				var savedInvoice = _payrollRepository.SavePayrollInvoice(payrollInvoice,ref invoiceStrLog);
				if (savedInvoice.Company == null)
					savedInvoice.Company = company;
				savedInvoice.PayrollPayDay = payroll.PayDay;
				savedInvoice.PayrollTaxPayDay = payroll.TaxPayDay;

				if (!string.IsNullOrWhiteSpace(payroll.Notes))
				{
					_commonService.AddToList<Comment>(EntityTypeEnum.Company, EntityTypeEnum.Comment, company.Id, new Comment { Content =
                        $"Invoice #{payrollInvoice.InvoiceNumber}: {payroll.Notes}", TimeStamp = savedInvoice.LastModified });
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
				Log.Info(invoiceStrLog.ToString());
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " create invoice for payroll id=" + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public PayrollInvoice RecreateInvoice(Guid invoiceId, string fullName, Guid userId)
		{
			try
			{
				var invoice = _readerService.GetPayrollInvoice(invoiceId);
				var payroll = _readerService.GetPayroll(invoice.PayrollId);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					
					var payrollInvoice = new PayrollInvoice { Id = invoice.Id, UserName = fullName, UserId = userId, LastModified = DateTime.Now, ProcessedBy = payroll.UserName, InvoiceNumber = invoice.InvoiceNumber};
					_payrollRepository.DeletePayrollInvoice(invoiceId, invoice.MiscCharges, invoice);
					var recreated = CreateInvoice(payroll, payrollInvoice, true);
					var memento = Memento<PayrollInvoice>.Create(recreated, EntityTypeEnum.Invoice, recreated.UserName, string.Format("Invoice Re-Created"), recreated.UserId);
					_mementoDataService.AddMementoData(memento);
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
			var strLog = new StringBuilder();
			try
			{

				strLog.AppendLine("Starting Invoice Save for Company " + invoice.Company.Name + " No." + invoice.InvoiceNumber +
				                  " - " + DateTime.Now.ToString("hh:mm:ss:fff"));
				var dbIncvoice = _readerService.GetCompanyInvoices(invoice.CompanyId, id:invoice.Id).First();
				invoice.InvoicePayments.ForEach(p =>
				{
					if (p.Status == PaymentStatus.Draft)
					{
						p.Status = (p.Method == InvoicePaymentMethod.Cash || p.Method == InvoicePaymentMethod.CertFund || p.Method == InvoicePaymentMethod.CorpCheck) ? PaymentStatus.Paid : PaymentStatus.Submitted;
					}

				});
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

					if ((invoice.Status == InvoiceStatus.Delivered || invoice.Status == InvoiceStatus.PartialPayment || invoice.Status == InvoiceStatus.PaymentBounced || invoice.Status == InvoiceStatus.Paid || invoice.Status == InvoiceStatus.Deposited || invoice.Status == InvoiceStatus.NotDeposited || invoice.Status == InvoiceStatus.ACHPending))
					{
						if (invoice.Balance <= 0)
							invoice.Status = InvoiceStatus.Paid;
						else if (invoice.Balance <= invoice.Total)
						{
							if (invoice.InvoicePayments.Any(p => p.Status == PaymentStatus.PaymentBounced))
							{
								invoice.Status = InvoiceStatus.PaymentBounced;
								_commonService.AddToList(EntityTypeEnum.Company, EntityTypeEnum.Comment, invoice.CompanyId, new Comment { Content =
                                    $"Invoice #{invoice.InvoiceNumber} - Payment Bounced", LastModified = DateTime.Now, UserName = invoice.UserName });
							}
							else if (invoice.InvoicePayments.Any(p => p.Status == PaymentStatus.Submitted))
							{
								invoice.Status = InvoiceStatus.NotDeposited;
							}
							else if (invoice.InvoicePayments.Any(p => p.Status == PaymentStatus.Deposited))
							{
								invoice.Status = InvoiceStatus.Deposited;

							}
							else if (invoice.InvoicePayments.Any(p => p.Method == InvoicePaymentMethod.ACH && p.Status == PaymentStatus.Submitted))
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
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var savedInvoice = _payrollRepository.SavePayrollInvoice(invoice, ref strLog);
					savedInvoice.Company = invoice.Company;
					savedInvoice.PayrollPayDay = invoice.PayrollPayDay;
					savedInvoice.PayrollTaxPayDay = invoice.PayrollTaxPayDay;
					txn.Complete();
					strLog.AppendLine("Invoice transaction Committed " + invoice.Company.Name + " No." + invoice.InvoiceNumber  + " - " + DateTime.Now.ToString("hh:mm:ss:fff"));
					if (dbIncvoice!=null &&
						dbIncvoice.MiscCharges.Any(
							dbmc =>
								dbmc.RecurringChargeId > 0 &&
								(invoice.MiscCharges.All(mc => mc.RecurringChargeId != dbmc.RecurringChargeId) ||
								 invoice.MiscCharges.Any(mc => mc.RecurringChargeId == dbmc.RecurringChargeId && mc.Amount != dbmc.Amount))))
					{
						Bus.Publish(new InvoiceRecurringChargesHandleEvent
						{
							DbInvoice = dbIncvoice,
							Invoice = invoice
						});
					}
					Bus.Publish(new CreateMementoEvent<PayrollInvoice>
					{
						List = new List<PayrollInvoice>{savedInvoice},
						EntityType = EntityTypeEnum.Invoice,
						Notes = "Invoice Updated",
						UserId = invoice.UserId,
						UserName = invoice.UserName,
						LogNotes = $"Mementos (Invoice) for payroll {savedInvoice.Id} - {savedInvoice.Company.Name}"
                    });

					return savedInvoice;
				}

			}
			catch (Exception e)
			{
				Log.Info(strLog.ToString());
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Save Invoice for company id=" + invoice.CompanyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void DeletePayrollInvoice(Guid invoiceId, Guid userId, string userName, string comment = "Invoice Deleted", PayrollInvoice invoice = null)
		{
			try
			{
				if(invoice==null)
					invoice = _readerService.GetPayrollInvoice(invoiceId);
				_payrollRepository.DeletePayrollInvoice(invoice.Id, invoice.MiscCharges, invoice);
				Bus.Publish(new CreateMementoEvent<PayrollInvoice>
				{
					List = new List<PayrollInvoice> { invoice },
					EntityType = EntityTypeEnum.Invoice,
					Notes = comment,
					UserId = userId,
					UserName = invoice.UserName,
					LogNotes = $"Mementos (Invoice) deleted {invoice.Id} - {invoice.Company.Name}"
                });
				
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

		private PDFModel GetPdfModelPaySlip(Models.Payroll payroll, PayCheck payCheck, Company company)
		{
			var pdf = new PDFModel
			{
				Name = string.Format("Pay Check_{1}_{2} {0}.pdf", payCheck.PayDay.ToString("MMddyyyy"), payCheck.PayrollId, payCheck.Id),
				TargetId = payCheck.Id,
				NormalFontFields = new List<KeyValuePair<string, string>>(),
				BoldFontFields = new List<KeyValuePair<string, string>>(),
				TargetType = EntityTypeEnum.PayCheck,
				Template = "PaySlip.pdf",
				DocumentId = Guid.Empty,
				Signature = null
			};

			
			
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName2", payCheck.Employee.FullName));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("CompanyMemo", payroll.Company.Memo.Replace(Environment.NewLine, string.Empty).Replace("\n", string.Empty)));
			
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date2", payCheck.PayDay.ToString("MM/dd/yyyy")));

			
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Memo",
                $"Pay Period {payCheck.StartDate.ToString("d")}-{payCheck.EndDate.ToString("d")}"));
			var caption8 =
                $"****-**-{payCheck.Employee.SSN.Substring(payCheck.Employee.SSN.Length - 4)}                                                {"Employee No:"} {(payCheck.Employee.CompanyEmployeeNo.HasValue ? payCheck.Employee.CompanyEmployeeNo.Value.ToString() : string.Empty)}";
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Caption8", caption8));
			pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CompName", company.Name));

			pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo-2",
					payCheck.PaymentMethod != EmployeePaymentMethod.Check ? "EFT" : payCheck.CheckNumber.ToString()));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compAddress", company.CompanyAddress.AddressLine1));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compCity", company.CompanyAddress.AddressLine2));

			var sum2 =
                $"Federal Status: {payCheck.Employee.FederalStatus.GetDbName()}{"".PadRight(57 - payCheck.Employee.FederalStatus.GetDbName().Length)}Federal Exemptions: {payCheck.Employee.FederalExemptions}{"".PadRight(66 - payCheck.Employee.FederalAdditionalAmount.ToString("C").Length)}Additional Fed Withholding: {payCheck.Employee.FederalAdditionalAmount.ToString("C")}";
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum2", sum2));

			var text8 =
                $"State Status:    {payCheck.Employee.State.TaxStatus.GetDbName()}{"".PadRight(57 - payCheck.Employee.State.TaxStatus.GetDbName().Length)}State Exemptions:    {payCheck.Employee.State.Exemptions}{"".PadRight(66 - payCheck.Employee.State.AdditionalAmount.ToString("C").Length)}Additional State Withholding: {payCheck.Employee.State.AdditionalAmount.ToString("C")}";
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text8", text8));

			
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
					.OrderBy(p => p.PayCode.Id)
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
						if (payCode.PayCode.Id != -1)
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("r-" + hrcounter, payCode.AppliedRate.ToString("C")));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("am-" + hrcounter, payCode.Amount.ToString("c")));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdam-" + hrcounter, payCode.YTD.ToString("C")));

						hrcounter++;
					}
					if (otcounter < 4 && (payCode.OvertimeAmount > 0 || payCode.YTDOvertime > 0))
					{

						if (payCode.PayCode.Id != -1)
						{
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + otcounter + "-ot",
								payCode.PayCode.Description + " Overtime"));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ot-" + otcounter, payCode.OvertimeHours.ToString()));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("or-" + otcounter,
								(payCode.AppliedOverTimeRate).ToString("C")));
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
				
			}
			//if (payCheck.Employee.PayType == EmployeeType.PieceWork)
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum3-1", !string.IsNullOrWhiteSpace(payCheck.Notes) ? payCheck.Notes : string.Empty));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum3", !string.IsNullOrWhiteSpace(payCheck.Notes) ? payCheck.Notes : string.Empty));
			}

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum1",
                $"Pay Period {payCheck.StartDate.ToString("d")} - {payCheck.EndDate.ToString("d")}"));
			var compCounter = 1;
			foreach (var compensation in payCheck.Compensations.Where(compensation => compensation.Amount > 0 || compensation.YTD > 0))
			{
				if (payCheck.Employee.PayType == EmployeeType.PieceWork && (compensation.PayType.Id == 6 || compensation.PayType.Id == 13))
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pcomp" + compCounter,
                        $"{compensation.PayType.Description}{(compensation.Hours > 0 ? " - " + compensation.Hours.ToString() + " hrs" : string.Empty)}"));
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
				var accumulationCounter = 1;
				payCheck.Accumulations.ForEach(scl =>
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("scltype-"+accumulationCounter,
                        $"{scl.PayType.PayType.Description} ({scl.FiscalStart.ToString("d")} - {scl.FiscalEnd.ToString("d")})"));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclhours-"+accumulationCounter, scl.Used.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclcurrent-"+accumulationCounter, scl.AccumulatedValue.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclytd-"+accumulationCounter, scl.YTDFiscal.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclused-" + accumulationCounter, scl.YTDUsed.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclco-" + accumulationCounter, scl.CarryOver.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclnet-"+accumulationCounter, (scl.Available ).ToString()));
					accumulationCounter++;
				});
				
				
			}
			return pdf;
		}

		private PDFModel GetPdfModel(Models.Payroll payroll, PayCheck payCheck, Models.Journal journal, Company company,
			Company nameCompany, Company company1, Account bankcoa, Document signature)
		{
			var pdf = new PDFModel
			{
				Name = string.Format("Pay Check_{1}_{2} {0}.pdf", payCheck.PayDay.ToString("MMddyyyy"), payCheck.PayrollId, payCheck.Id),
				TargetId = payCheck.Id,
				NormalFontFields = new List<KeyValuePair<string, string>>(),
				BoldFontFields = new List<KeyValuePair<string, string>>(),
				TargetType = EntityTypeEnum.PayCheck,
				Template = company1.PayCheckStock.GetHrMaxxName(),
				Signature = null
			};

			if (payCheck.PaymentMethod == EmployeePaymentMethod.Check)
			{
				if (signature != null)
				{
					pdf.Signature = new PDFSignature
					{
						Path = _fileRepository.GetDocumentLocation(signature.Path),
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
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo-2", payCheck.PaymentMethod != EmployeePaymentMethod.Check ? "EFT" : payCheck.CheckNumber.ToString()));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date-3", payCheck.PayDay.ToString("MM/dd/yyyy")));
			}
			pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo", payCheck.PaymentMethod != EmployeePaymentMethod.Check ? "EFT" : payCheck.CheckNumber.ToString()));
			pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo2", payCheck.PaymentMethod != EmployeePaymentMethod.Check ? "EFT" : payCheck.CheckNumber.ToString()));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Address", nameCompany.CompanyAddress.AddressLine1));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("City", nameCompany.CompanyAddress.AddressLine2));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName", payroll.Company.CompanyCheckPrintOrder == CompanyCheckPrintOrder.CompanyEmployeeNo ? payCheck.Employee.FullName : payCheck.Employee.FullNameSpecial));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName2", payroll.Company.CompanyCheckPrintOrder == CompanyCheckPrintOrder.CompanyEmployeeNo ? payCheck.Employee.FullName : payCheck.Employee.FullNameSpecial));
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
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("AmtInWords",
                    $"{words} {decPlaces}/100 {"****"}"));
			}
			else
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Amount", payCheck.NetWage.ToString("F")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("AmtInWords",
                    $"{words} {decPlaces}/100 {string.Empty}"));

				if (payCheck.PaymentMethod == EmployeePaymentMethod.Check)
				{
					var micr = "00000000";
					micr =
						micr.Substring(0,
							(8 - payCheck.CheckNumber.ToString().Length) < 0 ? 0 : 8 - payCheck.CheckNumber.ToString().Length) +
						payCheck.CheckNumber.ToString();
					var micrVal =
                        $"C{micr}C A{bankcoa.BankAccount.RoutingNumber}A {bankcoa.BankAccount.AccountNumber}C";
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("MICR", micrVal));
				}

			}

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Memo",
                $"Pay Period {payCheck.StartDate.ToString("d")}-{payCheck.EndDate.ToString("d")}"));
			var caption8 =
                $"****-**-{payCheck.Employee.SSN.Substring(payCheck.Employee.SSN.Length - 4)}                                                {"Employee No:"} {(payCheck.Employee.CompanyEmployeeNo.HasValue ? payCheck.Employee.CompanyEmployeeNo.Value.ToString() : string.Empty)}";
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Caption8", caption8));
			pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CompName", nameCompany.Name));

			if (payroll.Company.PayCheckStock != PayCheckStock.MICRQb)
			{
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo-2",
					payCheck.PaymentMethod != EmployeePaymentMethod.Check ? "EFT" : payCheck.CheckNumber.ToString()));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compAddress", nameCompany.CompanyAddress.AddressLine1));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compCity", nameCompany.CompanyAddress.AddressLine2));

				var sum2 =
                    $"Federal Status: {payCheck.Employee.FederalStatus.GetDbName()}{"".PadRight(57 - payCheck.Employee.FederalStatus.GetDbName().Length)}Federal Exemptions: {payCheck.Employee.FederalExemptions}{"".PadRight(66 - payCheck.Employee.FederalAdditionalAmount.ToString("C").Length)}Additional Fed Withholding: {payCheck.Employee.FederalAdditionalAmount.ToString("C")}";
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum2", sum2));

				var text8 =
                    $"State Status:    {payCheck.Employee.State.TaxStatus.GetDbName()}{"".PadRight(57 - payCheck.Employee.State.TaxStatus.GetDbName().Length)}State Exemptions:    {payCheck.Employee.State.Exemptions}{"".PadRight(66 - payCheck.Employee.State.AdditionalAmount.ToString("C").Length)}Additional State Withholding: {payCheck.Employee.State.AdditionalAmount.ToString("C")}";
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text8", text8));
			}
			else
			{
				var sum2 =
                    $"Federal Status: {payCheck.Employee.FederalStatus.GetDbName()}      Federal Exemptions: {payCheck.Employee.FederalExemptions}      Additional Fed Withholding: {payCheck.Employee.FederalAdditionalAmount.ToString("C")}";


				var text8 =
                    $"State Status: {payCheck.Employee.State.TaxStatus.GetDbName()}      State Exemptions: {payCheck.Employee.State.Exemptions}      Additional State Withholding: {payCheck.Employee.State.AdditionalAmount.ToString("C")}";

				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum2", sum2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text8", text8));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum2-1", sum2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text8-1", text8));


				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName2-1", payCheck.Employee.FullName));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum1-1",
                    $"Pay Period {payCheck.StartDate.ToString("d")} - {payCheck.EndDate.ToString("d")}"));
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
									payCode.AppliedRate.ToString("C")));
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
									(payCode.AppliedOverTimeRate).ToString("C")));
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
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pcomp" + compCounter1 + "-1",
                            $"{compensation.PayType.Description}{(compensation.Hours > 0 ? " - " + compensation.Hours.ToString() + " hrs" : string.Empty)}"));
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
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("r-" + hrcounter, payCode.AppliedRate.ToString("C")));
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
								(payCode.AppliedOverTimeRate).ToString("C")));
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
				
			}
			//if (payCheck.Employee.PayType == EmployeeType.PieceWork)
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum3-1", !string.IsNullOrWhiteSpace(payCheck.Notes) ? payCheck.Notes : string.Empty));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum3", !string.IsNullOrWhiteSpace(payCheck.Notes) ? payCheck.Notes : string.Empty));
			}
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum1",
                $"Pay Period {payCheck.StartDate.ToString("d")} - {payCheck.EndDate.ToString("d")}"));
			var compCounter = 1;
			foreach (var compensation in payCheck.Compensations.Where(compensation => compensation.Amount > 0 || compensation.YTD > 0))
			{
				if (payCheck.Employee.PayType == EmployeeType.PieceWork && (compensation.PayType.Id == 6 || compensation.PayType.Id == 13))
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pcomp" + compCounter,
                        $"{compensation.PayType.Description}{(compensation.Hours > 0 ? " - " + compensation.Hours.ToString() + " hrs" : string.Empty)}"));
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
				var accumulationCounter = 1;
				payCheck.Accumulations.ForEach(scl =>
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("scltype-" + accumulationCounter,
                        $"{scl.PayType.PayType.Description} ({scl.FiscalStart.ToString("d")} - {scl.FiscalEnd.ToString("d")})"));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclhours-" + accumulationCounter, scl.Used.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclcurrent-" + accumulationCounter, scl.AccumulatedValue.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclytd-" + accumulationCounter, scl.YTDFiscal.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclused-" + accumulationCounter, scl.YTDUsed.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclco-" + accumulationCounter, scl.CarryOver.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclnet-" + accumulationCounter, (scl.Available ).ToString()));
					accumulationCounter++;
				});


			}
			
			return pdf;
		}

		private PDFModel GetPdfModelJobCost(Models.Payroll payroll, PayCheck payCheck, Models.Journal journal, Company company,
			Company nameCompany, Company company1, Account bankcoa, Document signature)
		{
			var pdf = new PDFModel
				{
					Name = string.Format("Pay Check_{1}_{2} {0}.pdf", payCheck.PayDay.ToString("MMddyyyy"), payCheck.PayrollId, payCheck.Id),
					TargetId = payCheck.Id,
					NormalFontFields = new List<KeyValuePair<string, string>>(),
					BoldFontFields = new List<KeyValuePair<string, string>>(),
					TargetType = EntityTypeEnum.PayCheck,
					Template = PayCheckStock.JobCost.GetHrMaxxName()
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
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("comp", nameCompany.Name + Environment.NewLine + nameCompany.CompanyAddress.AddressLine1 + Environment.NewLine + nameCompany.CompanyAddress.AddressLine2));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("ee", "Emp No" + Environment.NewLine + (payCheck.Employee.CompanyEmployeeNo.HasValue ? payCheck.Employee.CompanyEmployeeNo.Value.ToString() : string.Empty)));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("pp", "Period Begin                   Period End" + Environment.NewLine + payCheck.StartDate.ToString("MM/dd/yyyy") + "                     " + payCheck.EndDate.ToString("MM/dd/yyyy")));
				if (payCheck.Employee.PaymentMethod != EmployeePaymentMethod.Check)
					pdf.BoldFontFields.Add(new KeyValuePair<string, string>("dd-spec", "NON-NEGOTIABLE     DIRECT DEPOSIT"));
				else
				{
					pdf.BoldFontFields.Add(new KeyValuePair<string, string>("dd-spec", string.Empty));
				}
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("Name", company.Name));
				
				
				
				
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo1-1", payCheck.PaymentMethod != EmployeePaymentMethod.Check ? "EFT" : payCheck.CheckNumber.ToString()));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Address", nameCompany.CompanyAddress.AddressLine1));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("City", nameCompany.CompanyAddress.AddressLine2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName", payCheck.Employee.FullName));
				
				
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text1", payCheck.Employee.Contact.Address.AddressLine1));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text3", payCheck.Employee.Contact.Address.AddressLine2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date", payCheck.PayDay.ToString("MM/dd/yyyy")));
				var words = Utilities.NumberToWords(Math.Floor(payCheck.NetWage));
				var decPlaces = (int)(((decimal)payCheck.NetWage % 1) * 100);
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Amount", payCheck.NetWage.ToString("F")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("AmtInWords",
                    $"{words} {decPlaces}/100 {string.Empty}"));
				if (payCheck.PaymentMethod == EmployeePaymentMethod.Check)
				{
					var micr = "00000000";
					micr =
						micr.Substring(0,
							(8 - payCheck.CheckNumber.ToString().Length) < 0 ? 0 : 8 - payCheck.CheckNumber.ToString().Length) +
						payCheck.CheckNumber.ToString();
					var micrVal =
                        $"C{micr}C A{bankcoa.BankAccount.RoutingNumber}A {bankcoa.BankAccount.AccountNumber}C";
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("MICR", micrVal));


					
					if (signature!=null)
					{
						
						pdf.Signature = new PDFSignature
						{
							Path = _fileRepository.GetDocumentLocation(signature.Path),
							X = 375,
							Y = 325,
							ScaleX = (float)0.7,
							ScaleY = (float)0.7

						};

					}
				}
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Memo",
                    $"Pay Period {payCheck.StartDate.ToString("d")}-{payCheck.EndDate.ToString("d")}"));

				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CompName", nameCompany.Name));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo-2", payCheck.PaymentMethod != EmployeePaymentMethod.Check ? "EFT" : payCheck.CheckNumber.ToString()));
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
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + hrcounter + "-s",
                            $"Regular @ {payCode.PayCode.HourlyRate.ToString("c")}"));
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
                            $"0.5 OT @ {(payCode.PayCode.HourlyRate * (decimal) 0.5).ToString("c")}"));
						


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
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("scltype",
                        $"{scl.PayType.PayType.Description} ({scl.FiscalStart.ToString("d")} - {scl.FiscalEnd.ToString("d")})"));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclhours-1", scl.YTDUsed.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclcurrent-1", scl.AccumulatedValue.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclytd-1", scl.YTDFiscal.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclused-1", scl.YTDUsed.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclco-1", scl.CarryOver.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("sclnet-1", (scl.Available ).ToString()));
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
		private FileDto PrintPayCheck(Models.Payroll payroll, List<PayCheck> payChecks, List<Models.Journal> journals)
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
				var companyDocs = _commonService.GetDocuments(EntityTypeEnum.Company, company.Id);
				var signature = companyDocs.Where(d => d.DocumentDto.DocumentType == OldDocumentType.Signature).OrderByDescending(d => d.DocumentDto.LastModified).FirstOrDefault();
				var pdfs = new List<PDFModel>();
				foreach (var payCheck in payChecks)
				{
					if(payCheck.Employee.PayType==EmployeeType.JobCost)
						pdfs.Add(GetPdfModelJobCost(payroll, payCheck, journals.First(j=>j.PayrollPayCheckId==payCheck.Id), company, nameCompany, company1, bankcoa, signature));
					else
					{
						pdfs.Add(GetPdfModel(payroll, payCheck, journals.First(j => j.PayrollPayCheckId == payCheck.Id), company, nameCompany, company1, bankcoa, signature));
					}
					
				}
				//Log.Info(string.Format("Finished Modeling {0}", DateTime.Now.ToString("hh:mm:ss:fff")));
				var fileName = payChecks.Count == 1
					? $"Pay Check {payChecks.First().CheckNumber}"
                    : $"Payroll_{payroll.StartDate:MMddyyyy}_{payroll.EndDate:MMddyyyy}_{payroll.Id}";
				
				var file = _pdfService.Print(fileName, pdfs);
				//Log.Info(string.Format("File Ready {0}", DateTime.Now.ToString("hh:mm:ss:fff")));
				return file;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Print Pay Check By id=" + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private List<PDFModel> PrintPayrollPackPayChecks(Models.Payroll payroll, List<PayCheck> payChecks, List<Models.Journal> journals)
		{
			try
			{

				var host = _hostService.GetHost(payroll.Company.HostId);
				var company1 = _readerService.GetCompany(payroll.Company.Id);
				var coas = new List<Account>();
				if (payroll.PEOASOCoCheck)
					coas = _companyService.GetComanyAccounts(host.Company.Id);
				else
					coas = _companyService.GetComanyAccounts(payroll.Company.Id);

				var company = payroll.Company;
				if (payroll.PEOASOCoCheck)
					company = host.Company;

				var nameCompany = payroll.Company.Contract.InvoiceSetup.PrintClientName ? payroll.Company : company;

				var bankcoa = coas.First(c => c.Id == journals.First().MainAccountId);
				var companyDocs = _commonService.GetDocuments(EntityTypeEnum.Company, company.Id);
				var signature = companyDocs.Where(d => d.DocumentDto.DocumentType == OldDocumentType.Signature).OrderByDescending(d => d.DocumentDto.LastModified).FirstOrDefault();
				var pdfs = new List<PDFModel>();
				foreach (var payCheck in payChecks)
				{
					var model = new PDFModel();
					if (payCheck.Employee.PayType == EmployeeType.JobCost)
						model = GetPdfModelJobCost(payroll, payCheck, journals.First(j => j.PayrollPayCheckId == payCheck.Id), company, nameCompany, company1, bankcoa, signature);
					else
					{
						model = GetPdfModel(payroll, payCheck, journals.First(j => j.PayrollPayCheckId == payCheck.Id), company, nameCompany, company1, bankcoa, signature);
					}
					model.Name = payCheck.Employee.FullName + ".pdf";
					pdfs.Add(model);

				}
				
				return pdfs;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Print Pay Check By id=" + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private FileDto PrintPayCheckPaySlip(Models.Payroll payroll, List<PayCheck> payChecks)
		{
			try
			{

				var company = payroll.Company;
				
				var pdfs = payChecks.OrderBy(pc => pc.CheckNumber).Select(payCheck => GetPdfModelPaySlip(payroll, payCheck, company)).ToList();
				var fileName = payChecks.Count == 1
					? $"Pay Slip {payChecks.First().CheckNumber}"
                    : $"Payslips_{payroll.StartDate.ToString("MMddyyyy")}_{payroll.EndDate.ToString("MMddyyyy")}_{payroll.Id}";

				return _pdfService.Print(fileName, pdfs);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Print Pay Check By id=" + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		
		private Journal CreateJournalEntry(Models.Payroll payroll, PayCheck pc, List<Account> coaList, bool PEOASOCoCheck = false, Guid? companyId = null, int? companyIntId = null)
		{
			var bankCOA = coaList.First(c => c.UseInPayroll);
			var journal = new Journal
			{
				Id = 0,
				CompanyId = companyId.HasValue ? companyId.Value : pc.Employee.CompanyId,
				CompanyIntId = companyIntId.HasValue ? companyIntId.Value : pc.CompanyIntId,
				Amount = Math.Round(pc.NetWage, 2, MidpointRounding.AwayFromZero),
				CheckNumber = pc.PaymentMethod == EmployeePaymentMethod.Check ? pc.CheckNumber.Value : -1,
				EntityType = EntityTypeEnum.Employee,
				PayeeId = pc.Employee.Id,
				IsDebit = true,
				IsVoid = false,
				LastModified = DateTime.Now,
				LastModifiedBy = payroll.UserName,
				Memo = $"Pay Period {pc.StartDate.ToString("d")} - {pc.EndDate.ToString("d")}",
				PaymentMethod = pc.PaymentMethod,
				PayrollPayCheckId = pc.Id,
				TransactionDate = pc.PayDay,
				TransactionType = TransactionType.PayCheck,
				PayeeName = pc.Employee.FullName,
				MainAccountId = bankCOA.Id,
				JournalDetails = new List<JournalDetail>(),
				DocumentId =  Guid.Empty,
				PEOASOCoCheck = PEOASOCoCheck,
				PayrollId = payroll.Id,
				IsCleared = pc.PaymentMethod == EmployeePaymentMethod.DirectDebit,
				ClearedBy = pc.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "System" : string.Empty,
				ClearedOn = pc.PaymentMethod == EmployeePaymentMethod.DirectDebit ? DateTime.Now : default(DateTime?),
			};
			//bank account debit
			

			journal.JournalDetails.Add(new JournalDetail{ AccountId = bankCOA.Id, AccountName= bankCOA.AccountName, IsDebit = true, Amount = pc.NetWage, LastModfied = journal.LastModified, LastModifiedBy = payroll.UserName});
			journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "PAYROLL_EXPENSES").Id, AccountName = coaList.First(c => c.TaxCode == "PAYROLL_EXPENSES").AccountName, IsDebit = false, Amount = pc.NetWage, LastModfied = journal.LastModified, LastModifiedBy = payroll.UserName });
			pc.Taxes.ForEach(t => journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == t.Tax.Code).Id, AccountName = coaList.First(c => c.TaxCode == t.Tax.Code).AccountName, IsDebit = false, Amount = t.Amount, LastModifiedBy = payroll.UserName, LastModfied = journal.LastModified }));
			if(pc.CompensationNonTaxableAmount>0)
				journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "MOE").Id, AccountName = coaList.First(c => c.TaxCode == "MOE").AccountName, IsDebit = false, Amount = pc.CompensationNonTaxableAmount, LastModfied = journal.LastModified, LastModifiedBy = payroll.UserName });
			if (pc.DeductionAmount > 0)
			{
				journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "ED").Id, AccountName = coaList.First(c => c.TaxCode == "ED").AccountName, IsDebit = false, Amount = pc.DeductionAmount, LastModfied = journal.LastModified, LastModifiedBy = payroll.UserName });
				journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "PD").Id, AccountName = coaList.First(c => c.TaxCode == "PD").AccountName, IsDebit = false, Amount = pc.DeductionAmount, LastModfied = journal.LastModified, LastModifiedBy = payroll.UserName });
			}
			journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "TP").Id, AccountName = coaList.First(c => c.TaxCode == "TP").AccountName, IsDebit = false, Amount = Math.Round(pc.EmployeeTaxes + pc.EmployerTaxes, 2, MidpointRounding.AwayFromZero), LastModfied = journal.LastModified, LastModifiedBy = payroll.UserName });
			return journal; //_journalService.SaveJournalForPayroll(journal, payroll.Company);
		}
			
		public PayrollInvoice DelayTaxes(Guid invoiceId, string fullName)
		{
			try
			{
				var invoice = _readerService.GetPayrollInvoice(invoiceId);
				invoice.TaxesDelayed = true;
				invoice.LastModified = DateTime.Now;
				invoice.UserName = fullName;
				_payrollRepository.DelayPayrollInvoice(invoice.Id, invoice.TaxesDelayed, invoice.LastModified, invoice.UserName);
				
				_commonService.AddToList(EntityTypeEnum.Company, EntityTypeEnum.Comment, invoice.CompanyId, new Comment
				{
					Content = $"Invoice #{invoice.InvoiceNumber} has been marked as Taxes Delayed", LastModified = invoice.LastModified, UserName = fullName, TimeStamp = DateTime.Now
				});
				return invoice;
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
					invoice.TaxesDelayed = false;
					invoice.LastModified = DateTime.Now;

					_payrollRepository.DelayPayrollInvoice(invoice.Id, invoice.TaxesDelayed, invoice.LastModified, invoice.UserName);
					
					_commonService.AddToList(EntityTypeEnum.Company, EntityTypeEnum.Comment, invoice.CompanyId, new Comment
					{
						Content = string.Format("Invoice #{1} and related Payroll and Paychecks have been re-dated to {0}", invoice.InvoiceDate.ToString("MM/dd/yyyy"), invoice.InvoiceNumber),
						LastModified = invoice.LastModified,
						UserName = invoice.UserName,
						TimeStamp = DateTime.Now
					});
					
					_payrollRepository.UpdatePayrollPayDay(invoice.PayrollId, invoice.PayChecks, invoice.InvoiceDate);
					
					txn.Complete();
					
					return invoice;
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Redate invoice id=" + invoice.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}


		public Company Copy(Guid companyId, Guid hostId, bool copyEmployees, bool copyPayrolls, DateTime? startDate, DateTime? endDate, string fullName, Guid userId, bool keepEmployeeNumbers)
		{
			try
			{
				var company = _readerService.GetCompany(companyId);
				company.Id = CombGuid.Generate();
				var employees = _readerService.GetEmployees(company: company.Id);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var saved = _companyRepository.CopyCompany(companyId, company.Id, company.HostId, hostId, copyEmployees, copyPayrolls, startDate, endDate, fullName);
					if (copyEmployees)
					{
						_companyRepository.CopyEmployees(companyId, company.Id, new List<Guid>(), fullName, keepEmployeeNumbers );
						employees.Where(e => e.PayCodes.Any()).ToList().ForEach(e =>
						{
							e.PayCodes.ForEach(pc =>
							{
								if (pc.Id > 0)
									pc.Id = saved.PayCodes.First(pc1 => pc1.Code.Equals(pc.Code)).Id;
								pc.CompanyId = saved.Id;
							});
							_companyService.SaveEmployee(e, false);

						});
					}
					_commonService.AddToList(EntityTypeEnum.Company, EntityTypeEnum.Comment, saved.Id, new Comment
					{
						Content =
                            $"Company {saved.Name} copied from another host with Copy Employees={(copyEmployees ? "Yes" : "No")}, Copy Payrolls={(copyPayrolls ? "Yes" : "No")}",
						LastModified = DateTime.Now,
						UserName = fullName
					});
					_commonService.AddToList(EntityTypeEnum.Company, EntityTypeEnum.Comment, saved.Id, new Comment
					{
						Content =
                            $"Company {company.Name} copied to another host with Copy Employees={(copyEmployees ? "Yes" : "No")}, Copy Payrolls={(copyPayrolls ? "Yes" : "No")}",
						LastModified = DateTime.Now,
						UserName = fullName
					});
					txn.Complete();
					Bus.Publish<CompanyUpdatedEvent>(new CompanyUpdatedEvent
					{
						SavedObject = saved,
						UserId = userId,
						TimeStamp = DateTime.Now,
						NotificationText = $"{$"Company {saved.Name} has been copied"} by {fullName}",
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
		public Employee RecalculateEmployeePayTypeAccumulation(Guid employeeId, string user, string userId)
		{
			try
			{
				var employee = _readerService.GetEmployee(employeeId);
				var company = _readerService.GetCompany(employee.CompanyId);
				var payChecks = _readerService.GetEmployeePayChecks(employeeId).OrderBy(p=>p.PayDay);
				
				using (var txn = TransactionScopeHelper.Transaction())
				{

					foreach (var payCheck in payChecks)
					{
						var employeeAccumulations = _readerService.GetAccumulations(company: company.Id,
							startdate: new DateTime(payCheck.PayDay.Year, 1, 1), enddate: payCheck.PayDay, ssns: Crypto.Encrypt(payCheck.Employee.SSN));
						payCheck.Employee.HireDate = employee.HireDate;
						payCheck.Employee.SickLeaveHireDate = employee.SickLeaveHireDate;
						payCheck.Employee.CarryOver = employee.CarryOver;
						payCheck.Accumulations = ProcessAccumulations(payCheck, employeeAccumulations.First(), company);
						_payrollRepository.UpdatePayCheckSickLeaveAccumulation(payCheck);
						var memento = Memento<PayCheck>.Create(payCheck, EntityTypeEnum.PayCheck, user, "Pay Type Accumulation Updated", new Guid(userId));
						_mementoDataService.AddMementoData(memento);
						
					}
					txn.Complete();
				}
				return _readerService.GetEmployees(company:company.Id).First(e=>e.Id==employeeId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " recalculate employee paytype accumulations");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void FixEmployeeYTD(Guid employeeId)
		{
			try
			{
				var updateList = new List<PayCheck>();
				var originalList = new List<PayCheck>();
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					var employee = _readerService.GetEmployee(employeeId);
					var paychecks = _readerService.GetEmployeePayChecks(employeeId);
					
					paychecks.OrderBy(pc=>pc.PayDay).ToList().ForEach(pc => {
						var employeeAccumulation = _readerService.GetAccumulations(company: employee.CompanyId,
						startdate: new DateTime(pc.PayDay.Year, 1, 1), enddate: pc.PayDay, ssns:Crypto.Encrypt(employee.SSN));
						var ea = employeeAccumulation.First(e => e.EmployeeId.Value == pc.Employee.Id);
						pc.PayCodes.ForEach(p =>
							{
								var p2 = ea.PayCodes.First(p3 => p3.PayCodeId == p.PayCode.Id);
								p.YTD = p2.YTDAmount;
								p.YTDOvertime = p2.YTDOvertime;
							});
						pc.Taxes.ForEach(t =>
						{
							var t2 = ea.Taxes.First(t3 => t3.Tax.Code.Equals(t.Tax.Code));
							t.YTDTax = t2.YTD;
							t.YTDWage = t2.YTDWage;
						});
						pc.Deductions.ForEach(d =>
						{
							var d2 = ea.Deductions.First(d3 => d3.CompanyDeductionId == d.Deduction.Id);
							d.YTD = d2.YTD;
							d.YTDWage = d2.YTDWage;
                            d.YTDEmployer = d2.YTDEmployer;
                        });
						pc.Compensations.ForEach(c =>
						{
							var c2 = ea.Compensations.First(c3 => c3.PayTypeId == c.PayType.Id);
							c.YTD = c2.YTD;
						});
						
						if (pc.WorkerCompensation != null)
							pc.WorkerCompensation.YTD =
								ea.WorkerCompensations.Where(w2 => w2.WorkerCompensationId == pc.WorkerCompensation.WorkerCompensation.Id)
									.Sum(w2 => w2.YTD);

						pc.YTDGrossWage = ea.PayCheckWages.GrossWage;
						pc.YTDNetWage = ea.PayCheckWages.NetWage;
						pc.YTDSalary = ea.PayCheckWages.Salary;
						updateList.Add(pc);
					});
						

					
					if (updateList.Any())
					{
						updateList.ForEach(pc => _payrollRepository.UpdatePayCheckYTD(pc));
						
						txn.Complete();
						
					}




				}
			}
			catch (Exception e)
			{
				var message = $"Error in fixing YTD for Payroll {employeeId}.";
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		
		}

		public int FillPayCheckNormalized(Guid? companyId, Guid? payrollId)
		{
			try
			{
				var payChecks = _readerService.GetPayChecks(companyId:companyId, payrollId: payrollId);
				var ptaccums = new List<PayCheckPayTypeAccumulation>();
				var pttaxes = new List<PayCheckTax>();
				var ptcomps = new List<PayCheckCompensation>();
				var ptdeds = new List<PayCheckDeduction>();
				var ptcodes = new List<PayCheckPayCode>();
				var ptwcs = new List<PayCheckWorkerCompensation>();
				payChecks.ForEach(pc => pc.Accumulations.ForEach(a =>
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
				}));
				payChecks.ForEach(pc => pc.Taxes.ForEach(t =>
				{
					var pt = new PayCheckTax()
					{
						PayCheckId = pc.Id,
						TaxId = t.Tax.Id,
						TaxableWage = t.TaxableWage,
						Amount = t.Amount
					};
					pttaxes.Add(pt);
				}));
				payChecks.ForEach(pc => pc.Compensations.ForEach(t =>
				{
					var pt = new PayCheckCompensation()
					{
						PayCheckId = pc.Id,
						PayTypeId = t.PayType.Id,
						Amount = t.Amount
					};
					ptcomps.Add(pt);
				}));
				payChecks.ForEach(pc => pc.Deductions.ForEach(t =>
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
				}));
				payChecks.ForEach(pc => pc.PayCodes.ForEach(t =>
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
				}));
				payChecks.Where(pc => pc.WorkerCompensation != null && pc.WorkerCompensation.WorkerCompensation != null).ToList().ForEach(pc =>
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
				});
				SavePayCheckWorkerCompensation(ptwcs);
				SavePayCheckPayCodes(ptcodes);
				SavePayCheckDeductions(ptdeds);
				SavePayCheckCompensations(ptcomps);
				SavePayCheckTaxes(pttaxes);
				SavePayCheckPayTypeAccumulations(ptaccums);
				return payChecks.Count;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Normalize PayChecks for " + companyId + " payrollId " + payrollId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void UpdateCompanyAndEmployeeLastPayrollDate()
		{
			try
			{
				_payrollRepository.UpdateCompanyAndEmployeeLastPayrollDate();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " update company and employee last payroll dates ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void UpdatePayCheckAccumulation(int payCheckId, PayTypeAccumulation accumulation, string user, string userId)
		{
			try
			{
				var payCheck = _readerService.GetPaycheck(payCheckId);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					
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
						InvoiceSummaries = Mapper.Map<List<PayrollInvoice>, List<InvoiceSummaryForDelivery>>(invoices)
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

		public Models.Payroll DeleteDraftPayroll(Models.Payroll payroll)
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

		public List<InvoiceDeliveryClaim> GetInvoiceDeliveryClaims(DateTime? startDate, DateTime? endDate)
		{
			try
			{
				return _payrollRepository.GetInvoiceDeliveryClaims(startDate, endDate);
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
			var strLog = new StringBuilder();
			try
			{
				var payrolls = _readerService.GetPayrolls(null);
				var invoices = _readerService.GetPayrollInvoices(Guid.Empty);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					
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
						
						_payrollRepository.SavePayrollInvoice(i, ref strLog);
					});
					txn.Complete();
					return invoiceList;
				}
			}
			catch (Exception e)
			{
				Log.Info(strLog.ToString());
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " fix invoice data ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void MovePayrolls(Guid source, Guid target, Guid userId, string user, bool moveAll, List<Guid> payrollsToCopy, bool ashistory)
		{
			try
			{
				var payrolls = _readerService.GetPayrolls(companyId: source, excludeVoids:1);
				payrolls = payrolls.Where(p => !p.IsHistory && (!p.InvoiceId.HasValue || (int)p.InvoiceStatus < 4)).ToList();
				if (!moveAll && payrollsToCopy.Any())
				{
					payrolls = payrolls.Where(p => payrollsToCopy.Contains(p.Id)).ToList();
				}

				try
				{
					_companyService.CopyEmployees(source, target, new List<Guid>(), user, true);
				}
				catch (Exception)
				{

				}

				var sourceCompany = _readerService.GetCompany(source);
				var targetCompany = _readerService.GetCompany(target);

				var targetEmployees = _readerService.GetEmployees(company: target);


				var Originals = new List<Models.Payroll>();
				using (var txn = TransactionScopeHelper.Transaction())
				{

					payrolls.OrderBy(p => p.LastModified).ToList().ForEach(payroll =>
					{
						Originals.Add(Utilities.GetCopy(payroll));
						payroll.IsHistory = ashistory || payroll.IsHistory;
						payroll.MovedFrom = source;
						payroll.Id = CombGuid.Generate();
						payroll.Company = targetCompany;
						payroll.UserId = userId;
						payroll.UserName = user;
						payroll.PayChecks.ForEach(paycheck =>
						{
							paycheck.IsHistory = payroll.IsHistory;
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
							paycheck.Accumulations.ForEach(a => a.PayType.CompanyId = target);

						}

						);
						payroll = ProcessPayroll(payroll);
						payroll = ConfirmPayroll(payroll);

					});

					Originals.ForEach(p => VoidPayroll(p, user, userId.ToString(), true));
					txn.Complete();
				}
			}
			catch (Exception e)
			{
				var message = string.Format("Failed to migrate payrolls during copy. ");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void CopyPayrolls(Guid source, Guid target, Guid userId, string user, bool moveAll, List<Guid> payrollsToCopy, bool ashistory)
		{
			try
			{
				var payrolls = _readerService.GetPayrolls(companyId: source, excludeVoids: 1);
				payrolls = payrolls.Where(p => !p.IsHistory && (!p.InvoiceId.HasValue || (int)p.InvoiceStatus < 4)).ToList();
				if (!moveAll && payrollsToCopy.Any())
				{
					payrolls = payrolls.Where(p => payrollsToCopy.Contains(p.Id)).ToList();
				}
				try
				{
					_companyService.CopyEmployees(source, target, new List<Guid>(), user, true);
				}
				catch (Exception)
				{

				}

				var targetCompany = _readerService.GetCompany(target);
				
				var targetHost = _hostService.GetHost(targetCompany.HostId);
				var sourceEmployees = _readerService.GetEmployees(company: source);
				var targetEmployees = _readerService.GetEmployees(company: target);
				
				var targetCOA = _companyRepository.GetCompanyAccounts(target);
				
				var targetHostCOA = _companyRepository.GetCompanyAccounts(targetHost.Company.Id);
				
				using (var txn = TransactionScopeHelper.Transaction())
				{
					//_payrollRepository.DeleteAllPayrolls(target);
					payrolls.OrderBy(p => p.LastModified).ToList().ForEach(payroll =>
					{
						payroll.IsHistory = ashistory || payroll.IsHistory;
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
						payroll = ProcessPayroll(payroll);
						payroll = ConfirmPayroll(payroll);
						//Log.Info("Save Payroll starting: " + DateTime.Now.ToString("fff"));
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

		public void SaveClaimDelivery(InvoiceDeliveryClaim claim)
		{
			try
			{
				_payrollRepository.UpdateInvoiceDeliveryData(new List<InvoiceDeliveryClaim>{claim});
			}
			catch (Exception e)
			{
				var message = string.Format("Failed to copy payrolls");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public PayCheckPayTypeAccumulation UpdateEmployeeAccumulation(PayCheckPayTypeAccumulation mapped, DateTime newFiscalStart, DateTime newFiscalEnd, Guid employeeId)
		{
			try
			{
				var payChecks = _readerService.GetPayChecks(employeeId: employeeId);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					payChecks.Where(pc => pc.Accumulations != null && pc.Accumulations.Any(ac => ac.PayType.PayType.Id==mapped.PayTypeId && ac.FiscalStart.Date == mapped.FiscalStart.Date && ac.FiscalEnd.Date == mapped.FiscalEnd.Date)).ToList().ForEach(
						pc =>
						{
							pc.Accumulations.Where(ac => ac.PayType.PayType.Id == mapped.PayTypeId && ac.FiscalStart.Date == mapped.FiscalStart.Date && ac.FiscalEnd.Date == mapped.FiscalEnd.Date).ToList().ForEach(
								ac =>
								{
									ac.FiscalStart = newFiscalStart;
									ac.FiscalEnd = newFiscalEnd;
									ac.CarryOver = mapped.CarryOver;
								});
							_payrollRepository.UpdatePayCheckSickLeaveAccumulation(pc);
						});
					mapped.FiscalStart = newFiscalStart;
					mapped.FiscalEnd = newFiscalEnd;
					txn.Complete();
				}
				return mapped;

			}
			catch (Exception e)
			{
				var message = string.Format("Failed to update employee accumulations");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}

		}
		public void RemoveAllPreviousAccumulations(List<PayCheckPayTypeAccumulation> previouos, PayCheckPayTypeAccumulation current, Employee employee)
		{
			try
			{
				var payChecks = _readerService.GetPayChecks(employeeId: employee.Id);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					if (current != null)
					{
						payChecks.Where(pc => pc.Accumulations != null && pc.Accumulations.Any(ac => ac.PayType.PayType.Id == current.PayTypeId && ac.FiscalStart.Date == current.FiscalStart.Date && ac.FiscalEnd.Date == current.FiscalEnd.Date)).ToList().ForEach(
						pc =>
						{
							pc.Accumulations.Where(ac => ac.PayType.PayType.Id == current.PayTypeId && ac.FiscalStart.Date == current.FiscalStart.Date && ac.FiscalEnd.Date == current.FiscalEnd.Date).ToList().ForEach(
								ac =>
								{
									ac.CarryOver = 0;
								});
							_payrollRepository.UpdatePayCheckSickLeaveAccumulation(pc);
						});
					}
					
					if (previouos != null)
					{
						payChecks.Where(pc => pc.Accumulations != null && pc.Accumulations.Any(ac => ac.PayType.PayType.Id == 6 && previouos.Any(pa => pa.FiscalStart.Date == ac.FiscalStart.Date && pa.FiscalEnd.Date == ac.FiscalEnd.Date))).ToList().ForEach(
												pc =>
												{
													pc.Accumulations.Where(ac => ac.PayType.PayType.Id == 6 && previouos.Any(pa => pa.FiscalStart.Date == ac.FiscalStart.Date && pa.FiscalEnd.Date == ac.FiscalEnd.Date)).ToList().ForEach(
														ac =>
														{
															ac.CarryOver = 0;
															ac.AccumulatedValue = 0;
															ac.Used = 0;
															ac.YTDFiscal = 0;
															ac.YTDUsed = 0;															
														});
													_payrollRepository.UpdatePayCheckSickLeaveAccumulation(pc);
												});
					}
					
					employee.CarryOver = 0;
					employee.SickLeaveCashPaidHours = 0;
					_companyService.SaveEmployee(employee, false, false);
					txn.Complete();
				}
				

			}
			catch (Exception e)
			{
				var message = string.Format("Failed to update employee accumulations");
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
					Log.Info("Delete startded" + DateTime.Now.ToString("hh:mm:ss:fff"));
					_payrollRepository.DeletePayroll(payroll);
					payroll.PayChecks.ForEach(pc =>
					{
						_fileRepository.DeleteArchiveDirectory(ArchiveTypes.Mementos.GetDbName(), EntityTypeEnum.PayCheck.GetDbName(),
                            $"{((int) EntityTypeEnum.PayCheck).ToString().PadLeft(8, '0')}-0000-0000-0000-{pc.Id.ToString().PadLeft(12, '0')}");
					});
					Log.Info("delete ended" + DateTime.Now.ToString("hh:mm:ss:fff"));
					_taxationService.RefreshPEOMaxCheckNumber();
					txn.Complete();
					
					return payroll;	
				}
					
				
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX,e.Message);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Models.Payroll UpdatePayrollCheckNumbers(Models.Payroll payroll)
		{
			try
			{
				var canUpdate = _payrollRepository.CanUpdateCheckNumbers(payroll.Id, payroll.StartingCheckNumber,
					payroll.PayChecks.Count);
				if (!canUpdate)
				{
					throw new Exception();
				}
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var counter = payroll.StartingCheckNumber;
					payroll.PayChecks.OrderBy(pc => pc.CheckNumber).ToList().ForEach(pc =>
					{
						pc.CheckNumber = counter++;
					});
					_payrollRepository.UpdatePayrollCheckNumbers(payroll);
					
					txn.Complete();
					
					return payroll;
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format("Check numbers cannot be updated on this payroll as they are being used.");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void FixPayrollYTD(Guid payrollId)
		{
			try
			{
				var updateList = new List<PayCheck>();
				var originalList = new List<PayCheck>();
				using (var txn = TransactionScopeHelper.TransactionNoTimeout())
				{
					
						var payroll = _readerService.GetPayroll(payrollId);
						var employeeAccumulations = _readerService.GetAccumulations(company: payroll.Company.Id,
						startdate: new DateTime(payroll.PayDay.Year, 1, 1), enddate: payroll.PayDay);
						
						payroll.PayChecks.Where(pc => !pc.IsVoid).ToList().ForEach(pc =>
						{
							var update = false;
							originalList.Add(JsonConvert.DeserializeObject<PayCheck>(JsonConvert.SerializeObject(pc)));
							var ea = employeeAccumulations.First(e => e.EmployeeId.Value == pc.Employee.Id);
							pc.Taxes.ForEach(t =>
							{
								var t2 = ea.Taxes.First(t3 => t3.Tax.Code.Equals(t.Tax.Code));
								if(t.YTDTax!=t2.YTD || t.YTDWage != t2.YTDWage)
								{
									t.YTDTax = t2.YTD;
									t.YTDWage = t2.YTDWage;
									update = true;
								}
								
							});
							pc.Deductions.ForEach(d =>
							{
								var d2 = ea.Deductions.First(d3 => d3.CompanyDeductionId == d.Deduction.Id);
								if (d.YTD!=d2.YTD || d.YTDWage!=d2.YTDWage || d.YTDEmployer!=d2.YTDEmployer)
								{
									d.YTD = d2.YTD;
									d.YTDWage = d2.YTDWage;
									d.YTDEmployer = d2.YTDEmployer;
									update = true;
								}
								
                            });
							pc.Compensations.ForEach(c =>
							{
								var c2 = ea.Compensations.First(c3 => c3.PayTypeId == c.PayType.Id);
								if (c.YTD != c2.YTD)
								{
									c.YTD = c2.YTD;
									update = true;
								}
								
							});
							pc.Accumulations.ForEach(a =>
							{
								var a2 = ea.Accumulations.First(a3 => a3.PayTypeId == a.PayType.PayType.Id);
								if(a.YTDFiscal!=a2.YTDFiscal || a.YTDUsed != a2.YTDUsed)
								{
									a.YTDFiscal = a2.YTDFiscal;
									a.YTDUsed = a2.YTDUsed;
									update = true;
								}
								
							});
							pc.PayCodes.ForEach(p =>
							{
								var p2 = ea.PayCodes.FirstOrDefault(p3 => p3.PayCodeId == p.PayCode.Id);
								if (p2 != null)
								{
									if(p.YTD!=p2.YTDAmount || p.YTDOvertime != p2.YTDOvertime)
									{
										p.YTD = p2.YTDAmount;
										p.YTDOvertime = p2.YTDOvertime;
										update = true;
									}
									
								}
								else
								{
									Log.Info($"{pc.EmployeeId}-{pc.Id}-{p.PayCode.Id}");
								}
								
							});
							if (pc.WorkerCompensation != null)
							{
								var w3 = ea.WorkerCompensations.Where(w2 => w2.WorkerCompensationId == pc.WorkerCompensation.WorkerCompensation.Id).Sum(w2 => w2.YTD);
								if (pc.WorkerCompensation.YTD != w3)
								{
									pc.WorkerCompensation.YTD = w3;
									update = true;
								}
								
							}
								
							if(pc.YTDGrossWage!=ea.PayCheckWages.GrossWage || pc.YTDNetWage!=ea.PayCheckWages.NetWage || pc.YTDSalary != ea.PayCheckWages.Salary)
							{
								pc.YTDGrossWage = ea.PayCheckWages.GrossWage;
								pc.YTDNetWage = ea.PayCheckWages.NetWage;
								pc.YTDSalary = ea.PayCheckWages.Salary;
								update = true;
							}
							
							if(update)
								updateList.Add(pc);

							
						});

					
					if (updateList.Any())
					{
						updateList.ForEach(pc => _payrollRepository.UpdatePayCheckYTD(pc));
						
						txn.Complete();
						
					}
					else
					{
						Log.Info($"Pay Checks are fine {payrollId}");
					}




				}
			}
			catch (Exception e)
			{
				var message = $"Error in fixing YTD for Payroll {payrollId}.";
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Models.Payroll ReQueuePayroll(Models.Payroll payroll)
		{
			
			var journals = new List<Journal>();
			var peoJournals = new List<Journal>();
			
			try
			{
				


				var companyIdForPayrollAccount = payroll.Company.Id;
				var coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
				Models.Host host = null;
				if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice &&
							payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
				{
					host = _hostService.GetHost(payroll.Company.HostId);
					payroll.HostCompanyId = host.Company.Id;
				}

				
					
					payroll.PayChecks.OrderBy(pc => pc.Employee.CompanyEmployeeNo).ToList().ForEach(pc => journals.Add(CreateJournalEntry(payroll, pc, coaList)));

					
					//PEO/ASO Co Check


					if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice &&
							payroll.Company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck)
					{

						companyIdForPayrollAccount = host.Company.Id;
						coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
						payroll.PayChecks
							.OrderBy(pc => pc.Employee.CompanyEmployeeNo).ToList()
							.ForEach(pc => peoJournals.Add(CreateJournalEntry(payroll, pc, coaList, true, companyIdForPayrollAccount, host.Company.CompanyIntId)));

					}



				
			
				payroll.QueuePosition = _taxationService.AddToConfirmPayrollQueue(new ConfirmPayrollLogItem()
				{
					PayrollId = payroll.Id,
					CompanyId = payroll.Company.Id,
					CompanyIntId = payroll.CompanyIntId,
					QueuedTime = DateTime.Now
				});
				Bus.Publish<ConfirmPayrollEvent>(new ConfirmPayrollEvent()
				{
					Payroll = payroll,
					Journals = journals,
					PeoJournals = peoJournals
				});
				return payroll;

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Re-queue Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}

		}

		public void MarkPayrollPrinted(Guid payrollId)
		{
			_payrollRepository.MarkPayrollPrinted(payrollId);
		}

		public void UpdateLastPayrollDateAndPayRateEmployee(List<PayCheck> payChecks)
		{
			try
			{
				if (payChecks.Any())
				{
					_payrollRepository.UpdateLastPayrollDateAndPayRateEmployee(payChecks);
					payChecks.ForEach(pc =>
					{
						var memento = Memento<Employee>.Create(pc.Employee, EntityTypeEnum.Employee, "System", "Employee Rate updated through payroll", Guid.Empty);
						_mementoDataService.AddMementoData(memento, true);
					});
				}
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Re-queue Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public List<SchedulePayroll> SaveSchedulePayroll(SchedulePayroll payroll)
		{
			try
			{
				_payrollRepository.SaveScheduledPayroll(payroll);
				return _readerService.GetQueryData<ScheduledPayrollJson, SchedulePayroll>($"select * from ScheduledPayroll where CompanyId='{payroll.CompanyId}'");
			}
			catch(Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Scheduled Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public SchedulePayroll DeleteSchedulePayroll(SchedulePayroll payroll)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					
					_payrollRepository.DeleteSchedulePayroll(payroll);
					
					
					txn.Complete();

					return payroll;
				}



			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, e.Message);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}
}

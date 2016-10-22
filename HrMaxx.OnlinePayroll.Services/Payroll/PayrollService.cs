﻿using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
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
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using Magnum;
using Magnum.Extensions;

namespace HrMaxx.OnlinePayroll.Services.Payroll
{
	public class PayrollService : BaseService, IPayrollService
	{
		private readonly IPayrollRepository _payrollRepository;
		private readonly ITaxationService _taxationService;
		private readonly ICompanyService _companyService;
		private readonly IJournalService _journalService;
		private readonly IPDFService _pdfService;
		private readonly IFileRepository _fileRepository;
		private readonly IHostService _hostService;
		private readonly IReportService _reportService;
		private readonly ICommonService _commonService;
		public IBus Bus { get; set; }

		public PayrollService(IPayrollRepository payrollRepository, ITaxationService taxationService, ICompanyService companyService, IJournalService journalService, IPDFService pdfService, IFileRepository fileRepository, IHostService hostService, IReportService reportService, ICommonService commonService)
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
		}



		public List<Models.Payroll> GetCompanyPayrolls(Guid companyId, DateTime? startDate, DateTime? endDate)
		{
			try
			{

				return _payrollRepository.GetCompanyPayrolls(companyId, startDate, endDate);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get List of Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Models.Payroll ProcessPayroll(Models.Payroll payroll)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{

					var companyPayChecks = _payrollRepository.GetPayChecksTillPayDay(payroll.PayDay);
					var payCheckCount = 0;
					foreach (var paycheck in payroll.PayChecks)
					{
						var employeePayChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id).ToList();
						if (paycheck.Employee.PayType == EmployeeType.Hourly)
						{
							paycheck.Salary = 0;
							
						}
						else if (paycheck.Employee.PayType == EmployeeType.Salary)
						{
							paycheck.Salary = Math.Round(paycheck.Salary, 2, MidpointRounding.AwayFromZero);
							paycheck.PayCodes = new List<PayrollPayCode>();
						}
						else
						{
							var pc = paycheck.PayCodes[0];
							paycheck.Notes.Add(new Comment
							{
								Content = string.Format("{0} piece @ {1} Reg Hr {2} OT Hr", pc.PWAmount.ToString("c"), pc.Hours.ToString("##.00"), pc.OvertimeHours.ToString("##.00"))
							});
							if ((pc.PWAmount/(pc.Hours + pc.OvertimeHours)) < 10)
							{
								pc.PayCode.HourlyRate = 10;
							}
							else
							{
								pc.PayCode.HourlyRate = Math.Round(pc.PWAmount/(pc.Hours + pc.OvertimeHours), 2, MidpointRounding.AwayFromZero);
							}
						}
						paycheck.PayCodes = ProcessPayCodes(paycheck.PayCodes, employeePayChecks);
						paycheck.YTDSalary = Math.Round(employeePayChecks.Sum(p => p.Salary) + paycheck.Salary, 2, MidpointRounding.AwayFromZero);
						
						var grossWage = GetGrossWage(paycheck);
						paycheck.Compensations = ProcessCompensations(paycheck.Compensations, employeePayChecks);
						paycheck.Accumulations = ProcessAccumulations(paycheck, payroll.Company.AccumulatedPayTypes);
						grossWage = Math.Round(grossWage + paycheck.CompensationTaxableAmount, 2, MidpointRounding.AwayFromZero);
						
						paycheck.Taxes = _taxationService.ProcessTaxes(payroll.Company, paycheck, paycheck.PayDay, grossWage, employeePayChecks);
						paycheck.Deductions = ApplyDeductions(grossWage, paycheck, employeePayChecks);
						paycheck.GrossWage = grossWage;
						paycheck.NetWage = Math.Round( paycheck.GrossWage - paycheck.DeductionAmount -
															 paycheck.EmployeeTaxes + paycheck.CompensationNonTaxableAmount, 2, MidpointRounding.AwayFromZero);

						if (paycheck.Employee.WorkerCompensation != null)
						{
							paycheck.WCAmount = Math.Round(paycheck.GrossWage * paycheck.Employee.WorkerCompensation.Rate /100, 2, MidpointRounding.AwayFromZero);
							paycheck.WorkerCompensation = new PayrollWorkerCompensation
							{
								Wage = paycheck.GrossWage,
								WorkerCompensation = paycheck.Employee.WorkerCompensation,
								Amount = paycheck.WCAmount,
								YTD =
									Math.Round(employeePayChecks.Where(p=>p.WorkerCompensation!=null).Select(p => p.WorkerCompensation).Sum(wc => wc.Amount) + paycheck.WCAmount, 2,
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

						paycheck.YTDGrossWage = Math.Round(employeePayChecks.Sum(p => p.GrossWage) + paycheck.GrossWage, 2, MidpointRounding.AwayFromZero);
						paycheck.YTDNetWage = Math.Round(employeePayChecks.Sum(p => p.NetWage) + paycheck.NetWage, 2, MidpointRounding.AwayFromZero);

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
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Process Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private List<PayTypeAccumulation> ProcessAccumulations(PayCheck paycheck, IEnumerable<AccumulatedPayType> accumulatedPayTypes)
		{
			var result = new List<PayTypeAccumulation>();
			var fiscalStartDate = CalculateFiscalStartDate(paycheck.Employee.HireDate, paycheck.PayDay);
			var fiscalEndDate = fiscalStartDate.AddYears(1).AddDays(-1);

			var employeeChecks = _payrollRepository.GetEmployeePayChecks(paycheck.Employee.Id, fiscalStartDate, fiscalEndDate);
			var fiscalYTDChecks = employeeChecks.Where(p => p.PayDay < paycheck.PayDay).ToList();
			foreach (var payType in accumulatedPayTypes)	
			{
				var ytdAccumulation =
					fiscalYTDChecks.SelectMany(e => e.Accumulations)
						.Where(a => a.PayType.PayType.Id == payType.PayType.Id)
						.Sum(a => a.AccumulatedValue);

				var ytdUsed =
					fiscalYTDChecks.SelectMany(e => e.Accumulations)
						.Where(a => a.PayType.PayType.Id == payType.PayType.Id)
						.Sum(a => a.Used);

				var carryOver =
					employeeChecks.Where(p => p.PayDay < fiscalStartDate)
						.SelectMany(p => p.Accumulations)
						.ToList()
						.Sum(pc => (pc.AccumulatedValue - pc.Used));

				var thisCheckValue = CalculatePayTypeAccumulation(paycheck, payType.RatePerHour);
				var thisCheckUsed = paycheck.Compensations.Any(p => p.PayType.Id == payType.PayType.Id) ? CalculatePayTypeUsage(paycheck.Employee, paycheck.Compensations.First(p => p.PayType.Id == payType.PayType.Id).Amount) :
				(decimal) 0;
				var accumulationValue = (decimal)0;
				if ((ytdAccumulation + thisCheckValue) >= payType.AnnualLimit)
					accumulationValue = payType.AnnualLimit - thisCheckValue;
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
					quotient = employee.Rate/(40*52/26);
				else if (employee.PayrollSchedule == PayrollSchedule.SemiMonthly)
					quotient = employee.Rate / (40 * 52 / 24);
				else if (employee.PayrollSchedule == PayrollSchedule.Monthly)
					quotient = employee.Rate / (40 * 52 / 12);
			}
			return Convert.ToDecimal(Math.Round(compnesaitonAmount / quotient, 2, MidpointRounding.AwayFromZero));
		}

		private decimal CalculatePayTypeAccumulation(PayCheck paycheck, decimal ratePerHour)
		{
			if (paycheck.Employee.PayType == EmployeeType.Hourly || paycheck.Employee.PayType == EmployeeType.PieceWork)
			{
				return paycheck.PayCodes.Sum(pc => pc.Hours + pc.OvertimeHours)*ratePerHour;
			}
			else
			{
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
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					payroll.Status = PayrollStatus.Committed;
					payroll.PayChecks.ForEach(pc=>pc.Status = PaycheckStatus.Saved);
					var companyIdForPayrollAccount = payroll.Company.Id;
					
					var coaList = _companyService.GetCompanyPayrollAccounts(companyIdForPayrollAccount);
					var savedPayroll = _payrollRepository.SavePayroll(payroll);
					savedPayroll.PayChecks.ForEach(pc =>
					{
						var j = CreateJournalEntry(pc, coaList, payroll.UserName);
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
							var j = CreateJournalEntry(pc, coaList, payroll.UserName, true, companyIdForPayrollAccount);
							pc.DocumentId = j.DocumentId;
						});
					}

					var companyPayChecks = _payrollRepository.GetPayChecksPostPayDay(savedPayroll.Company.Id, savedPayroll.PayDay);
					var affectedChecks = new List<PayCheck>();
					foreach (var paycheck in savedPayroll.PayChecks)
					{
						var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id).ToList();
						foreach (var employeeFutureCheck in employeeFutureChecks)
						{
							employeeFutureCheck.AddToYTD(paycheck);
							_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
							affectedChecks.Add(employeeFutureCheck);
						}
					}
					if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice)
					{
						savedPayroll.Invoice = CreatePayrollInvoice(savedPayroll, payroll.UserName, false);
					}
					txn.Complete();
					Bus.Publish<PayrollSavedEvent>(new PayrollSavedEvent
					{
						SavedObject = savedPayroll,
						UserId = savedPayroll.UserId,
						TimeStamp = DateTime.Now,
						EventType = NotificationTypeEnum.Created,
						AffectedChecks = affectedChecks
					});
					if (payroll.Company.Contract.BillingOption == BillingOptions.Invoice)
					{
						Bus.Publish<InvoiceCreatedEvent>(new InvoiceCreatedEvent
						{
							SavedObject = savedPayroll.Invoice,
							EventType = NotificationTypeEnum.Created,
							TimeStamp = DateTime.Now,
							UserId = savedPayroll.UserId,
							UserName = savedPayroll.UserName
						});
					}
					return savedPayroll;
				}
				

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
					var payroll = _payrollRepository.GetPayrollById(payrollId);
					var paycheck = _payrollRepository.GetPayCheckById(payrollId, payCheckId);
					var journal = _journalService.GetPayCheckJournal(payCheckId, paycheck.PEOASOCoCheck);
					paycheck.Status = PaycheckStatus.Void;
					paycheck.IsVoid = true;
					var savedPaycheck = _payrollRepository.VoidPayCheck(paycheck, name);

					journal.IsVoid = true;
					var savedJournal = _journalService.VoidJournal(journal.Id, TransactionType.PayCheck, name);
					if (paycheck.PEOASOCoCheck)
					{
						var journal1 = _journalService.GetPayCheckJournal(payCheckId, !paycheck.PEOASOCoCheck);
						if (journal1 != null)
						{
							journal1.IsVoid = true;
							_journalService.VoidJournal(journal1.Id, TransactionType.PayCheck, name);
						}

					}
				
					var companyPayChecks = _payrollRepository.GetPayChecksPostPayDay(savedPaycheck.Employee.CompanyId, savedPaycheck.PayDay);
					var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id).ToList();
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
						AffectedChecks = employeeFutureChecks
					});
				}
				return _payrollRepository.GetPayrollById(payrollId);


			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Confirm Payroll");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public PayCheck GetPayCheck(int checkId)
		{
			try
			{
				return _payrollRepository.GetPayCheckById(checkId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Pay Check with id=" + checkId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<Invoice> GetCompanyInvoices(Guid companyId)
		{
			try
			{
				return _payrollRepository.GetCompanyInvoices(companyId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Invoices for company id=" + companyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Invoice SaveInvoice(Invoice invoice)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					invoice.Payments.ForEach(p =>
					{
						if (p.Status == PaymentStatus.Draft)
						{
							p.Status = p.Method==VendorDepositMethod.Cash? PaymentStatus.Paid : PaymentStatus.Submitted;
						}
						
					});
					var dbIncvoice = _payrollRepository.GetInvoiceById(invoice.Id);
					if (dbIncvoice != null)
					{
						if (dbIncvoice.Status == InvoiceStatus.Draft && invoice.Status == InvoiceStatus.Submitted)
						{
							invoice.SubmittedOn = DateTime.Now;
							invoice.SubmittedBy = invoice.UserName;
						}
						if (dbIncvoice.Status == InvoiceStatus.Submitted && invoice.Status == InvoiceStatus.Delivered)
						{
							invoice.DeliveredOn = DateTime.Now;
							invoice.DeliveredBy = invoice.UserName;
						}
						if (invoice.Status == InvoiceStatus.Delivered || invoice.Status==InvoiceStatus.PartialPayment || invoice.Status==InvoiceStatus.PaymentBounced)
						{
							if(invoice.Balance == 0)
								invoice.Status = InvoiceStatus.Paid;
							else if (invoice.Balance < invoice.Total)
								invoice.Status = invoice.Payments.Any(p => p.Status == PaymentStatus.PaymentBounced)
									? InvoiceStatus.PaymentBounced
									: InvoiceStatus.PartialPayment;
						}
						
					}
					var savedInvoice = _payrollRepository.SaveInvoice(invoice);

					if (dbIncvoice == null || invoice.Status == InvoiceStatus.Draft)
					{
						savedInvoice.PayrollIds = invoice.PayrollIds;
						_payrollRepository.SetPayrollInvoiceId(savedInvoice);
					}
						
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

		public Invoice GetInvoiceById(Guid invoiceId)
		{
			try
			{
				return _payrollRepository.GetInvoiceById(invoiceId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Invoice By id=" + invoiceId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<Models.Payroll> GetInvoicePayrolls(Guid invoiceId)
		{
			try
			{
				return _payrollRepository.GetInvoicePayrolls(invoiceId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Payrolls for Invoice By id=" + invoiceId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public FileDto PrintPayCheck(int payCheckId)
		{
			try
			{
				var payCheck = _payrollRepository.GetPayCheckById(payCheckId);
				var payroll = _payrollRepository.GetPayrollById(payCheck.PayrollId);
				var journal = _journalService.GetPayCheckJournal(payCheck.Id, payCheck.PEOASOCoCheck);
				return PrintPayCheck(payroll, payCheck, journal);
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
				var payroll = _payrollRepository.GetPayrollById(payCheck.PayrollId);
				var journal = _journalService.GetPayCheckJournal(payCheck.Id, payroll.PEOASOCoCheck);
				return PrintPayCheck(payroll, payCheck, journal);
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
				return PrintPayCheck(payroll, payCheck, journal);
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
			var paycheck = _payrollRepository.GetPayCheckById(payCheckId);
			if (paycheck.Status == PaycheckStatus.Printed || paycheck.Status==PaycheckStatus.PrintedAndPaid)
				return;
			if (paycheck.Status == PaycheckStatus.Saved)
				_payrollRepository.ChangePayCheckStatus(payCheckId, PaycheckStatus.Printed);
			else if (paycheck.Status==PaycheckStatus.Paid)
				_payrollRepository.ChangePayCheckStatus(payCheckId, PaycheckStatus.PrintedAndPaid);
		}

		public FileDto PrintPayroll(Models.Payroll payroll)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var documents = new List<Guid>();
					var updateStatus = false;
					
					foreach (var paychecks in payroll.PayChecks.Where(pc => !pc.IsVoid))
					{
						if (!_fileRepository.FileExists(paychecks.DocumentId))
						{
							PrintPayCheck(payroll, paychecks);
							updateStatus = true;
						}
						documents.Add(paychecks.DocumentId);
					}


					var returnFile = _reportService.PrintPayrollWithSummary(payroll, documents);
					if(payroll.Status == PayrollStatus.Committed || (payroll.Status == PayrollStatus.Printed && updateStatus))
						_payrollRepository.MarkPayrollPrinted(payroll.Id);
					txn.Complete();
					return returnFile;
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Print Payrolls for id=" + payroll.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public PayrollInvoice CreatePayrollInvoice(Models.Payroll payroll, string fullName, bool fetchCompany)
		{
			var payrollInvoice = new PayrollInvoice { Id = CombGuid.Generate(), UserName = fullName, LastModified = DateTime.Now, ProcessedBy = fullName };
			return CreateInvoice(payroll, payrollInvoice, fetchCompany);
		}

		private PayrollInvoice CreateInvoice(Models.Payroll payroll, PayrollInvoice payrollInvoice, bool fetchCompany)
		{
			try
			{
				var company = fetchCompany ? _companyService.GetCompanyById(payroll.Company.Id) : payroll.Company;
				var previousInvoices = _payrollRepository.GetPayrollInvoices(payroll.Company.HostId, payroll.Company.Id);
				var voidedPayChecks = _payrollRepository.GetUnclaimedVoidedchecks(payroll.Company.Id);
				payrollInvoice.Initialize(payroll, previousInvoices, _taxationService.GetApplicationConfig().EnvironmentalChargeRate, company, voidedPayChecks);

				var savedInvoice = _payrollRepository.SavePayrollInvoice(payrollInvoice);
				if (!string.IsNullOrWhiteSpace(payroll.Notes))
				{
					_commonService.AddToList<Comment>(EntityTypeEnum.Invoice, EntityTypeEnum.Comment, savedInvoice.Id, new Comment { Content = payroll.Notes, TimeStamp = savedInvoice.LastModified });
				}
				Bus.Publish<InvoiceCreatedEvent>(new InvoiceCreatedEvent
				{
					SavedObject = savedInvoice,
					EventType = NotificationTypeEnum.Created,
					TimeStamp = DateTime.Now,
					UserId = savedInvoice.UserId,
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
		public PayrollInvoice RecreateInvoice(Guid invoiceId, string fullName)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					var invoice = _payrollRepository.GetPayrollInvoiceById(invoiceId);
					var payroll = _payrollRepository.GetPayrollById(invoice.PayrollId);
					var payrollInvoice = new PayrollInvoice { Id = invoice.Id, UserName = fullName, LastModified = DateTime.Now, ProcessedBy = fullName, InvoiceNumber = invoice.InvoiceNumber};
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

		
		public List<PayrollInvoice> GetHostInvoices(Guid hostId)
		{
			try
			{
				return _payrollRepository.GetPayrollInvoices(hostId, null);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " get invoices for host id=" + hostId);
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
					
					invoice.Payments.ForEach(p =>
					{
						if (p.Status == PaymentStatus.Draft)
						{
							p.Status = p.Method == VendorDepositMethod.Cash ? PaymentStatus.Paid : PaymentStatus.Submitted;
						}

					});
					var dbIncvoice = _payrollRepository.GetPayrollInvoiceById(invoice.Id);
					
					if (dbIncvoice != null)
					{
						if (dbIncvoice.Status == InvoiceStatus.Draft)
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
						if (invoice.Status == InvoiceStatus.Delivered || invoice.Status == InvoiceStatus.PartialPayment || invoice.Status == InvoiceStatus.PaymentBounced || invoice.Status==InvoiceStatus.Paid || invoice.Status==InvoiceStatus.Deposited)
						{
							if (invoice.Balance == 0)
								invoice.Status = InvoiceStatus.Paid;
							else if (invoice.Balance <= invoice.Total)
							{
								if(invoice.Payments.Any(p=>p.Status==PaymentStatus.PaymentBounced))
									invoice.Status = InvoiceStatus.PaymentBounced;
								else if(invoice.Payments.Any(p=>p.Status==PaymentStatus.Submitted))
									invoice.Status = InvoiceStatus.Deposited;
								else if(invoice.Payments.Any())
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

		public List<Models.Payroll> FixPayrollData()
		{
			try
			{
				var payrolls = _payrollRepository.GetAllPayrolls();
				payrolls.ForEach(payroll => payroll.PayChecks.ForEach(pc =>
				{
					if (pc.WorkerCompensation != null)
					{
						pc.WorkerCompensation.Wage = pc.GrossWage;
						_payrollRepository.SavePayCheck(pc);
					}
				}));
				
				return payrolls;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Fix Payroll Data for all" );
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		
		private FileDto PrintPayCheck(Models.Payroll payroll, PayCheck payCheck, Journal journal)
		{
			try
			{
				var coas = _companyService.GetComanyAccounts(journal.CompanyId);
				var bankcoa = coas.First(c => c.Id == journal.MainAccountId);
				var pdf = new PDFModel
				{
					Name = string.Format("Pay Check_{1}_{2} {0}.pdf", payCheck.PayDay.ToString("MMddyyyy"), payCheck.PayrollId, payCheck.Id),
					TargetId = payCheck.Id,
					NormalFontFields = new List<KeyValuePair<string, string>>(),
					BoldFontFields = new List<KeyValuePair<string, string>>(),
					TargetType = EntityTypeEnum.PayCheck,
					Template = payroll.Company.PayCheckStock.GetHrMaxxName(),
					DocumentId = journal.DocumentId
				};
				if (payCheck.Employee.PaymentMethod == EmployeePaymentMethod.DirectDebit)
					pdf.BoldFontFields.Add(new KeyValuePair<string, string>("dd-spec", "NON-NEGOTIABLE     DIRECT DEPOSIT"));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("Name", payroll.Company.Name));
				if (payroll.Company.PayCheckStock == PayCheckStock.LaserMiddle)
				{
					pdf.BoldFontFields.Add(new KeyValuePair<string, string>("Name-2", payroll.Company.Name));
					pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo-2", payCheck.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : payCheck.CheckNumber.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date-3", payCheck.PayDay.ToString("MM/dd/yyyy")));
				}
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo", payCheck.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : payCheck.CheckNumber.ToString()));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Address", payroll.Company.CompanyAddress.AddressLine1));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("City", payroll.Company.CompanyAddress.AddressLine2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName", payCheck.Employee.FullName));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName2", payCheck.Employee.FullName));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("CompanyMemo", payroll.Company.Memo));
				if (payroll.Company.PayCheckStock == PayCheckStock.MICREncodedTop || payroll.Company.PayCheckStock == PayCheckStock.MICRQb)
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName3", payCheck.Employee.FullName));
				}
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text1", payCheck.Employee.Contact.Address.AddressLine1));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text2", payCheck.Employee.Contact.Address.AddressLine2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date", payCheck.PayDay.ToString("MM/dd/yyyy")));

				var words = Utilities.NumberToWords(Math.Floor(payCheck.NetWage));
				var decPlaces = (int)(((decimal)payCheck.NetWage % 1) * 100);
				if (payroll.Company.PayCheckStock == PayCheckStock.MICREncodedTop ||
						payroll.Company.PayCheckStock == PayCheckStock.MICRQb)
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Amount", "****" + payCheck.NetWage));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("AmtInWords", string.Format("{0} {1}/100 {2}", words, decPlaces, "****")));
				}
				else
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Amount", payCheck.NetWage.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("AmtInWords", string.Format("{0} {1}/100 {2}", words, decPlaces, string.Empty)));

					if (payCheck.PaymentMethod == EmployeePaymentMethod.Check)
					{
						var micr = "00000000";
						micr =
							micr.Substring(0,
								(8 - payCheck.CheckNumber.ToString().Length) < 0 ? 0 : 8 - payCheck.CheckNumber.ToString().Length) +
							payCheck.CheckNumber.ToString();
						var micrVal = string.Format("C{0}CA{1}A{2}C", micr, bankcoa.BankAccount.RoutingNumber,
							bankcoa.BankAccount.AccountNumber);
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("MICR", micrVal));
					}

				}
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Memo", string.Format("Pay Period {0}-{1}", payCheck.StartDate.ToString("d"), payCheck.EndDate.ToString("d"))));
				var caption8 = string.Format("****-**-{0}                                                {1} {2}",
					payCheck.Employee.SSN.Substring(payCheck.Employee.SSN.Length - 4), "Employee No:", payCheck.Employee.EmployeeNo);
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Caption8", caption8));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CompName", payroll.Company.Name));

				if (payroll.Company.PayCheckStock != PayCheckStock.MICRQb)
				{
					pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo2",
						payCheck.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : payCheck.CheckNumber.ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compAddress", payroll.Company.CompanyAddress.AddressLine1));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compCity", payroll.Company.CompanyAddress.AddressLine2));

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
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum1-1", journal.Memo));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("CompanyMemo-1", payroll.Company.Memo));
					pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CompName-1", payroll.Company.Name));
					if (payCheck.Employee.PayType == EmployeeType.Salary)
					{
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr1-s-1", "Salary"));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("am-1-1", payCheck.Salary.ToString("C")));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdam-1-1", payCheck.YTDSalary.ToString("C")));
					}
					else
					{

						var hrcounter = 1;
						var otcounter = 1;
						foreach (var payCode in payCheck.PayCodes.Where(p => p.Hours > 0 || p.OvertimeHours > 0).ToList())
						{
							if (hrcounter < 4 && (payCode.Amount > 0))
							{
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + hrcounter + "-s-1", payCode.PayCode.Description));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("hr-" + hrcounter + "-1", payCode.Hours.ToString()));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("r-" + hrcounter + "-1",
									payCode.PayCode.HourlyRate.ToString("C")));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("am-" + hrcounter + "-1", payCode.Amount.ToString("c")));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdam-" + hrcounter + "-1", payCode.YTD.ToString("C")));

								hrcounter++;
							}
							if (otcounter < 4 && (payCode.OvertimeAmount > 0))
							{
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + otcounter + "-ot-1",
									payCode.PayCode.Description + " Overtime"));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ot-" + otcounter + "-1",
									payCode.OvertimeHours.ToString()));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("or-" + otcounter + "-1",
									(payCode.PayCode.HourlyRate*(decimal) 1.5).ToString("C")));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("otam-" + otcounter + "-1",
									payCode.OvertimeAmount.ToString("c")));
								pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdot-" + otcounter + "-1",
									payCode.YTDOvertime.ToString("c")));

								otcounter++;
							}

						}
					}
					var compCounter1 = 1;
					foreach (var compensation in payCheck.Compensations.Where(compensation => compensation.Amount > 0 || compensation.YTD > 0))
					{
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
					
					foreach (var payCode in payCheck.PayCodes.Where(p => p.Hours > 0 || p.OvertimeHours > 0).ToList())
					{
						prwytd += Math.Round(payCode.YTD + payCode.YTDOvertime - payCode.Amount - payCode.OvertimeAmount, 2,
							MidpointRounding.AwayFromZero);
						if (hrcounter < 4 && (payCode.Amount > 0))
						{
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + hrcounter + "-s", payCode.PayCode.Description));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("hr-" + hrcounter, payCode.Hours.ToString()));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("r-" + hrcounter, payCode.PayCode.HourlyRate.ToString("C")));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("am-" + hrcounter, payCode.Amount.ToString("c")));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdam-" + hrcounter, payCode.YTD.ToString("C")));

							hrcounter++;
						}
						if (otcounter < 4 && (payCode.OvertimeAmount > 0))
						{
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("pr" + otcounter + "-ot", payCode.PayCode.Description + " Overtime"));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ot-" + otcounter, payCode.OvertimeHours.ToString()));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("or-" + otcounter, (payCode.PayCode.HourlyRate * (decimal)1.5).ToString("C")));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("otam-" + otcounter, payCode.OvertimeAmount.ToString("c")));
							pdf.NormalFontFields.Add(new KeyValuePair<string, string>("ytdot-" + otcounter, payCode.YTDOvertime.ToString("c")));

							otcounter++;
						}

					}
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("prwytd", prwytd.ToString("C")));
					if (payCheck.Employee.PayType == EmployeeType.PieceWork)
					{
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum3-1", payCheck.Notes.Any() ? payCheck.Notes[0].Content.ToString() : string.Empty));
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum3", payCheck.Notes.Any() ? payCheck.Notes[0].Content.ToString() : string.Empty));
					}
				}

				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum1", journal.Memo));
				var compCounter = 1;
				foreach (var compensation in payCheck.Compensations.Where(compensation => compensation.Amount > 0 || compensation.YTD > 0))
				{
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

				return _pdfService.Print(pdf);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Payrolls for Invoice By id=" + payCheck.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		private Journal CreateJournalEntry(PayCheck pc, List<Account> coaList, string userName, bool PEOASOCoCheck = false, Guid? companyId = null)
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
			return _journalService.SaveJournalForPayroll(journal);
		}

		private List<PayrollPayType> ProcessCompensations(List<PayrollPayType> compensations, IEnumerable<PayCheck> previousChecks  )
		{
			var previousComps = previousChecks.SelectMany(pc => pc.Compensations).ToList();
			compensations.ForEach(c =>
			{
				c.Amount = Math.Round(c.Amount, 2, MidpointRounding.AwayFromZero);
				c.YTD = Math.Round(previousComps.Where(ppc => c.PayType.Id == ppc.PayType.Id).Sum(ppc => ppc.Amount) + c.Amount, 2, MidpointRounding.AwayFromZero);
			});
			return compensations;
		} 
		private List<PayrollPayCode> ProcessPayCodes(List<PayrollPayCode> payCodes, IEnumerable<PayCheck> previousChecks )
		{
			const decimal overtimequotiant = (decimal)1.5;
			var previousPayCodes = previousChecks.SelectMany(p => p.PayCodes).ToList();
			payCodes.ForEach(pc =>
			{
				pc.Amount = Math.Round(pc.Hours * pc.PayCode.HourlyRate, 2, MidpointRounding.AwayFromZero);
				pc.OvertimeAmount = Math.Round(pc.OvertimeHours * pc.PayCode.HourlyRate * overtimequotiant, 2, MidpointRounding.AwayFromZero);
				pc.YTD = Math.Round(previousPayCodes.Where(ppc => ppc.PayCode.Id == pc.PayCode.Id).Sum(ppc => ppc.Amount) + pc.Amount, 2, MidpointRounding.AwayFromZero);
				pc.YTDOvertime = Math.Round(previousPayCodes.Where(ppc => ppc.PayCode.Id == pc.PayCode.Id).Sum(ppc => ppc.OvertimeAmount) + pc.OvertimeAmount, 2, MidpointRounding.AwayFromZero);
			});
			return payCodes;
		}
		private decimal GetGrossWage(PayCheck paycheck)
		{
			
			if (paycheck.Employee.PayType == EmployeeType.Salary)
				return Math.Round(paycheck.Salary, 2);
			else
			{
				return Math.Round(paycheck.PayCodes.Sum(pc => (pc.Amount + pc.OvertimeAmount)), 2, MidpointRounding.AwayFromZero);
			}
		}

		private List<PayrollDeduction> ApplyDeductions(decimal grossWage, PayCheck payCheck, IEnumerable<PayCheck> previousChecks )
		{
			var localGrossWage = grossWage - payCheck.EmployeeTaxes;
			payCheck.Deductions.ForEach(d =>
			{
				if (d.Method == DeductionMethod.Amount)
					d.Amount = d.Rate;
				else
					d.Amount = localGrossWage * d.Rate / 100;
				d.Amount = d.Amount > localGrossWage ? localGrossWage : d.Amount;
				var ytdVal = previousChecks.SelectMany(p => p.Deductions).Where(p => p.Deduction.Id == d.Deduction.Id).Sum(ded => ded.Amount);
				if (d.AnnualMax.HasValue)
				{
					if(ytdVal + d.Amount > d.AnnualMax.Value)
						d.Amount = Math.Max(0, d.AnnualMax.Value - d.Amount);
				}
				if (d.Amount < 0)
					d.Amount = 0;

				d.Amount = Math.Round(d.Amount, 2, MidpointRounding.AwayFromZero);
				d.YTD = Math.Round(ytdVal + d.Amount, 2, MidpointRounding.AwayFromZero);
			});
			return payCheck.Deductions;
		}

		public List<PayrollInvoice> GetAllPayrollInvoicesWithDeposits()
		{
			try
			{
				return _payrollRepository.GetAllPayrollInvoicesWithDeposits();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Payroll Invoices deposits and partial payments");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}
}

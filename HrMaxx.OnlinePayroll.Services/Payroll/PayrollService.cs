using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
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

namespace HrMaxx.OnlinePayroll.Services.Payroll
{
	public class PayrollService : BaseService, IPayrollService
	{
		private readonly IPayrollRepository _payrollRepository;
		private readonly ITaxationService _taxationService;
		private readonly ICompanyService _companyService;
		private readonly IJournalService _journalService;

		public IBus Bus { get; set; }

		public PayrollService(IPayrollRepository payrollRepository, ITaxationService taxationService, ICompanyService companyService, IJournalService journalService)
		{
			_payrollRepository = payrollRepository;
			_taxationService = taxationService;
			_companyService = companyService;
			_journalService = journalService;
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
							paycheck.Salary = 0;
						else
						{
							paycheck.Salary = Math.Round(paycheck.Salary, 2, MidpointRounding.AwayFromZero);
						}
						paycheck.YTDSalary = Math.Round(employeePayChecks.Sum(p => p.Salary) + paycheck.Salary, 2, MidpointRounding.AwayFromZero);
						
						paycheck.PayCodes = ProcessPayCodes(paycheck.PayCodes, employeePayChecks);
						
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
							paycheck.WCAmount = Math.Round(paycheck.GrossWage * paycheck.Employee.WorkerCompensation.Rate, 2, MidpointRounding.AwayFromZero);
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
					}
					
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
			if (paycheck.Employee.PayType == EmployeeType.Hourly)
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
					
					var coaList = _companyService.GetCompanyPayrollAccounts(payroll.Company.Id);
					var savedPayroll = _payrollRepository.SavePayroll(payroll);
					savedPayroll.PayChecks.ForEach(pc => CreateJournalEntry(pc, coaList, payroll.UserName));
					var companyPayChecks = _payrollRepository.GetPayChecksPostPayDay(savedPayroll.Company.Id, savedPayroll.PayDay);
					foreach (var paycheck in savedPayroll.PayChecks)
					{
						var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id).ToList();
						foreach (var employeeFutureCheck in employeeFutureChecks)
						{
							employeeFutureCheck.AddToYTD(paycheck);
							_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
						}


					}
					txn.Complete();
					Bus.Publish<PayrollSavedEvent>(new PayrollSavedEvent
					{
						SavedObject = savedPayroll,
						UserId = savedPayroll.UserId,
						TimeStamp = DateTime.Now,
						EventType = NotificationTypeEnum.Created
					});
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

					var paycheck = _payrollRepository.GetPayCheckById(payrollId, payCheckId);
					var journal = _journalService.GetPayCheckJournal(payCheckId);
					paycheck.Status = PaycheckStatus.Void;
					paycheck.IsVoid = true;
					var savedPaycheck = _payrollRepository.VoidPayCheck(paycheck, name);

					journal.IsVoid = true;
					var savedJournal = _journalService.VoidJournal(journal.Id, TransactionType.PayCheck, name);
				
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
						UserId = new Guid(user),
						TimeStamp = DateTime.Now,
						EventType = NotificationTypeEnum.Updated
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

		private void CreateJournalEntry(PayCheck pc, List<Account> coaList, string userName)
		{
			var bankCOA = coaList.First(c => c.UseInPayroll);
			var journal = new Journal
			{
				Id = 0,
				CompanyId = pc.Employee.CompanyId,
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
				JournalDetails = new List<JournalDetail>()

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
			_journalService.SaveJournalForPayroll(journal);
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
				if (d.Method == DeductionMethod.FixedRate)
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
	}
}

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Journals;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using Magnum;
using MassTransit;

namespace HrMaxx.OnlinePayroll.Services.EventHandlers
{
	public class ConfirmPayrollEventHandler : BaseService, Consumes<ConfirmPayrollEvent>.All
	{
		public IBus Bus { get; set; }
		public readonly IReaderService _readerService;
		public readonly IPayrollService _payrollService;
		public readonly IJournalService _journalService;
		public readonly IMementoDataService _mementoDataService;
		public readonly IPayrollRepository _payrollRepository;
		public readonly ITaxationService _taxationService;

		public ConfirmPayrollEventHandler(IReaderService readerService, IPayrollService payrollService, IJournalService journalService, IMementoDataService mementoDataService, IPayrollRepository payrollRepository, ITaxationService taxationService)
		{
			_readerService = readerService;
			_payrollService = payrollService;
			_journalService = journalService;
			_mementoDataService = mementoDataService;
			_payrollRepository = payrollRepository;
			_taxationService = taxationService;
		}

		public void Consume(ConfirmPayrollEvent event1)
		{
			int counter = 0;
			bool result = false;
			while (counter < 2 && !result)
			{
				result = RunConfirmPayrollEvent(event1, counter++);
			}
			_taxationService.RemoveFromConfirmPayrollQueueItem(event1.Payroll.Id);
			if (!result)
			{

				_payrollRepository.ConfirmFailed(event1.Payroll.Id);
				Log.Info("Removed from Queue and marked failed - " + DateTime.Now.ToString("hh:mm:ss:fff"));
			}
			
		}

		private bool RunConfirmPayrollEvent(ConfirmPayrollEvent event1, int retry)
		{
			Log.Info(string.Format("Staring Confirm for Payroll {0} - {1} - {2} - Go# {3}", event1.Payroll.Id, event1.Payroll.Company.Name, DateTime.Now.ToString("hh:mm:ss:fff"), retry));
			try
			{
				var affectedChecks = new List<PayCheck>();
				var companyPayChecks = _readerService.GetPayChecks(companyId: event1.Payroll.Company.Id, startDate: event1.Payroll.PayDay, year: event1.Payroll.PayDay.Year, isvoid: 0);
				using (var txn = TransactionScopeHelper.Transaction())
				{
					foreach (var journal in event1.Journals)
					{
						var j = _journalService.SaveJournalForPayroll(journal, event1.Payroll.Company);
						journal.Id = j.Id;
						journal.CheckNumber = j.CheckNumber;
						event1.Payroll.PayChecks.First(pc => pc.Id == journal.PayrollPayCheckId).CheckNumber = journal.CheckNumber;
					}
					foreach (var journal in event1.PeoJournals)
					{
						var j = _journalService.SaveJournalForPayroll(journal, event1.Payroll.Company);
						journal.Id = j.Id;
						journal.CheckNumber = j.CheckNumber;
						event1.Payroll.PayChecks.First(pc => pc.Id == journal.PayrollPayCheckId).CheckNumber = journal.CheckNumber;

					}
					Log.Info(string.Format("saved journals for Payroll {0} - {1} - {2} ", event1.Payroll.Id, event1.Payroll.Company.Name, DateTime.Now.ToString("hh:mm:ss:fff")));
					var payCheckJournals = _payrollRepository.EnsureCheckNumberIntegrity(event1.Payroll.Id, event1.Payroll.PEOASOCoCheck);
					payCheckJournals.ForEach(p =>
					{
						event1.Payroll.PayChecks.First(pc => pc.Id == p.PayCheckId).CheckNumber = p.CheckNumber;
						event1.Journals.First(j => j.PayrollPayCheckId == p.PayCheckId).CheckNumber = p.CheckNumber;
						if(event1.Payroll.PEOASOCoCheck)
							event1.PeoJournals.First(j => j.PayrollPayCheckId == p.PayCheckId).CheckNumber = p.CheckNumber;
					});
					Log.Info(string.Format("ensured check number integrity for Payroll {0} - {1} - {2} ", event1.Payroll.Id, event1.Payroll.Company.Name, DateTime.Now.ToString("hh:mm:ss:fff")));
					if (event1.Payroll.Company.Contract.BillingOption == BillingOptions.Invoice)
					{
						var inv = _payrollService.CreatePayrollInvoice(event1.Payroll, event1.Payroll.UserName, event1.Payroll.UserId, false);
						event1.Payroll.InvoiceId = inv.Id;
						event1.Payroll.InvoiceNumber = inv.InvoiceNumber;
						event1.Payroll.InvoiceStatus = inv.Status;
						event1.Payroll.Total = inv.Total;
					}
					_taxationService.UpdateConfirmPayrollQueueItem(event1.Payroll.Id);
					_payrollRepository.UnQueuePayroll(event1.Payroll.Id);
					Log.Info(string.Format("created invoice for Payroll {0} - {1} - {2} ", event1.Payroll.Id, event1.Payroll.Company.Name, DateTime.Now.ToString("hh:mm:ss:fff")));
					
					
					foreach (var paycheck in event1.Payroll.PayChecks)
					{
						var employeeFutureChecks = companyPayChecks.Where(p => p.Employee.Id == paycheck.Employee.Id && p.PayDay > paycheck.PayDay && p.Id != paycheck.Id).ToList();
						foreach (var employeeFutureCheck in employeeFutureChecks)
						{
							employeeFutureCheck.AddToYTD(paycheck);
							_payrollRepository.UpdatePayCheckYTD(employeeFutureCheck);
							affectedChecks.Add(employeeFutureCheck);
						}
					}
					Log.Info(string.Format("Updated future checks {0} ", affectedChecks.Count.ToString()));
					_payrollService.UpdateLastPayrollDateAndPayRateEmployee(event1.Payroll.PayChecks.Where(pc=>pc.UpdateEmployeeRate).ToList());
					
					if (!event1.Payroll.Company.LastPayrollDate.HasValue ||
							event1.Payroll.Company.LastPayrollDate < event1.Payroll.PayDay)
					{
						_payrollRepository.UpdateLastPayrollDateCompany(event1.Payroll.Company.Id, event1.Payroll.PayDay);
					}
					
					Log.Info(string.Format("finished transactions for payroll {0} - {1} - {2} ", event1.Payroll.Id, event1.Payroll.Company.Name, DateTime.Now.ToString("hh:mm:ss:fff")));
					txn.Complete();
				}
				
				if(event1.Payroll.PEOASOCoCheck)
					_taxationService.SetPEOMaxCheckNumber(event1.PeoJournals.Max(j=>j.CheckNumber));
				_payrollService.PrintAndSavePayroll(event1.Payroll, event1.Payroll.PEOASOCoCheck ? event1.PeoJournals : event1.Journals);
				Log.Info(string.Format("Finished Confirm and Print for Payroll {0} - {1} - {2} - Go# {3}", event1.Payroll.Id, event1.Payroll.Company.Name, DateTime.Now.ToString("hh:mm:ss:fff"), retry));
				Bus.Publish<CreateMementoEvent<PayCheck>>(new CreateMementoEvent<PayCheck>
				{
					List = event1.Payroll.PayChecks,
					EntityType = EntityTypeEnum.PayCheck,
					Notes = "Pay Check Created",
					UserId = event1.Payroll.UserId,
					UserName = event1.Payroll.UserName,
					LogNotes = string.Format("Mementos (PayChecks) for payroll {0} - {1}", event1.Payroll.Id, event1.Payroll.Company.Name)
				});
				if (affectedChecks.Any())
				{
					Bus.Publish<CreateMementoEvent<PayCheck>>(new CreateMementoEvent<PayCheck>
					{
						List = affectedChecks,
						EntityType = EntityTypeEnum.PayCheck,
						Notes = string.Format("YTD affected because of Payroll ran on {0}", event1.Payroll.PayDay.ToString("MM/DD/YYYY")),
						UserId = event1.Payroll.UserId,
						UserName = event1.Payroll.UserName,
						LogNotes = string.Format("YTD Mementos (PayChecks) for payroll {0} - {1}", event1.Payroll.Id, event1.Payroll.Company.Name)
					});
				}
				
				return true;
			}
			catch (Exception e)
			{
				Log.Error(string.Format("Erorr in Confirming Payroll {0} - {1} - {2}", event1.Payroll.Id, event1.Payroll.Company.Name, e.Message));
				return false;
			}




		}

		
	}
}

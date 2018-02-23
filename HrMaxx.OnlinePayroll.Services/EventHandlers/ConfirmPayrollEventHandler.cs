using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using HrMaxx.Bus.Contracts;
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
					var companyPayChecks = _readerService.GetPayChecks(companyId: event1.Payroll.Company.Id, startDate: event1.Payroll.PayDay, year: event1.Payroll.PayDay.Year, isvoid: 0);
					var affectedChecks = new List<PayCheck>();
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
					foreach (var pc in event1.Payroll.PayChecks)
					{
						var memento = Memento<PayCheck>.Create(pc, EntityTypeEnum.PayCheck, event1.Payroll.UserName, "Pay Check Created", event1.Payroll.UserId);
						_mementoDataService.AddMementoData(memento);

					}
					_payrollRepository.UpdateLastPayrollDateAndPayRateEmployee(event1.Payroll.PayChecks);
					
					if (!event1.Payroll.Company.LastPayrollDate.HasValue ||
							event1.Payroll.Company.LastPayrollDate < event1.Payroll.PayDay)
					{
						_payrollRepository.UpdateLastPayrollDateCompany(event1.Payroll.Company.Id, event1.Payroll.PayDay);
					}


					foreach (var pc in affectedChecks)
					{
						var memento = Memento<PayCheck>.Create(pc, EntityTypeEnum.PayCheck, event1.Payroll.UserName, string.Format("YTD affected because of Payroll ran on {0}", event1.Payroll.PayDay.ToString("MM/DD/YYYY")), event1.Payroll.UserId);
						_mementoDataService.AddMementoData(memento, true);
					}
					Log.Info(string.Format("finished transactions for payroll {0} - {1} - {2} ", event1.Payroll.Id, event1.Payroll.Company.Name, DateTime.Now.ToString("hh:mm:ss:fff")));
					txn.Complete();
				}
				_payrollService.PrintAndSavePayroll(event1.Payroll, event1.Payroll.PEOASOCoCheck ? event1.PeoJournals : event1.Journals);
				Log.Info(string.Format("Finished Confirm and Print for Payroll {0} - {1} - {2} - Go# {3}", event1.Payroll.Id, event1.Payroll.Company.Name, DateTime.Now.ToString("hh:mm:ss:fff"), retry));
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

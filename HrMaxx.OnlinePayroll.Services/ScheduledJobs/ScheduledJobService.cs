using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Repository.Common;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Models.JsonDataModel;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using Magnum;
using Magnum.PerformanceCounters;

namespace HrMaxx.OnlinePayroll.Services.ScheduledJobs
{
	public class ScheduledJobService : BaseService, IScheduledJobService
	{
		public readonly IPayrollService _payrollService;
		public readonly IReaderService _readerService;
		public readonly IACHService _achService;
		public readonly ICommonRepository _commonRepository;
		public ScheduledJobService(IPayrollService payrollService, IACHService achService, IReaderService readerService, ICommonRepository commonRepository)
		{
			_payrollService = payrollService;
			_readerService = readerService;
			_achService = achService;
			_commonRepository = commonRepository;
		}

		public void UpdateInvoicePayments()
		{
			try
			{
				Log.Info("Scheduled Job Service Invocie Payment initiated " + DateTime.Now);
				var count = 0;
				var minDate = DateTime.Today.AddDays(-7);
				var invoices = _readerService.GetPayrollInvoices(status: new List<InvoiceStatus>{InvoiceStatus.Paid, InvoiceStatus.Deposited, InvoiceStatus.NotDeposited, InvoiceStatus.PartialPayment}, paymentStatuses:new List<PaymentStatus>{PaymentStatus.Deposited, PaymentStatus.Submitted}, paymentMethods: new List<InvoicePaymentMethod>{InvoicePaymentMethod.Check, InvoicePaymentMethod.Cash, InvoicePaymentMethod.ACH});
				if (invoices.Any())
				{
					var applicable = invoices.Where(
						i => i.InvoicePayments.Any() && i.InvoicePayments.Any(p => (p.Method == InvoicePaymentMethod.Check || p.Method == InvoicePaymentMethod.ACH) && (p.Status == PaymentStatus.Submitted || p.Status==PaymentStatus.Deposited) ))
						.ToList();
					Log.Info(string.Format("{0} Invocies to be updated possibly", applicable.Count));
					var icounter = 0;
					applicable.ForEach(
						i =>
						{
							icounter++;
							var depositedPayments =
								i.InvoicePayments.Where(
									p =>
											(p.Status == PaymentStatus.Deposited && p.Method == InvoicePaymentMethod.Check && p.PaymentDate.Date <= minDate.Date)
											||
											(p.Method == InvoicePaymentMethod.ACH && p.PaymentDate.Date <= minDate.Date)
											||
											(p.Method == InvoicePaymentMethod.Cash && p.Status==PaymentStatus.Submitted)
										).ToList();
							depositedPayments.ForEach(p =>
							{
								p.Status = PaymentStatus.Paid;
								p.LastModified = DateTime.Now;
								p.LastModifiedBy = "System";
								p.HasChanged = true;
							});
							if (depositedPayments.Any(d => d.HasChanged))
							{
								i.LastModified = DateTime.Now;
								i.UserName = "System";
								_payrollService.SavePayrollInvoice(i);
								count++;
							}
						
						});	
				}
				
				Log.Info(string.Format("{0} Invocies updated", count));
			}
			catch (Exception e)
			{
				var message = "Failed to update invoice deposited payments";
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void UpdateLastPayrollDates()
		{
			_payrollService.UpdateCompanyAndEmployeeLastPayrollDate();
		}

		public void RunScheduledPayrolls()
		{
			try
			{
				const string query = "select * from ScheduledPayroll;";
				var scheduledPayrolls = _readerService.GetQueryData<ScheduledPayrollJson, SchedulePayroll>(query).Where(sp => DateTime.Today == GetPayrollNextRunDate(sp)).ToList();
				Log.Info($"Starting Running Scheduled Payrolls - {scheduledPayrolls.Count}");
				scheduledPayrolls.ForEach(sp =>
				{
					
					var payroll = sp.Data;
					payroll.PayDay = DateTime.Today;
					payroll.TaxPayDay = DateTime.Today;
					if (sp.LastPayrollDate.HasValue)
					{
						var lastPayroll = _readerService.GetPayroll(sp.LastPayrollId.Value);
						payroll.StartDate = sp.PaySchedule == PayrollSchedule.Weekly ? lastPayroll.StartDate.AddDays(8) :
												sp.PaySchedule == PayrollSchedule.BiWeekly ? lastPayroll.StartDate.AddDays(15) :
												sp.PaySchedule == PayrollSchedule.SemiMonthly ? lastPayroll.StartDate.AddDays(16) :
												lastPayroll.StartDate.AddMonths(1);
					}
					else
						payroll.StartDate = sp.ScheduleStartDate.Date;
					payroll.EndDate = sp.PaySchedule == PayrollSchedule.Weekly ? payroll.StartDate.AddDays(7) :
												sp.PaySchedule == PayrollSchedule.BiWeekly ? payroll.StartDate.AddDays(14) :
												sp.PaySchedule == PayrollSchedule.SemiMonthly ? payroll.StartDate.AddDays(15) :
												payroll.StartDate.AddMonths(1).AddDays(-1);
					Log.Info($"Staring Schedule Payroll for {payroll.Company.Name} PayDay: {payroll.PayDay.ToShortDateString()}");
					var processed = _payrollService.ProcessPayroll(payroll);
					processed.LastModified = DateTime.Now;
					processed.UserName = "System";
					processed.PayChecks.ForEach(p =>
					 {
						 p.PayrollId = processed.Id;
						 p.LastModified = DateTime.Now;
						 p.LastModifiedBy = "System";
					 });

					_payrollService.ConfirmPayroll(processed);
					Log.Info($"Finished Schedule Payroll for {payroll.Company.Name} PayDay: {payroll.PayDay.ToShortDateString()}");
					System.Threading.Thread.Sleep(20000);
					sp.LastPayrollId = processed.Id;
					sp.LastPayrollDate = processed.LastModified;
					_payrollService.SaveSchedulePayroll(sp);
				});
				Log.Info($"Finished Running Scheduled Payrolls");
			}
			catch(Exception e)
			{
				var message = "Failed to complete running scheduled payrolls";
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private DateTime GetPayrollNextRunDate(SchedulePayroll sp)
		{
			if (!sp.LastPayrollDate.HasValue)
				return sp.PayDateStart.Date;
			int days = sp.PaySchedule == PayrollSchedule.Weekly ? 7 : sp.PaySchedule == PayrollSchedule.BiWeekly ? 14 : sp.PaySchedule == PayrollSchedule.SemiMonthly ? 15 : 30;
			return sp.PaySchedule == PayrollSchedule.Monthly ? sp.LastPayrollDate.Value.Date.AddMonths(1).Date : sp.LastPayrollDate.Value.Date.AddDays(days).Date;


		}
		public void FillACHData()
		{
			try
			{
				Log.Info("ACH Fill Data service initiated " + DateTime.Now);
				_achService.FillACH();
				Log.Info("ACH Fill Data service completed " + DateTime.Now);
			}
			catch (Exception e)
			{
				var message = "Failed to update ACH Data";
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void ProfitStarsNineAM()
		{
			try
			{
				Log.Info("Profit Stars 9 AM service initiated " + DateTime.Now);
				_achService.ProfitStarsStatusUpdate();
				Log.Info("Profit Stars 9 AM service completed " + DateTime.Now);
			}
			catch (Exception e)
			{
				var message = "Failed to run Profit stars 9AM";
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public void ProfitStarsOnePM()
		{
			try
			{
				Log.Info("Profit Stars 1 PM service initiated " + DateTime.Now);
				_achService.ProfitStarsPayments();
				Log.Info("Profit Stars 1 PM service completed " + DateTime.Now);
			}
			catch (Exception e)
			{
				var message = "Failed to run Profit stars 1 PM";
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void UpdateDBStats()
		{
			try
			{
				Log.Info("Updating DB Stats " + DateTime.Now);
				_commonRepository.UpdateDBStats();
				Log.Info("Updating DB stats finished" + DateTime.Now);
			}
			catch (Exception e)
			{
				var message = "Failed to update DB Stats";
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}
}

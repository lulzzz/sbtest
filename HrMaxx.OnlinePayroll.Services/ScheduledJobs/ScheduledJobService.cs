﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using Magnum.PerformanceCounters;

namespace HrMaxx.OnlinePayroll.Services.ScheduledJobs
{
	public class ScheduledJobService : BaseService, IScheduledJobService
	{
		public readonly IPayrollService _payrollService;
		public ScheduledJobService(IPayrollService payrollService)
		{
			_payrollService = payrollService;
		}

		public void UpdateInvoicePayments()
		{
			try
			{
				Log.Info("Scheduled Job Service Invocie Payment initiated " + DateTime.Now);
				var count = 0;
				var minDate = DateTime.Today.AddDays(-7);
				var minACHDate = DateTime.Today.AddDays(-3);
				var invoices = _payrollService.GetAllPayrollInvoicesWithDeposits();
				if (invoices.Any())
				{
					var applicable = invoices.Where(
						i => i.Payments.Any() && i.Payments.Any(p => (p.Method == InvoicePaymentMethod.Check || p.Method==InvoicePaymentMethod.ACH)  && p.Status == PaymentStatus.Submitted))
						.ToList();

					applicable.ForEach(
						i =>
						{
							var depositedPayments =
								i.Payments.Where(
									p =>
										p.Status == PaymentStatus.Submitted &&
										(
											(p.Method == InvoicePaymentMethod.Check && p.PaymentDate.Date >= minDate.Date) 
											|| 
											(p.Method == InvoicePaymentMethod.ACH && p.PaymentDate.Date >= minACHDate.Date)
										)).ToList();
							depositedPayments.ForEach(p =>
							{
								p.Status = PaymentStatus.Paid;
								p.LastModified = DateTime.Now;
								p.LastModifiedBy = "System";
							});
							i.LastModified = DateTime.Now;
							i.UserName = "System";
							_payrollService.SavePayrollInvoice(i);
							count++;
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
	}
}

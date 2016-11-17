using System;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using MassTransit;

namespace HrMaxx.OnlinePayroll.Services.EventHandlers
{
	public class AccumulationCubesHandler : BaseService, Consumes<PayrollSavedEvent>.All, Consumes<PayCheckVoidedEvent>.All, Consumes<PayrollRedateEvent>.All
	{
		private readonly IPayrollService _payrollService;
		private readonly IDashboardService _dashboardService;
		private readonly IHostService _hostService;
		private readonly IMementoDataService _mementoDataService;
		public AccumulationCubesHandler(IDashboardService dashboardService, IHostService hostService, IPayrollService payrollService, IMementoDataService mementoDataService)
		{
			_dashboardService = dashboardService;
			_hostService = hostService;
			_payrollService = payrollService;
			_mementoDataService = mementoDataService;
		}


		public void Consume(PayrollSavedEvent message)
		{
			try
			{
				var payroll = message.SavedObject;
				_dashboardService.AddPayrollToCubes(payroll);
				if (payroll.PEOASOCoCheck)
				{
					var host = _hostService.GetHost(payroll.Company.HostId);
					//payroll.Company = host.Company;
					_dashboardService.AddPayrollToCubes(payroll, host.Company);
				}
			}
			catch (Exception e)
			{
				var message1 = string.Format("{0} payroll id={1}", "Error in Consuming Payroll Saved Event", message.SavedObject.Id);
				Log.Error(message1, e);
				throw new HrMaxxApplicationException(message1, e);
			}
			
		}

		public void Consume(PayrollRedateEvent message)
		{
			try
			{
				var companyPayrolls = _payrollService.GetCompanyPayrolls(message.CompanyId, new DateTime(message.Year, 1, 1).Date,
					new DateTime(message.Year, 12, 31));
				_dashboardService.FixCompanyCubes(companyPayrolls, message.CompanyId, message.Year);
				foreach (var pc in message.AffectedPayChecks)
				{
					var memento = Memento<PayCheck>.Create(pc, EntityTypeEnum.PayCheck, message.UserName, string.Format("YTD updated because of Invoice {0} Redate", message.InvoiceNumber), message.UserId);
					_mementoDataService.AddMementoData(memento, true);
					_payrollService.PrintPayCheck(pc);
				}
			}
			catch (Exception e)
			{
				var message1 = string.Format("{0} Company id={1} and Year={2}", "Error in Fixing Company Cubes for ", message.CompanyId, message.Year );
				Log.Error(message1, e);
				throw new HrMaxxApplicationException(message1, e);
			}

		}

		public void Consume(PayCheckVoidedEvent message)
		{
			try
			{
				var paycheck = message.SavedObject;
				_dashboardService.RemovePayCheckFromCubes(paycheck);
				if (paycheck.PEOASOCoCheck)
				{
					var host = _hostService.GetHost(message.HostId);
					_dashboardService.RemovePayCheckFromCubes(paycheck, host.Company.Id);
				}
			}
			catch (Exception e)
			{
				var message1 = string.Format("{0} payroll id={1}", "Error in Consuming PayCheck VOID Event", message.SavedObject.Id);
				Log.Error(message1, e);
				throw new HrMaxxApplicationException(message1, e);
			}
			
		}
	}
}
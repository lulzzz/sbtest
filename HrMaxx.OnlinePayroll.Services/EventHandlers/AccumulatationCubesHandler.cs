using System;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Services;
using MassTransit;

namespace HrMaxx.OnlinePayroll.Services.EventHandlers
{
	public class AccumulationCubesHandler : BaseService, Consumes<PayrollSavedEvent>.All, Consumes<PayCheckVoidedEvent>.All
	{

		private readonly IDashboardService _dashboardService;
		private readonly IHostService _hostService;
		public AccumulationCubesHandler(IDashboardService dashboardService, IHostService hostService)
		{
			_dashboardService = dashboardService;
			_hostService = hostService;
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
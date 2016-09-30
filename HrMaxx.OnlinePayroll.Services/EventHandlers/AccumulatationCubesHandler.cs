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
			var payroll = message.SavedObject;
			_dashboardService.AddPayrollToCubes(payroll);
			if (payroll.PEOASOCoCheck)
			{
				var host = _hostService.GetHost(payroll.Company.HostId);
				payroll.Company = host.Company;
				_dashboardService.AddPayrollToCubes(payroll);
			}
		}

		public void Consume(PayCheckVoidedEvent message)
		{
			var paycheck = message.SavedObject;
			_dashboardService.RemovePayCheckFromCubes(paycheck);
			if (paycheck.PEOASOCoCheck)
			{
				var host = _hostService.GetHost(message.HostId);
				_dashboardService.RemovePayCheckFromCubes(paycheck, host.Company.Id);
			}
		}
	}
}
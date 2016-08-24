using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Services;
using MassTransit;

namespace HrMaxx.OnlinePayroll.Services.EventHandlers
{
	public class AccumulationCubesHandler : BaseService, Consumes<PayrollSavedEvent>.All, Consumes<PayCheckVoidedEvent>.All
	{

		private readonly IDashboardService _dashboardService;
		public AccumulationCubesHandler(IDashboardService dashboardService)
		{
			_dashboardService = dashboardService;
		}


		public void Consume(PayrollSavedEvent message)
		{
			_dashboardService.AddPayrollToCubes(message.SavedObject);
		}

		public void Consume(PayCheckVoidedEvent message)
		{
			_dashboardService.RemovePayCheckFromCubes(message.SavedObject);
		}
	}
}
using HrMaxx.Bus.Contracts;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using MassTransit;

namespace HrMaxx.OnlinePayroll.Services.EventHandlers
{
	public class PayrollEventHandler : BaseService, Consumes<PayrollSavedEvent>.All, Consumes<PayCheckVoidedEvent>.All
	{
		public IBus Bus { get; set; }
		
		private readonly IPayrollRepository _payrollRepository;
		private readonly ICompanyRepository _companyRepository;
		private readonly IPayrollService _payrollService;

		public PayrollEventHandler(IPayrollRepository payrollRepository, ICompanyRepository companyRepository, IPayrollService payrollService)
		{
			_payrollRepository = payrollRepository;
			_companyRepository = companyRepository;
			_payrollService = payrollService;
		}
		public void Consume(PayrollSavedEvent event1)
		{
			foreach (var paycheck in event1.SavedObject.PayChecks)
			{
				if (!paycheck.Employee.LastPayrollDate.HasValue || paycheck.Employee.LastPayrollDate < event1.SavedObject.PayDay)
					_companyRepository.UpdateLastPayrollDateEmployee(paycheck.Employee.Id, event1.SavedObject.PayDay);
			}
			if (!event1.SavedObject.Company.LastPayrollDate.HasValue ||
			    event1.SavedObject.Company.LastPayrollDate < event1.SavedObject.PayDay)
			{
				_companyRepository.UpdateLastPayrollDateCompany(event1.SavedObject.Company.Id, event1.SavedObject.PayDay);
			}
			foreach (var pc in event1.AffectedChecks)
			{
				_payrollService.PrintPayCheck(pc);
			}

		}

		public void Consume(PayCheckVoidedEvent event1)
		{
			if (!event1.SavedObject.Employee.LastPayrollDate.HasValue || event1.SavedObject.Employee.LastPayrollDate == event1.SavedObject.PayDay)
				_companyRepository.UpdateLastPayrollDateEmployee(event1.SavedObject.Employee.Id, event1.SavedObject.PayDay);
			foreach (var pc in event1.AffectedChecks)
			{
				_payrollService.PrintPayCheck(pc);
			}
		}
	}
}
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Repository.Companies;
using HrMaxx.OnlinePayroll.Repository.Payroll;
using MassTransit;
using Notification = HrMaxx.Common.Contracts.Messages.Events.Notification;

namespace HrMaxx.OnlinePayroll.Services.EventHandlers
{
	public class PayrollEventHandler : BaseService, Consumes<PayrollSavedEvent>.All, Consumes<PayCheckVoidedEvent>.All, Consumes<InvoiceCreatedEvent>.All
	{
		public IBus Bus { get; set; }
		
		private readonly IPayrollRepository _payrollRepository;
		private readonly ICompanyRepository _companyRepository;
		private readonly IPayrollService _payrollService;
		private readonly IUserService _userService;

		public PayrollEventHandler(IPayrollRepository payrollRepository, ICompanyRepository companyRepository, IPayrollService payrollService, IUserService userService)
		{
			_payrollRepository = payrollRepository;
			_companyRepository = companyRepository;
			_payrollService = payrollService;
			_userService = userService;
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

		public void Consume(InvoiceCreatedEvent event1)
		{
			var users = _userService.GetUsers(event1.SavedObject.Company.HostId, null).Select(u => u.UserId).ToList();
			var adminUsers = _userService.GetUsersByRoleAndId(new List<RoleTypeEnum>() { RoleTypeEnum.CorpStaff, RoleTypeEnum.Master }, null);
			users.AddRange(adminUsers);
			Bus.Publish<Notification>(new Notification
			{

				SavedObject = event1.SavedObject,
				SourceId = event1.SavedObject.Id,
				UserId = event1.UserId,
				Source = event1.UserName,
				TimeStamp = event1.TimeStamp,
				Text = "A new invoice has been created for " + event1.SavedObject.Company.Name + " with Invoice date " + event1.SavedObject.InvoiceDate,
				ReturnUrl = "#!/Admin/Invoices/?invoice=" + event1.SavedObject.Id,
				EventType = event1.EventType,
				AffectedUsers = users.Distinct().ToList()
			});

		}
	}
}
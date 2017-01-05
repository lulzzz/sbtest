using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
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
		private readonly IMementoDataService _mementoDataService;
		

		public PayrollEventHandler(IPayrollRepository payrollRepository, ICompanyRepository companyRepository, IPayrollService payrollService, IUserService userService, IMementoDataService mementoDataService)
		{
			_payrollRepository = payrollRepository;
			_companyRepository = companyRepository;
			_payrollService = payrollService;
			_userService = userService;
			_mementoDataService = mementoDataService;
			
		}
		public void Consume(PayrollSavedEvent event1)
		{
			try
			{
				foreach (var paycheck in event1.SavedObject.PayChecks)
				{
					if (!paycheck.Employee.LastPayrollDate.HasValue || paycheck.Employee.LastPayrollDate < event1.SavedObject.PayDay)
						_companyRepository.UpdateLastPayrollDateEmployee(paycheck.Employee.Id);
				}
				if (!event1.SavedObject.Company.LastPayrollDate.HasValue ||
						event1.SavedObject.Company.LastPayrollDate < event1.SavedObject.PayDay)
				{
					_companyRepository.UpdateLastPayrollDateCompany(event1.SavedObject.Company.Id, event1.SavedObject.PayDay);
				}
				foreach (var pc in event1.SavedObject.PayChecks)
				{
					var memento = Memento<PayCheck>.Create(pc, EntityTypeEnum.PayCheck, event1.UserName, "Pay Check Created", event1.UserId);
					_mementoDataService.AddMementoData(memento);
					
				}

				foreach (var pc in event1.AffectedChecks)
				{
					var memento = Memento<PayCheck>.Create(pc, EntityTypeEnum.PayCheck, event1.UserName, string.Format("YTD affected because of Payroll ran on {0}", event1.SavedObject.PayDay.ToString("MM/DD/YYYY")), event1.UserId);
					_mementoDataService.AddMementoData(memento, true);
					_payrollService.PrintPayCheck(pc);
				}

			}
			catch (Exception e)
			{
				var message1 = string.Format("{0} payroll id={1}", "Error in Consuming Payroll Saved Event PayrollEventHandler", event1.SavedObject.Id);
				Log.Error(message1, e);
				throw new HrMaxxApplicationException(message1, e);
			}
			
		}

		public void Consume(PayCheckVoidedEvent event1)
		{
			try
			{
				var memento = Memento<PayCheck>.Create(event1.SavedObject, EntityTypeEnum.PayCheck, event1.UserName, "PayCheck voided",event1.UserId);
				_mementoDataService.AddMementoData(memento);
				if (!event1.SavedObject.Employee.LastPayrollDate.HasValue || event1.SavedObject.Employee.LastPayrollDate == event1.SavedObject.PayDay)
					_companyRepository.UpdateLastPayrollDateEmployee(event1.SavedObject.Employee.Id);
				foreach (var pc in event1.AffectedChecks)
				{
					var mem = Memento<PayCheck>.Create(pc, EntityTypeEnum.PayCheck, event1.UserName, string.Format("YTD affected because of voiding of Check {0}", event1.SavedObject.CheckNumber), event1.UserId);
					_mementoDataService.AddMementoData(mem, true);
					_payrollService.PrintPayCheck(pc);
				}
			}
			catch (Exception e)
			{
				var message1 = string.Format("{0} payroll id={1}", "Error in Consuming Payroll Voided Event PayrollEventHandler", event1.SavedObject.Id);
				Log.Error(message1, e);
				throw new HrMaxxApplicationException(message1, e);
			}
			
		}

		public void Consume(InvoiceCreatedEvent event1)
		{
			try
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
					Roles = new List<RoleTypeEnum>() { RoleTypeEnum.CorpStaff, RoleTypeEnum.Master },
					AffectedUsers = users.Distinct().ToList()
				});
			}
			catch (Exception e)
			{
				var message1 = string.Format("{0} payroll id={1}", "Error in Consuming Invoice Created Event PayrollEventHandler", event1.SavedObject.Id);
				Log.Error(message1, e);
				throw new HrMaxxApplicationException(message1, e);
			}
			

		}
	}
}
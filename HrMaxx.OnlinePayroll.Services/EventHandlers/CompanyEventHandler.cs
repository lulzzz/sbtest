using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Repository;
using HrMaxx.OnlinePayroll.Repository.Companies;
using MassTransit;
using Notification = HrMaxx.Common.Contracts.Messages.Events.Notification;

namespace HrMaxx.OnlinePayroll.Services.EventHandlers
{
	public class CompanyEventHandler : BaseService, Consumes<CompanyUpdatedEvent>.All, Consumes<EmployeeUpdatedEvent>.All
	{
		public IBus Bus { get; set; }
		private readonly IUserService _userService;
		private readonly IMetaDataRepository _metaDataRepository;
		private readonly ICompanyRepository _companyRepository;

		public CompanyEventHandler(IUserService userService, IMetaDataRepository metaDataRepository,
			ICompanyRepository companyRepository)
		{
			_userService = userService;
			_metaDataRepository = metaDataRepository;
			_companyRepository = companyRepository;
		}

		public void Consume(CompanyUpdatedEvent event1)
		{
			try
			{
				_metaDataRepository.UpdateSearchTable(new SearchResult
				{
					SourceTypeId = EntityTypeEnum.Company,
					SourceId = event1.SavedObject.Id,
					CompanyId = event1.SavedObject.Id,
					HostId = event1.SavedObject.HostId,
					SearchText = event1.SavedObject.GetSearchText
				});
				//var users = _userService.GetUsers(event1.SavedObject.HostId, event1.SavedObject.Id).Select(u => u.UserId).ToList();
				//var adminUsers =
				//	_userService.GetUsersByRoleAndId(new List<RoleTypeEnum>() {RoleTypeEnum.CorpStaff, RoleTypeEnum.Master}, null);
				//users.AddRange(adminUsers);
				//Bus.Publish<Notification>(new Notification
				//{
				//	SavedObject = event1.SavedObject,
				//	SourceId = event1.SavedObject.Id,
				//	UserId = event1.UserId,
				//	Source = event1.UserName,
				//	TimeStamp = event1.TimeStamp,
				//	Text = event1.NotificationText,
				//	ReturnUrl = "#!/Client/Company/?name=" + event1.SavedObject.Name,
				//	EventType = event1.EventType,
				//	AffectedUsers = users.Distinct().ToList(),
				//	Roles = new List<RoleTypeEnum>() {RoleTypeEnum.CorpStaff, RoleTypeEnum.Master}
				//});

			}
			catch (Exception e)
			{
				var message1 = string.Format("{0} payroll id={1}", "Error in Consuming Company Update Event", event1.SavedObject.Id);
				Log.Error(message1, e);
				throw new HrMaxxApplicationException(message1, e);
			}



		}

		public void Consume(EmployeeUpdatedEvent event1)
		{
			try
			{
				var comp = _companyRepository.GetCompanyById(event1.SavedObject.CompanyId);
				_metaDataRepository.UpdateSearchTable(new SearchResult
				{
					SourceTypeId = EntityTypeEnum.Employee,
					SourceId = event1.SavedObject.Id,
					CompanyId = event1.SavedObject.CompanyId,
					HostId = comp.HostId,
					SearchText = event1.SavedObject.GetSearchText
				});
				//var users = _userService.GetUsers(null, event1.SavedObject.CompanyId).Select(u => u.UserId).ToList();

				//Bus.Publish<Notification>(new Notification
				//{
				//	SavedObject = event1.SavedObject,
				//	SourceId = event1.SavedObject.Id,
				//	UserId = event1.UserId,
				//	Source = event1.UserName,
				//	TimeStamp = event1.TimeStamp,
				//	Text = event1.NotificationText,
				//	ReturnUrl = "#!/Client/Employee/?id=" + event1.SavedObject.Id,
				//	EventType = event1.EventType,
				//	AffectedUsers = users.Distinct().ToList()
				//});
			}
			catch (Exception e)
			{
				var message1 = string.Format("{0} payroll id={1}", "Employee Update event", event1.SavedObject.Id);
				Log.Error(message1, e);
				throw new HrMaxxApplicationException(message1, e);
			}



		}
	}
} 
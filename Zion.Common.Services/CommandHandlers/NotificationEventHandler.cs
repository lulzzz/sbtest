﻿using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using Magnum;
using MassTransit;

namespace HrMaxx.Common.Services.CommandHandlers
{
	public class NotificationEventHandler : BaseService, Consumes<Notification>.All
	{
		public readonly INotificationService _NotificationService;
		public readonly IUserService _userService;
		public readonly string _baseUrl;

		public NotificationEventHandler(INotificationService notificationService, IUserService userService, string baseUrl)
		{
			_NotificationService = notificationService;
			_userService = userService;
			_baseUrl = baseUrl;
		}
		public void Consume(Notification event1)
		{
			try
			{
				var notificationList = new List<NotificationDto>();
				var notifyUsers = event1.AffectedUsers != null && event1.AffectedUsers.Any() ? event1.AffectedUsers : event1.Roles != null && event1.Roles.Any() ? _userService.GetUsersByRoleAndId(event1.Roles, null) : null;
				if (notifyUsers != null)
				{
					notifyUsers.ForEach(u => notificationList.Add(new NotificationDto
					{
						CreatedOn = DateTime.Now,
						IsRead = false,
						LoginId = u.ToString(),
						NotificationId = CombGuid.Generate(),
						Text = event1.Text,
						Type = event1.EventType.GetEnumDescription(),
						MetaData = string.Format("{0}{1}", _baseUrl, event1.ReturnUrl)
					}));
					_NotificationService.CreateNotifications(notificationList);
				}
			}
			catch (Exception e)
			{
				var message1 = string.Format("{0} payroll id={1}", "Error in Consuming Notification Event NotificationEventHandler", event1.SavedObject.Id);
				Log.Error(message1, e);
				
			}
			
			
		}
	}
}
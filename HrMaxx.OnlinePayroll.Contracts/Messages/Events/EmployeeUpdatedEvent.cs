﻿using System;
using System.Collections.Generic;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Messages.Events
{
	public class EmployeeUpdatedEvent : Event
	{
		public Employee SavedObject { get; set; }
		public Guid UserId { get; set; }
		public string UserName { get; set; }
		public DateTime TimeStamp { get; set; }
		public NotificationTypeEnum EventType;
		public string NotificationText { get; set; }
	}
}
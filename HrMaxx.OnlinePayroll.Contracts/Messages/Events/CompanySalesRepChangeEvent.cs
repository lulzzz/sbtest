using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Bus.Contracts;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Messages.Events
{
	public class CompanySalesRepChangeEvent : Event
	{
		public Company SavedObject { get; set; }
		public Guid UserId { get; set; }
		public string UserName { get; set; }
	}
}

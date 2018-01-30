using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Bus.Contracts;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.OnlinePayroll.Contracts.Messages.Events
{
	public class ConfirmPayrollEvent : Event
	{
		public Payroll Payroll { get; set; }
		public List<Journal> Journals { get; set; }
		public List<Journal> PeoJournals { get; set; } 
	}
}

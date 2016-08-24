using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HrMaxxAPI.Resources.OnlinePayroll;

namespace HrMaxxAPI.Resources.Journals
{
	public class JournalListResource
	{
		public AccountResource Account { get; set; }
		public decimal AccountBalance { get; set; }
		public List<JournalResource> Journals { get; set; } 
	}
}
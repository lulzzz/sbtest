using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class JournalList 
	{
		public Account Account { get; set; }
		public decimal AccountBalance { get; set; }
		public List<Journal> Journals { get; set; } 
	}
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class EmployeeSSNCheck
	{
		public Guid Id { get; set; }
		public string Host { get; set; }
		public string Company { get; set; }
		public string FirstName { get; set; }
		public string MiddleInitial { get; set; }
		public string LastName { get; set; }

		public string Name {
			get
			{
				return string.Format("{0}{1}{2}",
				FirstName,
				string.IsNullOrWhiteSpace(MiddleInitial) ? " " : string.Format(" {0} ", MiddleInitial),
				LastName);
			} 
		}
	}
}

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace HrMaxxAPI.Resources.Common
{
	public class BulkTerminateEmployeesResource
	{
		[Required]
		public Guid CompanyId { get; set; }
		[Required]
		public List<Guid> EmployeeList { get; set; } 
	}
}
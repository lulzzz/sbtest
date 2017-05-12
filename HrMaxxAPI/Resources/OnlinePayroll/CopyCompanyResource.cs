using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class CopyCompanyResource
	{
		[Required]
		public Guid CompanyId { get; set; }
		[Required]
		public Guid HostId { get; set; }
		public bool CopyEmployees { get; set; }
		public bool CopyPayrolls { get; set; }
		public bool KeepEmployeeNumbers { get; set; }
		public DateTime? StartDate { get; set; }
		public DateTime? EndDate { get; set; }
	}
}
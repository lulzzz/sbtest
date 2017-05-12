using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HrMaxxAPI.Resources.Common
{
	public class CopyEmployeeResource
	{
		public Guid SourceCompanyId { get; set; }
		public Guid TargetCompanyId { get; set; }
		public List<Guid> EmployeeIds { get; set; }
		public bool KeepEmployeeNumbers { get; set; }
	}
}
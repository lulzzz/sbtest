using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Attributes;

namespace HrMaxx.Common.Models.Enum
{
	public enum AddressType
	{
		NA=0,
		Personal=1,
		Business=2
	}

	public enum StatusOption
	{
		[HrMaxxSecurity(DbId = 1, DbName = "Active")]
		Active=1,
		[HrMaxxSecurity(DbId = 2, DbName = "InActive")]
		InActive=2,
		[HrMaxxSecurity(DbId = 3, DbName = "Terminated")]
		Terminated=3
	}
}

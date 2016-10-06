using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Attributes;

namespace HrMaxx.Common.Models.Enum
{
	public enum States
	{
		[HrMaxxSecurity(DbId = 1, DbName = "California", HrMaxxName = "CA")]
		California=1
	}
}

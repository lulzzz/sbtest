using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Attributes;

namespace HrMaxx.Common.Models.Enum
{
	public enum RoleTypeEnum
	{
		[HrMaxxSecurity(DbId = 1, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "Master")]
		Master=1,
		[HrMaxxSecurity(DbId = 2, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "Admin")]
		Admin=2,
		[HrMaxxSecurity(DbId = 3, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "Host")]
		Host=3,
		[HrMaxxSecurity(DbId = 4, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "Company")]
		Company=4,
		[HrMaxxSecurity(DbId = 5, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "Employee")]
		Employee=5
	}
}

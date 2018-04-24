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
		[HrMaxxSecurity(DbId = 100, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "SuperUser")]
		SuperUser = 100,
		[HrMaxxSecurity(DbId = 90, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "Master")]
		Master=90,
		[HrMaxxSecurity(DbId = 70, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "CorpStaff")]
		CorpStaff=70,
		[HrMaxxSecurity(DbId = 50, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "Host")]
		Host=50,
		[HrMaxxSecurity(DbId = 40, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "HostStaff")]
		HostStaff = 40,
		[HrMaxxSecurity(DbId = 30, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "Company")]
		Company=30,
		[HrMaxxSecurity(DbId = 10, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "CompanyManager")]
		CompanyManager = 10,
		[HrMaxxSecurity(DbId = 0, HrMaxxId = "D444F503-3354-40DF-8021-F4C9E99074B6", DbName = "Employee")]
		Employee=0
		
		
	}
}

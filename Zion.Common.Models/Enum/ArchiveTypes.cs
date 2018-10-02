using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Attributes;

namespace HrMaxx.Common.Models.Enum
{
	public enum ArchiveTypes
	{
		[HrMaxxSecurity(DbId = 0, DbName = "MasterExtracts")]
		Extract = 0,
		[HrMaxxSecurity(DbId = 1, DbName = "Mementos")]
		Mementos = 1
	}
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	public class JournalPayeeJson
	{
		public Guid Id { get; set; }
		public EntityTypeEnum PayeeType { get; set; }
		public string PayeeName { get; set; }
		public string Contact { get; set; }
		public string Address { get; set; }
	}
}

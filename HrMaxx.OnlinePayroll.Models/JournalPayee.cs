using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;

namespace HrMaxx.OnlinePayroll.Models
{
	public class JournalPayee
	{
		public Guid Id { get; set; }
		public EntityTypeEnum PayeeType { get; set; }
		public string PayeeName { get; set; }
		public Contact Contact { get; set; }
		public Address Address { get; set; }
		public string DisplayName
		{
			get { return string.Format("{0}: {1}", PayeeType.GetDbName(), PayeeName); }
		}
	}
}

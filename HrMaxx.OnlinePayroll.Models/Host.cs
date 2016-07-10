using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Host : BaseEntityDto
	{
		public string FirmName { get; set; }
		public string Url { get; set; }
		public DateTime EffectiveDate { get; set; }
		public DateTime? TerminationDate { get; set; }
		public int StatusId { get; set; }
	}
}

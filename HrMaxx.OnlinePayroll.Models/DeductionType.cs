using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class DeductionType
	{
		public int Id { get; set; }
		public string Name { get; set; }
		public DeductionCategory Category { get; set; }
		public string W2_12 { get; set; }
		public string W2_13R { get; set; }
		public string R940_R { get; set; }

		public string CategoryText
		{
			get { return Category.GetDbName(); }
		}
	}
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class PayType
	{
		public int Id { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public bool IsTaxable { get; set; }
		public bool IsAccumulable { get; set; }
		public bool IsTip { get; set; }
		public bool PaidInCash { get; set; }
	}
}

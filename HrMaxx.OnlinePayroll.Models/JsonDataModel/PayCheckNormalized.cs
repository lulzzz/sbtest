using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models.JsonDataModel
{
	public class PayCheckPayTypeAccumulation
	{
		public int PayCheckId { get; set; }
		public int PayTypeId { get; set; }
		public string PayTypeName { get; set; }
		public DateTime FiscalStart { get; set; }
		public DateTime FiscalEnd { get; set; }
		public decimal AccumulatedValue { get; set; }
		public decimal Used { get; set; }
		public decimal CarryOver { get; set; }
		public decimal YTDFiscal { get; set; }
		public decimal YTDUsed { get; set; }
		public decimal Available
		{
			get { return CarryOver + YTDFiscal - YTDUsed; }
		}
	}
}

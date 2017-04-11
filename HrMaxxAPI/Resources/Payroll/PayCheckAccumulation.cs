using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HrMaxxAPI.Resources.Payroll
{
	public class PayCheckAccumulation
	{
		public int PayCheckId { get; set; }
		public PayTypeAccumulationResource Accumulation { get; set; }
	}
}
﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.OnlinePayroll.Models
{
	public class CPAReport
	{
		public decimal CooValue { get; set; }
		public decimal SawValue { get; set; }
		public decimal PrtValue { get; set; }
		public decimal T1Value { get; set; }

		public bool IsPeo { get; set; }
	}
}

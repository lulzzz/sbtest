﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class BankAccount
	{
		public string BankName { get; set; }
		public string AccountName { get; set; }
		public BankAccountType AccountType { get; set; }
		public string AccountNumber { get; set; }
		public string RoutingNumber { get; set; }
	}
}

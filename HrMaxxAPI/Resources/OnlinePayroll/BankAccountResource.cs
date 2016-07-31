using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class BankAccountResource 
	{
		public int? Id { get; set; }
		[Required]
		public string BankName { get; set; }
		[Required]
		public string AccountName { get; set; }
		[Required]
		public BankAccountType AccountType { get; set; }
		[Required]
		public string AccountNumber { get; set; }
		[Required]
		public string RoutingNumber { get; set; }
		[Required]
		public int SourceTypeId { get; set; }
		public Guid? SourceId { get; set; }

	}
}
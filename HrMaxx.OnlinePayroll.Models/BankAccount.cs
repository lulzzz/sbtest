using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class BankAccount
	{
		public int Id { get; set; }
		public string BankName { get; set; }
		public string AccountName { get; set; }
		public BankAccountType AccountType { get; set; }
		public string AccountNumber { get; set; }
		public int RoutingNumber1 { get; set; }
		public string RoutingNumber { get; set; }
		public EntityTypeEnum SourceTypeId { get; set; }
		public Guid? SourceId { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
	}
}

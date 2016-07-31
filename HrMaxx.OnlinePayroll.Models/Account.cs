using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Account
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public AccountType Type { get; set; }
		public AccountSubType SubType { get; set; }
		public string Name { get; set; }
		public string TaxCode { get; set; }
		public decimal OpeningBalance { get; set; }
		public DateTime OpeningDate { get; set; }
		public int? TemplateId { get; set; }
		public BankAccount BankAccount { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
	}
}

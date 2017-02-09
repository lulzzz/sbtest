using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;
using Magnum.Calendar.Holidays;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class AccountResource
	{
		public int? Id { get; set; }
		public Guid CompanyId { get; set; }
		public AccountType Type { get; set; }
		public AccountSubType SubType { get; set; }
		public string Name { get; set; }
		public string TaxCode { get; set; }
		public decimal OpeningBalance { get; set; }
		public DateTime? OpeningDate { get; set; }
		public int? TemplateId { get; set; }
		public BankAccountResource BankAccount { get; set; }
		public DateTime LastModified { get; set; }
		public string LastModifiedBy { get; set; }
		public bool UseInPayroll { get; set; }
		public bool UsedInInvoiceDeposit { get; set; }

		public string TypeText { get { return Type.GetDbName(); } }
		public string SubTypeText { get { return SubType.GetDbName(); } }
	}
}
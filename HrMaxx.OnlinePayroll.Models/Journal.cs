﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class Journal : IOriginator<Journal>
	{
		public int Id { get; set; }
		public Guid CompanyId { get; set; }
		public TransactionType TransactionType { get; set; }
		public EmployeePaymentMethod PaymentMethod { get; set; }
		public int CheckNumber { get; set; }
		public int? PayrollPayCheckId { get; set; }
		public EntityTypeEnum EntityType { get; set; }
		public Guid PayeeId { get; set; }
		public string PayeeName { get; set; }
		public decimal Amount { get; set; }
		public int MainAccountId { get; set; }
		public DateTime TransactionDate { get; set; }
		public DateTime? OriginalDate { get; set; }
		public string Memo { get; set; }
		public bool IsDebit { get; set; }
		public bool IsVoid { get; set; }
		public List<JournalDetail> JournalDetails { get; set; } 
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
		public Guid DocumentId { get; set; }

		public bool PEOASOCoCheck { get; set; }

		public int EntityType1
		{
			get
			{
				return TransactionType == TransactionType.RegularCheck
					? (int)EntityTypeEnum.RegularCheck
					: TransactionType == TransactionType.PayCheck
						? (int)EntityTypeEnum.PayCheck
						: TransactionType == TransactionType.Deposit
							? (int)EntityTypeEnum.Deposit
							: TransactionType == TransactionType.Adjustment ? (int)EntityTypeEnum.Adjustment : (int)EntityTypeEnum.TaxPayment;
			}
		}
		public Guid MementoId
		{
			get
			{
				var str = string.Format("{0}-0000-0000-0000-{1}", EntityType1.ToString().PadLeft(8, '0'),
					TransactionType==TransactionType.PayCheck? PayrollPayCheckId.Value.ToString().PadLeft(12,'0') : Id.ToString().PadLeft(12, '0'));
				return new Guid(str);
			}
		}
		public void ApplyMemento(Memento<Journal> memento)
		{
			throw new NotImplementedException();
		}
	}

	public class JournalDetail
	{
		public int AccountId { get; set; }
		public string AccountName { get; set; }
		public bool IsDebit { get; set; }
		public decimal Amount { get; set; }
		public string Memo { get; set; }
		public VendorDepositMethod DepositMethod { get; set; }
		public VendorCustomer Payee { get; set; }
		public int CheckNumber { get; set; }
		public DateTime LastModfied { get; set; }
		public string LastModifiedBy { get; set; }
	}
}

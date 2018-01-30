using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxxAPI.Resources.Journals
{
	public class JournalResource
	{
		public int? Id { get; set; }
		[Required]
		public Guid CompanyId { get; set; }
		public int CompanyIntId { get; set; }
		[Required]
		public TransactionType TransactionType { get; set; }
		[Required]
		public EmployeePaymentMethod PaymentMethod { get; set; }
		[Required]
		public int CheckNumber { get; set; }
		public int? PayrollPayCheckId { get; set; }
		public Guid? PayrollId { get; set; }
		[Required]
		public EntityTypeEnum EntityType { get; set; }

		public int EntityType1 { get; set; }
		public Guid MementoId { get; set; }

		public Guid PayeeId { get; set; }
		
		public string PayeeName { get; set; }
		[Required]
		public decimal Amount { get; set; }
		[Required]
		public int MainAccountId { get; set; }
		[Required]
		public DateTime TransactionDate { get; set; }
		public DateTime? OriginalDate { get; set; }
		public string Memo { get; set; }
		[Required]
		public bool IsDebit { get; set; }
		[Required]
		public bool IsVoid { get; set; }
		[Required]
		public List<JournalDetailResource> JournalDetails { get; set; }
		public string LastModifiedBy { get; set; }
		public DateTime LastModified { get; set; }
		public Guid? DocumentId { get; set; }

		public bool PEOASOCoCheck { get; set; }
		public bool IsReIssued { get; set; }
		public int? OriginalCheckNumber { get; set; }
		public DateTime? ReIssuedDate { get; set; }

		public decimal DisplayAmount
		{
			get { return (IsDebit ? Amount*-1 : Amount); }
		}

		public string TransactionTypeText
		{
			get { return TransactionType.GetDbName(); }
		}

		public string PaymentMethodText
		{
			get { return TransactionType==TransactionType.Deposit || TransactionType==TransactionType.InvoiceDeposit ? string.Empty : PaymentMethod.GetDbName(); }
		}

		public string CheckNumberText
		{
			get { return TransactionType == TransactionType.Deposit || TransactionType == TransactionType.InvoiceDeposit ? string.Empty : PaymentMethod == EmployeePaymentMethod.Check ? CheckNumber.ToString() : "EFT"; }
		}

		public string StatusText
		{
			get { return IsVoid ? "Void" : string.Empty; }
		}
	}

	public class JournalDetailResource
	{
		[Required]
		public int AccountId { get; set; }
		[Required]
		public string AccountName { get; set; }
		[Required]
		public bool IsDebit { get; set; }
		[Required]
		public decimal Amount { get; set; }
		public string Memo { get; set; }
		public VendorDepositMethod DepositMethod { get; set; }
		public JournalPayee Payee { get; set; }
		public int CheckNumber { get; set; }
		public DateTime LastModfied { get; set; }
		public string LastModifiedBy { get; set; }
		public bool Deposited { get; set; }
		public Guid? InvoiceId { get; set; }
		public int PaymentId { get; set; }
	}
}
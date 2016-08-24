using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Models
{
	public class AccountWithJournal
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
		public bool UseInPayroll { get; set; }

		public List<AccountRegister> Journals { get; set; }
		public decimal AccountBalance { get; set; }

		public string TypeText { get { return Type.GetDbName(); } }
		public string SubTypeText { get { return SubType.GetDbName(); } }

		public void MakeRegister(List<Journal> journals, List<Account> accounts )
		{
			Journals = new List<AccountRegister>();
			foreach (var journal in journals.Where(j=>j.TransactionType!=TransactionType.Adjustment))
			{
				foreach (var detail in journal.JournalDetails.Where(jd=>jd.AccountId==Id))
				{
					Journals.Add(new AccountRegister
					{
						TransactionDate = journal.TransactionDate,
						TransactionType = journal.TransactionType,
						CheckNumber = journal.TransactionType == TransactionType.Deposit? detail.CheckNumber : journal.CheckNumber,
						DepositMethod = journal.TransactionType == TransactionType.Deposit?detail.DepositMethod:VendorDepositMethod.Check,
						FromAccount = (Id == journal.MainAccountId) ? (journal.TransactionType == TransactionType.Deposit ? string.Empty : accounts.First(a => a.Id == journal.MainAccountId).AccountName) : accounts.First(a => a.Id == journal.MainAccountId).AccountName,
						ToAccount = (Id == journal.MainAccountId) ? (journal.TransactionType == TransactionType.Deposit ? accounts.First(a => a.Id == journal.MainAccountId).AccountName : string.Empty) : AccountName,
						Amount = detail.Amount,
						Memo = detail.Memo,
						IsDebit = detail.IsDebit,
						Payee = journal.TransactionType == TransactionType.Deposit ? (detail.Payee!=null? detail.Payee.Name: string.Empty) : journal.PayeeName,
						IsVoid = journal.IsVoid
					});
				}
			}
			foreach (var journal in journals.Where(j => j.TransactionType == TransactionType.Adjustment))
			{
				foreach (var detail in journal.JournalDetails)
				{
					if (detail.AccountId == Id)
					{
						var otherAccount = journal.JournalDetails.First(jd => jd.AccountId != Id);
						Journals.Add(new AccountRegister
						{
							TransactionDate = journal.TransactionDate,
							TransactionType = journal.TransactionType,
							CheckNumber = journal.CheckNumber,
							DepositMethod = VendorDepositMethod.Check,
							FromAccount = accounts.First(a => a.Id == otherAccount.AccountId).AccountName,
							ToAccount = Name,
							Amount = detail.Amount,
							Memo = detail.Memo,
							IsDebit = detail.IsDebit,
							IsVoid = journal.IsVoid,
							Payee = string.Empty
						});
					}
					
				}
			}
		}
		public string AccountName
		{
			get { return string.Format("{0}: {1}: {2}", Type.GetDbName(), SubType.GetDbName(), Name); }
		}

		public bool IsBank
		{
			get { return Type == AccountType.Assets && SubType == AccountSubType.Bank; }
		}
		
	}

	public class AccountRegister
	{
		public DateTime TransactionDate { get; set; }
		public TransactionType TransactionType { get; set; }
		public VendorDepositMethod DepositMethod { get; set; }
		public bool IsDebit { get; set; }
		public bool IsVoid { get; set; }
		public int CheckNumber { get; set; }
		public string FromAccount { get; set; }
		public string ToAccount { get; set; }
		public string Payee { get; set; }
		public decimal Amount { get; set; }
		public string Memo { get; set; }

		public string TransactionTypeText
		{
			get { return TransactionType.GetDbName(); }
		}

		public string CheckNumberText
		{
			get { return TransactionType == TransactionType.Deposit ? string.Empty : CheckNumber>0 ? CheckNumber.ToString() : "EFT"; }
		}

		public string StatusText
		{
			get { return IsVoid ? "Void" : string.Empty; }
		}
		public decimal DisplayAmount
		{
			get { return (IsDebit ? Amount * -1 : Amount); }
		}
	}

}

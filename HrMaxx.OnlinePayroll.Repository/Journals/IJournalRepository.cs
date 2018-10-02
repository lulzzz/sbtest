using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Repository.Journals
{
	public interface IJournalRepository
	{
		Journal SaveJournal(Journal journal, bool isPEOCheck = false, bool peoPayroll = false);
		Journal SaveCheckbookJournal(Journal journal, bool isPEOCheck = false, bool peoPayroll = false);
		
		Journal VoidJournal(Journal id, TransactionType transactionType, string name);
		Journal UnVoidJournal(Journal id, TransactionType transactionType, string name);
		

		MasterExtract SaveMasterExtract(MasterExtract masterExtract, List<int> payCheckIds, List<int> voidedCheckIds, List<Journal> journalList);
		
		List<Journal> GetJournalListForPositivePay(Guid? companyId, DateTime startDate, DateTime endDate);
		void FixMasterExtractPayCheckMapping(MasterExtract masterExtract, List<int> payCheckIds, List<int> voidedCheckIds);
		void DeleteJournals(int journals);
		
		decimal GetJournalBalance(int accountId);
		void DeletePayrollJournals(List<Journal> toList);
	}
}

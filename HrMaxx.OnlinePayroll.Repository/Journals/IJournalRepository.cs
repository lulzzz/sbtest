using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Repository.Journals
{
	public interface IJournalRepository
	{
		Journal SaveJournal(Journal journal, bool isPEOCheck = false);
		Journal GetPayCheckJournal(int payCheckId, bool peoasoCoCheck);
		Journal VoidJournal(int id, TransactionType transactionType, string name);
		List<Journal> GetJournalList(Guid companyId, int accountId, DateTime? startDate, DateTime? endDate);
		List<Journal> GetCompanyJournals(Guid? companyId, DateTime? startDate, DateTime? endDate);

		MasterExtract SaveMasterExtract(MasterExtract masterExtract, List<int> payCheckIds, List<int> voidedCheckIds);
		List<Journal> GetPayrollJournals(Guid payrollId, bool peoasoCoCheck);
		MasterExtract FixMasterExtract(MasterExtract masterExtract);
		Models.Journal GetJournalById(int id);
		List<Journal> GetJournalListForPositivePay(Guid? companyId, DateTime startDate, DateTime endDate);
		void FixMasterExtractPayCheckMapping(MasterExtract masterExtract, List<int> payCheckIds, List<int> voidedCheckIds);
	}
}

using System;
using System.Collections.Generic;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Repository.Journals
{
	public interface IJournalRepository
	{
		Journal SaveJournal(Journal journal);
		Journal GetPayCheckJournal(int payCheckId, bool peoasoCoCheck);
		Journal VoidJournal(int id, TransactionType transactionType, string name);
		List<Journal> GetJournalList(Guid companyId, int accountId, DateTime? startDate, DateTime? endDate);
		List<Journal> GetCompanyJournals(Guid companyId, DateTime? startDate, DateTime? endDate);
		
	}
}

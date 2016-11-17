using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;

namespace HrMaxx.OnlinePayroll.Contracts.Services
{
	public interface IJournalService
	{
		Journal SaveJournalForPayroll(Journal journal);
		Journal GetPayCheckJournal(int payCheckId, bool PEOASOCoCheck = false);
		Journal VoidJournal(int id, TransactionType payCheck, string name, Guid guid);
		JournalList GetJournalListByCompanyAccount(Guid companyId, int accountId, DateTime? startDate, DateTime? endDate);
		List<AccountWithJournal> GetCompanyAccountsWithJournals(Guid companyId, int accountId, DateTime? startDate, DateTime? endDate);
		Journal SaveCheckbookEntry(Journal mapped, Guid guid);
		Journal VoidCheckbookEntry(Journal mapped, Guid guid);
		FileDto Print(Journal mapped);
		List<AccountWithJournal> GetCompanyAccountsWithJournalsForTypes(Guid companyId, DateTime? startDate, DateTime? endDate, List<AccountType> accountTypes);
		List<Journal> GetJournalList(Guid companyId, DateTime startDate, DateTime endDate);
		MasterExtract FileTaxes(Extract extract, string fullName);
	}
}
﻿using System;
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
		Journal GetPayCheckJournal(int payCheckId);
		Journal VoidJournal(int id, TransactionType payCheck, string name);
		JournalList GetJournalListByCompanyAccount(Guid companyId, int accountId, DateTime? startDate, DateTime? endDate);
		List<AccountWithJournal> GetCompanyAccountsWithJournals(Guid companyId, int accountId, DateTime? startDate, DateTime? endDate);
		Journal SaveCheckbookEntry(Journal mapped);
		Journal VoidCheckbookEntry(Journal mapped);
	}
}
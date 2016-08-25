﻿namespace HrMaxxAPI.Controllers.Journals
{
	public class JournalRoutes
	{
		public const string JournalList = "Journal/AccountJournals";
		public const string GetJournalMetaData = "Journal/MetaData/{companyId:guid}";
		public const string SaveJournal = "Journal/Journal";
		public const string AccountWithJournalList = "Journal/Accounts";
		public const string VoidJournal = "Journal/Void";
	}
}
namespace HrMaxxAPI.Controllers.Journals
{
	public class JournalRoutes
	{
		public const string JournalList = "Journal/AccountJournals";
		public const string GetJournalMetaData = "Journal/MetaData/{companyId:guid}/{companyIntId:int}";
		public const string GetVendorInvoiceMetaData = "Journal/VendorInvoiceMetaData/{companyId:guid}/{companyIntId:int}";
		public const string SaveJournal = "Journal/Journal";
		public const string AccountWithJournalList = "Journal/Accounts";
		public const string VoidJournal = "Journal/Void";
		public const string Print = "Journal/Print";
		public const string MarkJournalCleared = "Journal/MarkJournalCleared";

		public const string VendorInvoiceList = "Journal/VendorInvoices";
		public const string SaveVendorInvoice = "Journal/SaveVendorInvoice";
		public const string VoidVendorInvoice = "Journal/VoidInvoice";
	}
}
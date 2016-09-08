using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Windows.Markup;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Journals;
using Magnum;

namespace HrMaxx.OnlinePayroll.Services.Journals
{
	public class JournalService : BaseService, IJournalService
	{
		private readonly IJournalRepository _journalRepository;
		private readonly ICompanyService _companyService;
		private readonly IPDFService _pdfService;

		public JournalService(IJournalRepository journalRepository, ICompanyService companyService, IPDFService pdfService)
		{
			_journalRepository = journalRepository;
			_companyService = companyService;
			_pdfService = pdfService;
		}

		public Models.Journal SaveJournalForPayroll(Models.Journal journal)
		{
			try
			{
				return _journalRepository.SaveJournal(journal);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Save Journal");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Journal GetPayCheckJournal(int payCheckId)
		{
			try
			{
				return _journalRepository.GetPayCheckJournal(payCheckId);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Journal for Pay Check Id=" + payCheckId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Journal VoidJournal(int id, TransactionType transactionType, string name)
		{
			try
			{
				return _journalRepository.VoidJournal(id, transactionType, name);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Void Journal with id=" + id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public JournalList GetJournalListByCompanyAccount(Guid companyId, int accountId, DateTime? startDate, DateTime? endDate)
		{
			try
			{
				var coa = _companyService.GetComanyAccounts(companyId).First(c=>c.Id==accountId);
				var journals = _journalRepository.GetJournalList(companyId, accountId, startDate, endDate);
				var openingBalance = (decimal)0;
				if (!startDate.HasValue && !endDate.HasValue)
					openingBalance = coa.OpeningBalance;
				else if (!startDate.HasValue && coa.OpeningDate.Date <= endDate.Value.Date)
					openingBalance = coa.OpeningBalance;
				else if(startDate.HasValue && endDate.HasValue && coa.OpeningDate.Date>=startDate.Value.Date && coa.OpeningDate.Date<=endDate.Value.Date )
				{
					openingBalance = coa.OpeningBalance;
				}
				var journalDetails = journals.Where(j=>!j.IsVoid).SelectMany(j=>j.JournalDetails.Where(jd=>jd.AccountId==accountId)).ToList();
				var credits = journalDetails.Where(jd => !jd.IsDebit).Sum(jd => jd.Amount);
				var debits = journalDetails.Where(jd => jd.IsDebit).Sum(jd => jd.Amount);
				
				return new JournalList
				{
					Account = coa,
					AccountBalance = Math.Round(openingBalance + credits - debits, 2, MidpointRounding.AwayFromZero),
					Journals = journals
				};
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Journal List for Account Id=" + accountId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<AccountWithJournal> GetCompanyAccountsWithJournals(Guid companyId, int accountId, DateTime? startDate, DateTime? endDate)
		{
			try
			{
				var dbcoas = _companyService.GetComanyAccounts(companyId);
				var coas = Mapper.Map<List<Account>, List<AccountWithJournal >> (dbcoas);
				var journals = _journalRepository.GetCompanyJournals(companyId, startDate, endDate);
				coas.ForEach(coa =>
				{
					coa.MakeRegister(journals.Where(j => j.MainAccountId == coa.Id || j.JournalDetails.Any(jd => jd.AccountId == coa.Id)).ToList(), dbcoas);
					var openingBalance = (decimal)0;
					if (!startDate.HasValue && !endDate.HasValue)
						openingBalance = coa.OpeningBalance;
					else if (!startDate.HasValue && coa.OpeningDate.Date <= endDate.Value.Date)
						openingBalance = coa.OpeningBalance;
					else if (startDate.HasValue && endDate.HasValue && coa.OpeningDate.Date >= startDate.Value.Date && coa.OpeningDate.Date <= endDate.Value.Date)
					{
						openingBalance = coa.OpeningBalance;
					}
					var credits = coa.Journals.Where(j => !j.IsVoid && !j.IsDebit).Sum(j => j.Amount);
					var debits = coa.Journals.Where(j => !j.IsVoid && j.IsDebit).Sum(j => j.Amount);
					coa.AccountBalance = Math.Round(openingBalance + credits - debits, 2, MidpointRounding.AwayFromZero);
				});
				return coas;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Account list with journals for company id =" + companyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Journal SaveCheckbookEntry(Journal journal)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					journal.PayrollPayCheckId = null;

					if ((journal.TransactionType == TransactionType.RegularCheck || journal.TransactionType == TransactionType.Deposit) &&
					    journal.PayeeId == Guid.Empty)
					{
						if (journal.EntityType == EntityTypeEnum.Vendor || journal.EntityType == EntityTypeEnum.Customer)
						{
							var vc = new VendorCustomer(CombGuid.Generate(), journal.CompanyId, journal.PayeeName,
								journal.EntityType == EntityTypeEnum.Vendor, journal.LastModifiedBy);
							var savedVC = _companyService.SaveVendorCustomers(vc);
							journal.PayeeId = savedVC.Id;
						}
					}
					var saved =  _journalRepository.SaveJournal(journal);
					txn.Complete();
					return saved;
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Save Journal");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Journal VoidCheckbookEntry(Journal mapped)
		{
			try
			{
				return _journalRepository.VoidJournal(mapped.Id, mapped.TransactionType, mapped.LastModifiedBy);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Void Journal id=" + mapped.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private FileDto PrintRegularCheck(IEnumerable<Account> coas, Company company, Journal journal)
		{
			var enumerable = coas as Account[] ?? coas.ToArray();
			var bankcoa = enumerable.First(c => c.Id == journal.MainAccountId);
			var vc = _companyService.GetVendorCustomersById(journal.PayeeId);
			var pdf = new PDFModel
			{
				Name = string.Format("Check_{1}_{2} {0}.pdf", journal.TransactionDate.ToString("MMddyyyy"), journal.CompanyId, journal.Id),
				TargetId = journal.Id,
				NormalFontFields = new List<KeyValuePair<string, string>>(),
				BoldFontFields = new List<KeyValuePair<string, string>>(),
				TargetType = EntityTypeEnum.PayCheck,
				Template = PDFTemplate(company.PayCheckStock, journal.TransactionType),
				DocumentId = journal.DocumentId
			};

			var words = Utilities.NumberToWords(Math.Floor(journal.Amount));
			var decPlaces = (int)(((decimal)journal.Amount % 1) * 100);

			if (journal.PaymentMethod == EmployeePaymentMethod.DirectDebit)
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("dd-spec", "NON-NEGOTIABLE     DIRECT DEPOSIT"));

			if (company.PayCheckStock != PayCheckStock.MICRQb)
			{
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("Name", company.Name));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Address", company.CompanyAddress.AddressLine1));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("City", company.CompanyAddress.AddressLine2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Amount", "***" + journal.Amount.ToString("c")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("AmtInWords", string.Format("{0} {1}/100 {2}", words, decPlaces, "*******")));
			}
			else
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Amount", journal.Amount.ToString("c")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("AmtInWords", string.Format("{0} {1}/100", words, decPlaces)));
			}
			pdf.BoldFontFields.Add(new KeyValuePair<string, string>("compName", company.Name));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compAddress", company.CompanyAddress.AddressLine1));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compCity", company.CompanyAddress.AddressLine2));

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName", vc.Name));
			if (vc.Contact != null && vc.Contact.Address != null)
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text1", vc.Contact.Address.AddressLine1));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text3", vc.Contact.Address.AddressLine2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text3", vc.Contact.Address.AddressLine2));
			}

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date", journal.TransactionDate.ToString("MM/dd/yyyy")));



			if (company.PayCheckStock != PayCheckStock.MICREncodedTop)
			{
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo", journal.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : journal.CheckNumber.ToString()));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo2", journal.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : journal.CheckNumber.ToString()));
				if (company.PayCheckStock != PayCheckStock.MICRQb)
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Bank", bankcoa.BankAccount.BankName));
					if (journal.PaymentMethod == EmployeePaymentMethod.Check)
					{
						var micr = "00000000";
						micr =
							micr.Substring(0,
								(8 - journal.CheckNumber.ToString().Length) < 0 ? 0 : 8 - journal.CheckNumber.ToString().Length) +
							journal.CheckNumber.ToString();
						var micrVal = string.Format("C{0}CA{1}A{2}C", micr, bankcoa.BankAccount.RoutingNumber,
							bankcoa.BankAccount.AccountNumber);
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("MICR", micrVal));
					}

				}
			}
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Memo", journal.Memo));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum1", "Check Date: " + journal.TransactionDate.ToString("MM/dd/yyyy")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Caption8", string.Format("Payee : {0}{1} Amount: {2}", vc.Name, "".PadRight(160 - vc.Name.Length - journal.Amount.ToString("c").Length), journal.Amount.ToString("c"))));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum2", "Memo on Check:    " + journal.Memo));

			var counter = 1;
			foreach (var jd in journal.JournalDetails.Where(jd => jd.AccountId != journal.MainAccountId))
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Acct" + counter.ToString(), enumerable.First(coa => coa.Id == jd.AccountId).AccountName));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Amt" + counter.ToString(), jd.Amount.ToString("c")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Memo" + counter.ToString(), jd.Memo));
				counter++;
			}

			if (company.PayCheckStock == PayCheckStock.LaserMiddle && counter > 5)
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compName-3", company.Name));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("CheckNo2-3", journal.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : journal.CheckNumber.ToString()));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum1-3", "Check Date: " + journal.TransactionDate.ToString("MM/dd/yyyy")));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Caption9-3", "Account"));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Sum2-3", "Memo on Check:    " + journal.Memo));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Caption81-3", "Amount"));

			}


			return _pdfService.Print(pdf);
		}

		private FileDto PrintDepositTicket(IEnumerable<Account> coas, Company company, Journal journal)
		{
			var enumerable = coas as IList<Account> ?? coas.ToList();
			var bankcoa = enumerable.First(c => c.Id == journal.MainAccountId);
			
			var pdf = new PDFModel
			{
				Name = string.Format("Check_{1}_{2} {0}.pdf", journal.TransactionDate.ToString("MMddyyyy"), journal.CompanyId, journal.Id),
				TargetId = journal.Id,
				NormalFontFields = new List<KeyValuePair<string, string>>(),
				BoldFontFields = new List<KeyValuePair<string, string>>(),
				TargetType = EntityTypeEnum.PayCheck,
				Template = PDFTemplate(company.PayCheckStock, journal.TransactionType),
				DocumentId = journal.DocumentId
			};

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("depTicket", "Deposit Ticket"));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compName", company.Name));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compAddress", company.CompanyAddress.AddressLine1));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("compCity", company.CompanyAddress.AddressLine2));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date", "Date: " + journal.TransactionDate.ToString("MM/dd/yyyy")));

			var counter = 0;
			foreach (var jd in journal.JournalDetails.Where(jd => jd.AccountId != journal.MainAccountId))
			{
				if (counter < 20)
				{
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("num1." + counter.ToString(), (counter + 1).ToString()));
					pdf.NormalFontFields.Add(new KeyValuePair<string, string>("amt1." + counter.ToString(), jd.Amount.ToString("c")));
					if (jd.DepositMethod == VendorDepositMethod.Cash)
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Memo1." + counter.ToString(), "Cash"));
					else
					{
						var vc = _companyService.GetVendorCustomersById(jd.Payee.Id);
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Memo1." + counter.ToString(), vc.Name));
					}
				}
				
				counter++;
			}

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("total", "Total : " + journal.JournalDetails.Where(jd=>jd.AccountId!=journal.MainAccountId).Sum(jd=>jd.Amount).ToString("c")));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Bank", bankcoa.BankAccount.BankName));
			var micr = "00000000";
			micr =
				micr.Substring(0,
					(8 - journal.CheckNumber.ToString().Length) < 0 ? 0 : 8 - journal.CheckNumber.ToString().Length) +
				journal.CheckNumber.ToString();
			var micrVal = string.Format("C{0}CA{1}A{2}C", micr, bankcoa.BankAccount.RoutingNumber,
				bankcoa.BankAccount.AccountNumber);
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("MICR", micrVal));
			return _pdfService.Print(pdf);
		}

		public FileDto Print(Journal journal)
		{
			try
			{
				var coas = _companyService.GetComanyAccounts(journal.CompanyId);
				var company = _companyService.GetCompanyById(journal.CompanyId);
				if(journal.TransactionType==TransactionType.RegularCheck)
					return PrintRegularCheck(coas, company, journal);
				else //if (journal.TransactionType == TransactionType.Deposit)
					return PrintDepositTicket(coas, company, journal);

			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " print Journal id=" + journal.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private string PDFTemplate(PayCheckStock payCheckStock, TransactionType transactionType)
		{
			if (transactionType == TransactionType.RegularCheck)
			{
				if (payCheckStock == PayCheckStock.MICRQb)
					return "RegCheckQB.pdf";
				if (payCheckStock == PayCheckStock.LaserTop)
					return "RegCheckDeluxe.pdf";
				if (payCheckStock == PayCheckStock.LaserMiddle)
					return "RegCheckMiddle.pdf";
				if (payCheckStock == PayCheckStock.MICREncodedTop)
					return "RegCheck.pdf";

			}
			else if (transactionType == TransactionType.Deposit)
			{
				return "DepositTicket.pdf";

			}
			return string.Empty;
		}
	}
}

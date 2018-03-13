using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Windows.Markup;
using System.Xml;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Files;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Contracts.Messages.Events;
using HrMaxx.OnlinePayroll.Contracts.Resources;
using HrMaxx.OnlinePayroll.Contracts.Services;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.Enum;
using HrMaxx.OnlinePayroll.Repository.Journals;
using Magnum;
using Magnum.FileSystem;
using Newtonsoft.Json;

namespace HrMaxx.OnlinePayroll.Services.Journals
{
	public class JournalService : BaseService, IJournalService
	{
		private readonly IJournalRepository _journalRepository;
		private readonly ICompanyService _companyService;
		private readonly IPDFService _pdfService;
		private readonly IMementoDataService _mementoDataService;
		private readonly ICommonService _commonService;
		private readonly IFileRepository _fileRepository;
		private readonly IReaderService _readerService;
		private readonly IDocumentService _documentService;
		public IBus Bus { get; set; }

		public JournalService(IJournalRepository journalRepository, ICompanyService companyService, IPDFService pdfService, IMementoDataService mementoDataService, ICommonService commonService, IFileRepository fileRepository, IReaderService readerService, IDocumentService documentService)
		{
			_journalRepository = journalRepository;
			_companyService = companyService;
			_pdfService = pdfService;
			_mementoDataService = mementoDataService;
			_fileRepository = fileRepository;
			_commonService = commonService;
			_readerService = readerService;
			_documentService = documentService;
		}

		public Journal SaveJournalForPayroll(Journal journal, Company company)
		{
			try
			{
				var j = _journalRepository.SaveJournal(journal, journal.PEOASOCoCheck, company.Contract.BillingOption == BillingOptions.Invoice &&
							company.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck);
				return j;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Save Journal");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	
		public Journal GetPayCheckJournal(int payCheckId, bool PEOASOCoCheck = false)
		{
			try
			{
				var j = _readerService.GetJournals(payCheckId: payCheckId, PEOASOCoCheck: PEOASOCoCheck);
				return j.First();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Journal for Pay Check Id=" + payCheckId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		public List<Journal> GetPayrollJournals(Guid payrollId, bool PEOASOCoCheck = false)
		{
			try
			{
				var j1 = _readerService.GetJournals(payrollId: payrollId, PEOASOCoCheck: PEOASOCoCheck);
				return j1;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Journals for Payroll Id=" + payrollId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Journal VoidJournal(Journal journal, TransactionType transactionType, string name, Guid userId)
		{
			try
			{
				var j = _journalRepository.VoidJournal(journal, transactionType, name);
				if (transactionType != TransactionType.PayCheck)
				{
					var memento = Memento<Journal>.Create(j, (EntityTypeEnum)j.EntityType1, name, string.Format("Check voided"), userId);
					_mementoDataService.AddMementoData(memento);	
				}
				
				return j;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Void Journal with id=" + journal.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Journal UnVoidJournal(Journal journal, TransactionType transactionType, string name, Guid userId)
		{
			try
			{
				var j = _journalRepository.UnVoidJournal(journal, transactionType, name);
				if (transactionType != TransactionType.PayCheck)
				{
					var memento = Memento<Journal>.Create(j, (EntityTypeEnum)j.EntityType1, name, string.Format("Check un-voided"), userId);
					_mementoDataService.AddMementoData(memento);
				}

				return j;
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, "Un-Void Journal with id=" + journal.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public JournalList GetJournalListByCompanyAccount(Guid companyId, int accountId, DateTime? startDate, DateTime? endDate)
		{
			try
			{
				var coa = _companyService.GetComanyAccounts(companyId).First(c=>c.Id==accountId);
				
				var journals = _readerService.GetJournals(companyId: companyId, accountId: accountId, startDate: startDate,
					endDate: endDate);
				
				var openingBalance = (decimal)0;
				if (!startDate.HasValue && !endDate.HasValue)
					openingBalance = coa.OpeningBalance;
				else if (!startDate.HasValue && coa.OpeningDate.Date <= endDate.Value.Date)
					openingBalance = coa.OpeningBalance;
				else if(startDate.HasValue && endDate.HasValue && coa.OpeningDate.Date>=startDate.Value.Date && coa.OpeningDate.Date<=endDate.Value.Date )
				{
					openingBalance = coa.OpeningBalance;
				}
				var journalBalance = _journalRepository.GetJournalBalance(accountId);
				
				return new JournalList
				{
					Account = coa,
					AccountBalance = Math.Round(openingBalance + journalBalance, 2, MidpointRounding.AwayFromZero),
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
				var journals = _readerService.GetJournals(companyId: companyId, startDate: startDate, endDate: endDate);
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

		private Journal SaveCheckbookEntryNoTran(Journal journal, Guid userId)
		{
			try
			{
				
					journal.PayrollPayCheckId = null;

					if (journal.TransactionType == TransactionType.RegularCheck && journal.PayeeId == Guid.Empty)
					{
						if (journal.EntityType == EntityTypeEnum.Vendor)
						{
							var vc = new VendorCustomer();
							vc.SetVendorCustomer(CombGuid.Generate(), journal.CompanyId, journal.PayeeName,
								journal.EntityType == EntityTypeEnum.Vendor, journal.LastModifiedBy);
							var savedVC = _companyService.SaveVendorCustomers(vc);
							journal.PayeeId = savedVC.Id;
							journal.PayeeName = savedVC.Name;
						}
					}
					else if ((journal.TransactionType == TransactionType.Deposit || journal.TransactionType == TransactionType.InvoiceDeposit) && journal.JournalDetails.Any(jd => jd.Payee != null && jd.Payee.Id == Guid.Empty))
					{
						var newVendors = new List<JournalPayee>();
						var jds = journal.JournalDetails.Where(jd => jd.Payee != null && jd.Payee.Id == Guid.Empty).ToList();
						jds.ForEach(p =>
						{
							if (newVendors.Any(v => v.PayeeName.Equals(p.Payee.PayeeName)))
							{
								p.Payee = newVendors.First(v => v.PayeeName.Equals(p.Payee.PayeeName));
							}
							else
							{
								var vc = new VendorCustomer();
								vc.SetVendorCustomer(CombGuid.Generate(), journal.CompanyId, p.Payee.PayeeName,
									true, journal.LastModifiedBy);
								var savedVC = _companyService.SaveVendorCustomers(vc);
								p.Payee.Id = savedVC.Id;
								p.Payee.PayeeType = EntityTypeEnum.Vendor;
								newVendors.Add(p.Payee);
							}


						});

					}
					var saved = _journalRepository.SaveCheckbookJournal(journal);
					if (journal.TransactionType == TransactionType.InvoiceDeposit)
					{
						Bus.Publish<InvoiceDepositUpdateEvent>(new InvoiceDepositUpdateEvent()
						{
							Journal = saved,
							UserId = userId,
							UserName = saved.LastModifiedBy,
							TimeStamp = DateTime.Now
						});
					}
					var memento = Memento<Journal>.Create(saved, (EntityTypeEnum)saved.EntityType1, saved.LastModifiedBy, string.Format("Check updated {0}", journal.CheckNumber), userId);
					_mementoDataService.AddMementoData(memento);
					
					return saved;
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Save Journal No Tran " + journal.Id + ", CheckNumber=" + journal.CheckNumber + ", TransactionType=" + (int)journal.TransactionType );
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Journal SaveCheckbookEntry(Journal journal, Guid userId)
		{
			try
			{
				using (var txn = TransactionScopeHelper.Transaction())
				{
					journal.PayrollPayCheckId = null;

					if (journal.TransactionType == TransactionType.RegularCheck  && journal.PayeeId == Guid.Empty)
					{
						if (journal.EntityType == EntityTypeEnum.Vendor)
						{
							var vc = new VendorCustomer();
							vc.SetVendorCustomer(CombGuid.Generate(), journal.CompanyId, journal.PayeeName,
								journal.EntityType == EntityTypeEnum.Vendor, journal.LastModifiedBy);
							var savedVC = _companyService.SaveVendorCustomers(vc);
							journal.PayeeId = savedVC.Id;
							journal.PayeeName = savedVC.Name;
						}
					}
					else if ((journal.TransactionType == TransactionType.Deposit || journal.TransactionType == TransactionType.InvoiceDeposit) && journal.JournalDetails.Any(jd => jd.Payee != null && jd.Payee.Id == Guid.Empty))
					{
						var newVendors = new List<JournalPayee>();
						var jds = journal.JournalDetails.Where(jd => jd.Payee != null && jd.Payee.Id == Guid.Empty).ToList();
						jds.ForEach(p=>
						{
							if (newVendors.Any(v => v.PayeeName.Equals(p.Payee.PayeeName)))
							{
								p.Payee = newVendors.First(v => v.PayeeName.Equals(p.Payee.PayeeName));
							}
							else
							{
								var vc = new VendorCustomer();
								vc.SetVendorCustomer(CombGuid.Generate(), journal.CompanyId, p.Payee.PayeeName,
									true, journal.LastModifiedBy);
								var savedVC = _companyService.SaveVendorCustomers(vc);
								p.Payee.Id = savedVC.Id;
								p.Payee.PayeeType = EntityTypeEnum.Vendor;
								newVendors.Add(p.Payee);
							}
							
							
						});
						
					}
					var saved =  _journalRepository.SaveCheckbookJournal(journal);
					if (journal.TransactionType == TransactionType.InvoiceDeposit)
					{
						Bus.Publish<InvoiceDepositUpdateEvent>(new InvoiceDepositUpdateEvent()
						{
							Journal = saved, UserId = userId, UserName = saved.LastModifiedBy, TimeStamp = DateTime.Now
						});
					}
					
					var memento = Memento<Journal>.Create(saved, (EntityTypeEnum)saved.EntityType1, saved.LastModifiedBy, string.Format("Check updated {0}", saved.CheckNumber), userId);
					_mementoDataService.AddMementoData(memento);
					txn.Complete();
					return saved;
				}
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " Save Journal  " + journal.Id + ", CheckNumber=" + journal.CheckNumber + ", TransactionType=" + (int)journal.TransactionType);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public Journal VoidCheckbookEntry(Journal mapped, Guid userId)
		{
			try
			{
				var j = _journalRepository.VoidJournal(mapped, mapped.TransactionType, mapped.LastModifiedBy);
				
				var memento = Memento<Journal>.Create(j, (EntityTypeEnum)j.EntityType1, mapped.LastModifiedBy, string.Format("{0} voided {1}", mapped.TransactionType.GetDbName(), mapped.CheckNumber), userId);
				_mementoDataService.AddMementoData(memento);
				return j;
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
			return _pdfService.Print(GetRegularCheckPDFModel(coas, company, journal));
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
				Template = PDFTemplate(company.PayCheckStock, journal.TransactionType)
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
						pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Memo1." + counter.ToString(), string.Format("Check #{0}", jd.CheckNumber)));
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
				var company = _readerService.GetCompany(journal.CompanyId);
				if(journal.TransactionType==TransactionType.RegularCheck || journal.TransactionType==TransactionType.TaxPayment || journal.TransactionType==TransactionType.DeductionPayment)
					return PrintRegularCheck(coas, company, journal);
				return PrintDepositTicket(coas, company, journal);
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " print Journal id=" + journal.Id);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		private PDFModel GetRegularCheckPDFModel(IEnumerable<Account> coas, Company company, Journal journal)
		{
			var enumerable = coas as Account[] ?? coas.ToArray();
			var bankcoa = enumerable.First(c => c.Id == journal.MainAccountId);
			var vc = _readerService.GetPayee(company.Id, journal.PayeeId, (int)journal.EntityType);
			var pdf = new PDFModel
			{
				Name = string.Format("Check_{1}_{2} {0}.pdf", journal.TransactionDate.ToString("MMddyyyy"), journal.CompanyId, journal.Id),
				TargetId = journal.Id,
				NormalFontFields = new List<KeyValuePair<string, string>>(),
				BoldFontFields = new List<KeyValuePair<string, string>>(),
				TargetType = EntityTypeEnum.PayCheck,
				Template = PDFTemplate(company.PayCheckStock, journal.TransactionType)
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

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("EmpName", vc.PayeeName));
			if (vc.Contact != null && vc.Contact.Address != null)
			{
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text1", vc.Address.AddressLine1));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text3", vc.Address.AddressLine2));
				pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Text3", vc.Address.AddressLine2));
			}

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Date", journal.TransactionDate.ToString("MM/dd/yyyy")));

			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Bank", bankcoa.BankAccount.BankName));
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("BankfractionId", bankcoa.BankAccount.FractionId));

			if (company.PayCheckStock != PayCheckStock.MICREncodedTop)
			{
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo", journal.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : journal.CheckNumber.ToString()));
				pdf.BoldFontFields.Add(new KeyValuePair<string, string>("CheckNo2", journal.PaymentMethod == EmployeePaymentMethod.DirectDebit ? "EFT" : journal.CheckNumber.ToString()));
				if (company.PayCheckStock != PayCheckStock.MICRQb)
				{
					//pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Bank", bankcoa.BankAccount.BankName));
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
			pdf.NormalFontFields.Add(new KeyValuePair<string, string>("Caption8", string.Format("Payee : {0}{1} Amount: {2}", vc.PayeeName, "".PadRight(160 - vc.PayeeName.Length - journal.Amount.ToString("c").Length), journal.Amount.ToString("c"))));
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

			if (journal.PaymentMethod == EmployeePaymentMethod.Check)
			{
				var companyDocs = _commonService.GetRelatedEntities<DocumentDto>(EntityTypeEnum.Company, EntityTypeEnum.Document,
					company.Id);

				if (companyDocs.Any(d => d.DocumentType == DocumentType.Signature))
				{
					var signature =
						companyDocs.Where(d => d.DocumentType == DocumentType.Signature).OrderByDescending(d => d.LastModified).First();
					pdf.Signature = new PDFSignature
					{
						Path = _fileRepository.GetDocumentLocation(signature.Doc),
						X = 375,
						Y = company.PayCheckStock == PayCheckStock.LaserTop || company.PayCheckStock == PayCheckStock.MICREncodedTop || company.PayCheckStock == PayCheckStock.MICRQb ? 587 : 330,
						ScaleX = (float)0.7,
						ScaleY = (float)0.7

					};

				}
			}
			return pdf;
		}
		public FileDto PrintChecks(List<int> journals, ReportRequest report)
		{
			try
			{
				
				var models = new List<PDFModel>();
				journals.ForEach(j =>
				{
					var journal = _readerService.GetJournals(id:j).First();
					var company = _readerService.GetCompany(journal.CompanyId);
					var coas = _companyService.GetComanyAccounts(journal.CompanyId);
						
					models.Add(GetRegularCheckPDFModel(coas, company, journal));
				});
					
				return _pdfService.Print(string.Format("{0}-{1}-{2}.pdf", report.ReportName, report.StartDate.ToString("MMddyyyy"), report.StartDate.ToString("MMddyyyy")), models);
				
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " print Journals with id=" + journals.Aggregate(string.Empty, (current, m) => current + m + ", "));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void CreateDepositTickets(Extract extract, string fullName, string user)
		{
			try
			{
				var masterExtract = new MasterExtract
				{
					Id = 0,
					Extract = extract,
					LastModified = DateTime.Now,
					LastModifiedBy = fullName,
					IsFederal = !extract.Report.ReportName.Contains("State")
				};
				using (var txn = TransactionScopeHelper.Transaction())
				{
					Log.Info("Started Deposit Ticketing " + DateTime.Now.ToString("hh:mm:ss:fff"));
					CreateDepositTickets(fullName, masterExtract, new Guid(user));
					
					txn.Complete();
					Log.Info("Finished Deposit Ticketing " + DateTime.Now.ToString("hh:mm:ss:fff"));
				}
				
			}
			catch (Exception)
			{

				throw;
			}
		}

		public List<Journal> GetJournalListForPositivePay(Guid? companyId, DateTime startDate, DateTime endDate)
		{
			try
			{
				return _journalRepository.GetJournalListForPositivePay(companyId, startDate, endDate);
			}
			catch (Exception)
			{
				
				throw;
			}
		}

		public void DeleteExtract(int extractId)
		{
			try
			{
				_journalRepository.DeleteJournals(extractId);
			}
			catch (Exception)
			{

				throw;
			}
		}

		public void DeleteJournals(List<Journal> toList)
		{
			_journalRepository.DeletePayrollJournals(toList);
		}


		private void CreateDepositTickets(string user, MasterExtract masterExtract, Guid userId)
		{
			masterExtract.Extract.Data.Hosts.Where(h=>h.Companies.Any(c=>c.Payments.Any())).ToList().ForEach(host =>
			{
				Log.Info(string.Format("Started Host {0} ", host.Host.FirmName));
				var coaList = _companyService.GetComanyAccounts(host.HostCompany.Id); 
				var bankCOA = coaList.FirstOrDefault(c => c.UsedInInvoiceDeposit);
				if(bankCOA==null)
					throw new Exception("No Bank Account set up for Invoice Deposit");
				Log.Info(string.Format("Fetched bank and coa for Host {0} ", host.Host.FirmName));
				var allpayments =
					host.Companies.SelectMany(c => c.Payments.Where(p => p.Method != InvoicePaymentMethod.ACH).Select(p => p)).ToList();
				var invoiceDeposits = _readerService.GetJournalIds(companyId: host.HostCompany.Id, accountId:bankCOA.Id,
					startDate: masterExtract.Extract.Report.StartDate, endDate: masterExtract.Extract.Report.StartDate,
					transactionType: (int)TransactionType.InvoiceDeposit); //_journalRepository.GetCompanyJournals(host.HostCompany.Id,masterExtract.Extract.Report.StartDate, masterExtract.Extract.Report.StartDate);
				Log.Info(string.Format("fetched Host {0} journals {1} {2}", host.Host.FirmName, invoiceDeposits.Count, DateTime.Now.ToString("hh:mm:ss:fff")));
				var journal = new Journal
				{
					Id = invoiceDeposits.Any() ? invoiceDeposits.First() : 0,
					CompanyId = host.HostCompany.Id,
					Amount = Math.Round(allpayments.Sum(p=>p.Amount), 2, MidpointRounding.AwayFromZero),
					CheckNumber = -1,
					EntityType = EntityTypeEnum.Deposit,
					PayeeId = Guid.Empty,

					IsDebit = false,
					IsVoid = false,
					LastModified = DateTime.Now,
					LastModifiedBy = user,
					Memo = string.Format("Daily Deposits for {0} ", masterExtract.Extract.Report.StartDate.ToString("MM/dd/yyyy")),
					PaymentMethod = EmployeePaymentMethod.Check,
					PayrollPayCheckId = null,
					TransactionDate = masterExtract.Extract.Report.StartDate,
					TransactionType = TransactionType.InvoiceDeposit,
					PayeeName = string.Empty,
					MainAccountId = bankCOA.Id,
					JournalDetails = new List<JournalDetail>(),
					DocumentId = Guid.Empty,
					PEOASOCoCheck = false
				};
				//bank account debit

				var incomeCOA = coaList.First(co => co.Type == AccountType.Income && co.SubType == AccountSubType.RegularIncome);
				//journal.JournalDetails.Add(new JournalDetail { AccountId = bankCOA.Id, AccountName = bankCOA.AccountName, IsDebit = false, Amount = journal.Amount, LastModfied = journal.LastModified, LastModifiedBy = user });

				allpayments.Where(p => p.Method != InvoicePaymentMethod.ACH)
					.OrderByDescending(p => p.Method)
					.ThenBy(p=>p.CheckNumber)
					.ToList()
					.ForEach(p => journal.JournalDetails.Add(new JournalDetail
					{
						Memo = string.Empty,
						AccountId = incomeCOA.Id,
						AccountName = incomeCOA.AccountName,
						IsDebit = false,
						DepositMethod = p.Method == InvoicePaymentMethod.Check ? VendorDepositMethod.Check : VendorDepositMethod.Cash,
						CheckNumber = p.Method == InvoicePaymentMethod.Check ? p.CheckNumber : 0,
						Amount = p.Amount,
						LastModfied = journal.LastModified,
						LastModifiedBy = user,
						Payee = new JournalPayee() { Id = p.CompanyId, PayeeName=host.Companies.First(c=>c.Company.Id==p.CompanyId).Company.Name, PayeeType=EntityTypeEnum.Company },
						InvoiceId = p.InvoiceId,
						Deposited = p.Status==PaymentStatus.Deposited,
						PaymentId = p.PaymentId

					}));
				Log.Info(string.Format("saving Host {0} invoice deposit", host.Host.FirmName));
				SaveCheckbookEntryNoTran(journal, userId);

				Log.Info(string.Format("Finished Host {0} journals {1}", host.Host.FirmName, DateTime.Now.ToString("hh:mm:ss:fff")));
			});		
		}
		public List<AccountWithJournal> GetCompanyAccountsWithJournalsForTypes(Guid companyId, DateTime? startDate, DateTime? endDate, List<AccountType> accountTypes, List<Journal> companyJournals)
		{
			try
			{
				var dbcoas = _companyService.GetComanyAccounts(companyId);
				var coas = Mapper.Map<List<Account>, List<AccountWithJournal>>(dbcoas).Where(c => accountTypes.Any(at => at == c.Type)).ToList();
				var journals =
					companyJournals.Where(
						j =>
							((startDate.HasValue && j.TransactionDate >= startDate.Value.Date) || !startDate.HasValue) &&
							((endDate.HasValue && j.TransactionDate <= endDate.Value.Date) || !endDate.HasValue)).ToList();
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
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Account list with journals for company id and type =" + companyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<Journal> GetJournalList(Guid companyId, DateTime startDate, DateTime endDate)
		{
			try
			{
				var journals = _readerService.GetJournals(companyId: companyId,startDate: startDate,endDate: endDate, transactionType:(int)TransactionType.RegularCheck, isvoid:0);
				return journals;//.Where(j => !j.IsVoid && j.TransactionType == TransactionType.RegularCheck).ToList();
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToRetrieveX, " Get Account list with journals for company id and type =" + companyId);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public MasterExtract FileTaxes(Extract extract, string fullName)
		{
			try
			{
				var masterExtract = new MasterExtract
				{
					Id = 0,
					Extract = extract,
					LastModified = DateTime.Now,
					LastModifiedBy = fullName,
					IsFederal = !extract.Report.ReportName.Contains("State")
				};
				using (var txn = TransactionScopeHelper.Transaction())
				{
					if (extract.Report.ReportName.Equals("GarnishmentReport"))
						masterExtract = CreateGarnishmentPayments(extract, fullName, masterExtract);
					else if (extract.Report.ReportName.Equals("StateCADE9"))
					{
						masterExtract = _journalRepository.SaveMasterExtract(masterExtract,
							extract.Data.Hosts.SelectMany(h => h.PayCheckAccumulation.PayCheckList.Select(pc => pc.Id)).ToList(),
							extract.Data.Hosts.SelectMany(h => h.PayCheckAccumulation.VoidedPayCheckList.Select(pc => pc.Id)).ToList(),
							new List<Journal>());
					}
					else if (extract.Report.ReportName.Equals("HostWCReport"))
					{
						masterExtract.Extract.Report.DepositDate = DateTime.Now;
						masterExtract = _journalRepository.SaveMasterExtract(masterExtract,
							extract.Data.Hosts.SelectMany(h => h.PayChecks.Select(pc => pc.Id)).ToList(),new List<int>(),
							new List<Journal>());
					}
						
					else 
						masterExtract = CreateTaxPayments(extract, fullName, masterExtract);
					txn.Complete();
				}
				return masterExtract;
			}
			catch (Exception)
			{
				
				throw;
			}
			
		}

		private MasterExtract CreateTaxPayments(Extract extract, string fullName, MasterExtract masterExtract)
		{
			try
			{
				
					var globalVendors = _companyService.GetVendorCustomers(null, true);
					globalVendors = globalVendors.Where(v => v.IsTaxDepartment).ToList();

				var journalList = new List<Journal>();
					var journals = new List<int>();
					var payCheckIds = new List<int>();
					var voidedCheckIds = new List<int>();
					foreach (var host in extract.Data.Hosts)
					{
						var accounts = _companyService.GetComanyAccounts(host.HostCompany.Id);
						if (!accounts.Any() || !accounts.Any(a => a.UseInPayroll))
							throw new Exception(string.Format("No Payroll Account for Company {0}", host.HostCompany.Name));


						var amount = CalculateTaxAmount(extract.Report, host);

						var journal = CreateJournalEntryTP(accounts, fullName, host.HostCompany.Id, amount,
							globalVendors.First(
								v => (masterExtract.IsFederal && v.Name.Contains("941") || (!masterExtract.IsFederal && v.Name.Contains("CA")))),
							extract.Report.Description, extract.Report.DepositDate.Value, host.HostCompany.CompanyIntId);
						journalList.Add(journal);
						journals.Add(journal.Id);
						payCheckIds.AddRange(host.PayCheckAccumulation.PayCheckList.Select(pc=>pc.Id));
						voidedCheckIds.AddRange(host.PayCheckAccumulation.VoidedPayCheckList.Select(pc=>pc.Id));
					}
					

					masterExtract = _journalRepository.SaveMasterExtract(masterExtract, payCheckIds, voidedCheckIds, journalList);
					return masterExtract;
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " File Taxes for " + extract.Report.Description + " - " + e.Message);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
		private MasterExtract CreateGarnishmentPayments(Extract extract, string fullName, MasterExtract masterExtract)
		{
			try
			{

				var journalList = new List<Journal>();
					var journals = new List<int>();
					var payCheckIds = new List<int>();
					var voidedCheckIds = new List<int>();
					var allCompanies = _readerService.GetCompanies(status: (int) StatusOption.Active);
					foreach (var host in extract.Data.Hosts)
					{
						var accounts = new List<Account>();
						var comp = allCompanies.First(c => c.Id == host.HostCompany.Id);
						
						if (comp.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOCoCheck ||
						    comp.Contract.InvoiceSetup.InvoiceType == CompanyInvoiceType.PEOASOClientCheck)
						{
							comp = allCompanies.First(hc => hc.IsHostCompany && hc.HostId == comp.HostId);
							accounts = _companyService.GetComanyAccounts(comp.Id);
						}
						else
							accounts = _companyService.GetComanyAccounts(comp.Id);

						if (!accounts.Any() || !accounts.Any(a => a.UseInPayroll))
							throw new Exception("No Payroll Account");

						foreach (var garnishmentAgency in host.Accumulation.GarnishmentAgencies)
						{
							var gaPayChescks =
								host.PayChecks.Where(pc => garnishmentAgency.PayCheckIds.Any(gapc => gapc == pc.Id)).ToList();
							var empGroup = gaPayChescks.GroupBy(pc => pc.Employee.Id).ToList();
							foreach (var emp in empGroup)
							{
								var check =
									gaPayChescks.Last(p => p.Employee.Id == emp.Key &&
									                       p.Deductions.Any(d => d.EmployeeDeduction.AgencyId == garnishmentAgency.Agency.Id));
								var amount =
									emp.ToList()
										.SelectMany(
											pc => pc.Deductions.Where(d => d.Deduction.Type.Id==3 && d.EmployeeDeduction!=null && d.EmployeeDeduction.AgencyId == garnishmentAgency.Agency.Id).ToList())
										.Sum(d => d.Amount);
								var journal = CreateJournalEntryPD(accounts, fullName, comp.Id, amount,
										garnishmentAgency.Agency,
										extract.Report.Description, extract.Report.DepositDate.Value, check.Employee.FullName, check.Deductions.First(d=>d.EmployeeDeduction.AgencyId==garnishmentAgency.Agency.Id).EmployeeDeduction.AccountNo, comp.CompanyIntId );
								journals.Add(journal.Id);
								journalList.Add(journal);
								payCheckIds.AddRange(garnishmentAgency.PayCheckIds);
							}
							
							
						}
						
					}
					//masterExtract.Journals = journals;
					
					masterExtract = _journalRepository.SaveMasterExtract(masterExtract, payCheckIds, voidedCheckIds, journalList);
					return masterExtract;
				
			}
			catch (Exception e)
			{
				var message = string.Format(OnlinePayrollStringResources.ERROR_FailedToSaveX, " File Taxes for " + extract.Report.Description);
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		
		private Journal CreateJournalEntryTP(List<Account> coaList, string userName, Guid companyId, decimal amount, VendorCustomer vendor, string report, DateTime date, int companyIntId)
		{
			var bankCOA = coaList.First(c => c.UseInPayroll);
			var journal = new Journal
			{
				Id = 0,
				CompanyId = companyId,
				Amount = Math.Round(amount, 2, MidpointRounding.AwayFromZero),
				CheckNumber = -1,
				EntityType = EntityTypeEnum.Vendor,
				PayeeId = vendor.Id,
				IsDebit = true,
				IsVoid = false,
				LastModified = DateTime.Now,
				LastModifiedBy = userName,
				Memo = string.Format("Tax Payment for {0}", report),
				PaymentMethod = EmployeePaymentMethod.DirectDebit,
				PayrollPayCheckId = null,
				TransactionDate = date,
				TransactionType = TransactionType.TaxPayment,
				PayeeName = vendor.Name,
				MainAccountId = bankCOA.Id,
				JournalDetails = new List<JournalDetail>(),
				DocumentId = Guid.Empty,
				PEOASOCoCheck = false,
				CompanyIntId = companyIntId
			};
			//bank account debit


			journal.JournalDetails.Add(new JournalDetail { AccountId = bankCOA.Id, AccountName = bankCOA.AccountName, IsDebit = true, Amount = amount, LastModfied = journal.LastModified, LastModifiedBy = userName });
			journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "TP").Id, AccountName = coaList.First(c => c.TaxCode == "TP").AccountName, IsDebit = false, Amount = amount, LastModfied = journal.LastModified, LastModifiedBy = userName });
			
			return journal;
		}
		private Journal CreateJournalEntryPD(List<Account> coaList, string userName, Guid companyId, decimal amount, VendorCustomer vendor, string report, DateTime date, string employee, string account, int companyIntId)
		{
			var bankCOA = coaList.First(c => c.UseInPayroll);
			var journal = new Journal
			{
				Id = 0,
				CompanyId = companyId,
				Amount = Math.Round(amount, 2, MidpointRounding.AwayFromZero),
				CheckNumber = 101,
				EntityType = EntityTypeEnum.Vendor,
				PayeeId = vendor.Id,
				IsDebit = true,
				IsVoid = false,
				LastModified = DateTime.Now,
				LastModifiedBy = userName,
				Memo = string.Format("Account No:{2}. {1}, Deduction Payment for {0}", report, employee, account),
				PaymentMethod = EmployeePaymentMethod.Check,
				PayrollPayCheckId = null,
				TransactionDate = date,
				TransactionType = TransactionType.DeductionPayment,
				PayeeName = vendor.Name,
				MainAccountId = bankCOA.Id,
				JournalDetails = new List<JournalDetail>(),
				DocumentId = Guid.Empty,
				PEOASOCoCheck = false,
				CompanyIntId = companyIntId
			};
			//bank account debit


			journal.JournalDetails.Add(new JournalDetail { AccountId = bankCOA.Id, AccountName = bankCOA.AccountName, IsDebit = true, Amount = amount, LastModfied = journal.LastModified, LastModifiedBy = userName });
			journal.JournalDetails.Add(new JournalDetail { AccountId = coaList.First(c => c.TaxCode == "PD").Id, AccountName = coaList.First(c => c.TaxCode == "PD").AccountName, IsDebit = false, Amount = amount, LastModfied = journal.LastModified, LastModifiedBy = userName });

			return journal;
		}
		private decimal CalculateTaxAmount(ReportRequest report, ExtractHost host)
		{
			if (report.ExtractType != ExtractType.NA)
				return host.PayCheckAccumulation.ApplicableAmounts;
			
			throw new Exception("no Taxes to be files on this report");
		}

		private string PDFTemplate(PayCheckStock payCheckStock, TransactionType transactionType)
		{
			if (transactionType == TransactionType.RegularCheck || transactionType == TransactionType.TaxPayment || transactionType == TransactionType.DeductionPayment)
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
			else if (transactionType == TransactionType.Deposit || transactionType == TransactionType.InvoiceDeposit)
			{
				return "DepositTicket.pdf";

			}
			return string.Empty;
		}
	}
}

using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Exceptions;
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

		public JournalService(IJournalRepository journalRepository, ICompanyService companyService)
		{
			_journalRepository = journalRepository;
			_companyService = companyService;
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
	}
}

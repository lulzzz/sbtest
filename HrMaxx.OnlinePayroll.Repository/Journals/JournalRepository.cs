using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
using Newtonsoft.Json;
using Journal = HrMaxx.OnlinePayroll.Models.DataModel.Journal;
using MasterExtract = HrMaxx.OnlinePayroll.Models.MasterExtract;

namespace HrMaxx.OnlinePayroll.Repository.Journals
{
	public class JournalRepository : IJournalRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;

		public JournalRepository(IMapper mapper, OnlinePayrollEntities dbContext)
		{
			_dbContext = dbContext;
			_dbContext.Database.CommandTimeout = 180;
			_mapper = mapper;
		}

		public Models.Journal SaveJournal(Models.Journal journal, bool isPEOCheck = false)
		{
			var mapped = _mapper.Map<Models.Journal, Journal>(journal);
			if (mapped.Id == 0)
			{
				if (journal.TransactionType == TransactionType.PayCheck)
				{
					if (isPEOCheck && mapped.CheckNumber > 0 &&
					    _dbContext.Journals.Any(
						    j => j.CheckNumber == mapped.CheckNumber && j.PayrollPayCheckId != mapped.PayrollPayCheckId))
					{
						mapped.CheckNumber = _dbContext.Journals.Where(j => j.PEOASOCoCheck).Max(j => j.CheckNumber) + 1;
						if (mapped.PayrollPayCheckId.HasValue)
						{
							_dbContext.PayrollPayChecks.First(pc => pc.Id == mapped.PayrollPayCheckId).CheckNumber = mapped.CheckNumber;
							var peoCompanyCheck = _dbContext.Journals.FirstOrDefault(j => j.TransactionType==(int)TransactionType.PayCheck && j.PayrollPayCheckId==mapped.PayrollPayCheckId);
							if(peoCompanyCheck!=null)
								peoCompanyCheck.CheckNumber = mapped.CheckNumber;
						}
					}
				}
				else if(journal.TransactionType == TransactionType.RegularCheck)
				{
					if (mapped.CheckNumber > 0 &&
							_dbContext.Journals.Any(
								j => j.CheckNumber == mapped.CheckNumber && (j.TransactionType==(int)TransactionType.RegularCheck || j.TransactionType==(int)TransactionType.DeductionPayment )))
					{
						mapped.CheckNumber = _dbContext.Journals.Where(j=>j.CompanyId==mapped.CompanyId).Max(j => j.CheckNumber) + 1;
					}
				}
				
				_dbContext.Journals.Add(mapped);
				_dbContext.SaveChanges();
			}
			else
			{
				var dbJournal = _dbContext.Journals.FirstOrDefault(j => j.Id == mapped.Id);
				if (dbJournal != null)
				{
					dbJournal.Amount = mapped.Amount;
					dbJournal.TransactionDate = mapped.TransactionDate;
					dbJournal.CheckNumber = mapped.CheckNumber;
					dbJournal.IsVoid = mapped.IsVoid;
					dbJournal.PayeeId = mapped.PayeeId;
					dbJournal.PayeeName = mapped.PayeeName;
					dbJournal.JournalDetails = mapped.JournalDetails;
				}
				else
				{
					_dbContext.Journals.Add(mapped);
				}
				_dbContext.SaveChanges();
			}
			return _mapper.Map<Models.DataModel.Journal, Models.Journal>(mapped);
		}

		public Models.Journal GetPayCheckJournal(int payCheckId, bool peoasoCoCheck)
		{
			var journal =
				_dbContext.Journals.First(
					j => j.PayrollPayCheckId == payCheckId && j.TransactionType == (int) TransactionType.PayCheck && j.PEOASOCoCheck==peoasoCoCheck);
			return _mapper.Map<Models.DataModel.Journal, Models.Journal>(journal);
		}

		public List<Models.Journal> GetPayrollJournals(Guid payrollId, bool peoasoCoCheck)
		{
			var journals =
				_dbContext.Journals.Where(
					j => j.PayrollPayCheck.PayrollId==payrollId && j.TransactionType == (int)TransactionType.PayCheck && j.PEOASOCoCheck == peoasoCoCheck).ToList();
			return _mapper.Map<List<Models.DataModel.Journal>, List<Models.Journal>>(journals);
		}

		
		public Models.Journal VoidJournal(int id, TransactionType transactionType, string name)
		{
			var journal = _dbContext.Journals.FirstOrDefault(j => j.Id == id && j.TransactionType == (int) transactionType);
			if (journal != null)
			{
				journal.IsVoid = true;
				journal.LastModified = DateTime.Now;
				journal.LastModifiedBy = name;
				_dbContext.SaveChanges();
			}
			return _mapper.Map<Models.DataModel.Journal, Models.Journal>(journal);
		}

		public List<Models.Journal> GetJournalList(Guid companyId, int accountId, DateTime? startDate, DateTime? endDate)
		{
			var journals = _dbContext.Journals.Where(j => j.CompanyId == companyId && j.MainAccountId == accountId).AsQueryable();
			if (startDate.HasValue)
				journals = journals.Where(j => j.TransactionDate >= startDate);
			if (endDate.HasValue)
				journals = journals.Where(j => j.TransactionDate <= endDate);

			return _mapper.Map<List<Models.DataModel.Journal>, List<Models.Journal>>(journals.ToList());
		}

		public List<Models.Journal> GetCompanyJournals(Guid? companyId, DateTime? startDate, DateTime? endDate)
		{
			var journals = _dbContext.Journals.AsQueryable();
			if (companyId.HasValue)
				journals = journals.Where(j => j.CompanyId == companyId.Value);
			if (startDate.HasValue)
				journals = journals.Where(j => j.TransactionDate >= startDate);
			if (endDate.HasValue)
				journals = journals.Where(j => j.TransactionDate <= endDate);

			return _mapper.Map<List<Models.DataModel.Journal>, List<Models.Journal>>(journals.ToList());
		}
		public MasterExtract FixMasterExtract(MasterExtract masterExtract)
		{
			//var mapped = _mapper.Map<Models.MasterExtract, Models.DataModel.MasterExtract>(masterExtract);
			//_dbContext.MasterExtracts.Add(mapped);
			var dbExtracts = _dbContext.MasterExtracts.First(e => e.Id == masterExtract.Id);
			dbExtracts.Extract = JsonConvert.SerializeObject(masterExtract.Extract);
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.MasterExtract, Models.MasterExtract>(dbExtracts);
		}

		public MasterExtract SaveMasterExtract(MasterExtract masterExtract, List<int> payCheckIds, List<int> voidedCheckIds)
		{
			var mapped = _mapper.Map<Models.MasterExtract, Models.DataModel.MasterExtract>(masterExtract);
			_dbContext.MasterExtracts.Add(mapped);
			_dbContext.SaveChanges();
			var payChecks = _dbContext.PayrollPayChecks.Where(pc => payCheckIds.Any(pc1 => pc1 == pc.Id)).ToList();
			payChecks.ForEach(pc => pc.PayCheckExtracts.Add(new PayCheckExtract
			{
				PayrollPayCheckId = pc.Id,
				Extract = masterExtract.Extract.Report.ReportName,
				Type=1,
				MasterExtractId = mapped.Id
			}));

			var creditChecks = _dbContext.PayrollPayChecks.Where(pc => voidedCheckIds.Any(pc1 => pc1 == pc.Id)).ToList();
			creditChecks.ForEach(pc => pc.PayCheckExtracts.Add(new PayCheckExtract
			{
				Type=2,
				MasterExtractId = mapped.Id,
				Extract = masterExtract.Extract.Report.ReportName,
				PayrollPayCheckId=pc.Id
			}));
			_dbContext.SaveChanges();
			return _mapper.Map<Models.DataModel.MasterExtract, Models.MasterExtract>(mapped);
		}

		
	}
}

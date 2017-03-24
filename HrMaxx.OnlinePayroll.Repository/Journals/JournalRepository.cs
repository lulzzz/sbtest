using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using Dapper;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.OnlinePayroll.Models;
using HrMaxx.OnlinePayroll.Models.DataModel;
using HrMaxx.OnlinePayroll.Models.Enum;
using Newtonsoft.Json;
using Journal = HrMaxx.OnlinePayroll.Models.DataModel.Journal;
using MasterExtract = HrMaxx.OnlinePayroll.Models.MasterExtract;

namespace HrMaxx.OnlinePayroll.Repository.Journals
{
	public class JournalRepository : BaseDapperRepository, IJournalRepository
	{
		private readonly OnlinePayrollEntities _dbContext;
		private readonly IMapper _mapper;

		public JournalRepository(IMapper mapper, OnlinePayrollEntities dbContext, DbConnection connection):base(connection)
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
				else if(journal.TransactionType == TransactionType.RegularCheck || journal.TransactionType==TransactionType.DeductionPayment)
				{
					if (mapped.CheckNumber > 0 &&
							_dbContext.Journals.Any(
								j => j.CompanyId==mapped.CompanyId && j.CheckNumber == mapped.CheckNumber && (j.TransactionType==(int)TransactionType.RegularCheck || j.TransactionType==(int)TransactionType.DeductionPayment )))
					{
						mapped.CheckNumber = _dbContext.Journals.Where(j => j.CompanyId == mapped.CompanyId && (j.TransactionType == (int)TransactionType.RegularCheck || j.TransactionType == (int)TransactionType.DeductionPayment)).Max(j => j.CheckNumber) + 1;
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
					dbJournal.Memo = mapped.Memo;
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
			
			var dbExtracts = _dbContext.MasterExtracts.First(e => e.Id == masterExtract.Id);
			
			SaveExtractDetails(masterExtract.Id, JsonConvert.SerializeObject(masterExtract.Extract));
			return _mapper.Map<Models.DataModel.MasterExtract, Models.MasterExtract>(dbExtracts);
		}
		private void SaveExtractDetails(int extractId, string extract)
		{
			using (var conn = GetConnection())
			{
				const string selectSql =
				@"SELECT MasterExtractId FROM PaxolArchive.dbo.MasterExtract WHERE MasterExtractId=@extractId";
				
				dynamic exists =
						conn.Query(selectSql, new { extractId }).FirstOrDefault();
				if (exists != null)
				{
					conn.Execute("delete from PaxolArchive.dbo.MasterExtract where MasterExtractId=@extractId", new { extractId });
				}
				const string sql =
					@"INSERT INTO PaxolArchive.dbo.MasterExtract(MasterExtractId, Extract) VALUES (@extractId, @extract)";
				conn.Execute(sql, new
				{
					extractId,
					extract
				});
				
			}
			

		}
		public Models.Journal GetJournalById(int id)
		{
			var dbJournal = _dbContext.Journals.First(j => j.Id == id);
			return _mapper.Map<Models.DataModel.Journal, Models.Journal>(dbJournal);
		}

		public List<Models.Journal> GetJournalListForPositivePay(Guid? companyId, DateTime startDate, DateTime endDate)
		{
			var journals = _dbContext.Journals.AsQueryable();
			if (companyId.HasValue)
				journals = journals.Where(j => j.CompanyId == companyId.Value);

			journals = journals.Where(j => (!j.OriginalDate.HasValue && j.TransactionDate >= startDate && j.TransactionDate <= endDate) || (j.OriginalDate.HasValue && j.OriginalDate >= startDate && j.OriginalDate <= endDate));
			
			return _mapper.Map<List<Models.DataModel.Journal>, List<Models.Journal>>(journals.ToList());
		}

		public void FixMasterExtractPayCheckMapping(MasterExtract masterExtract, List<int> payCheckIds, List<int> voidedCheckIds)
		{
			if (!_dbContext.PayCheckExtracts.Any(pce => pce.MasterExtractId == masterExtract.Id))
			{
				var pces = new List<PayCheckExtract>();
				payCheckIds.Distinct().ToList().ForEach(pc => pces.Add(new PayCheckExtract
				{
					PayrollPayCheckId = pc,
					Extract = masterExtract.Extract.Report.ReportName,
					Type = 1,
					MasterExtractId = masterExtract.Id
				}));
				_dbContext.PayCheckExtracts.AddRange(pces);
				voidedCheckIds.Distinct().ToList().ForEach(vc => _dbContext.PayCheckExtracts.Add(new PayCheckExtract
				{
					Type = 2,
					MasterExtractId = masterExtract.Id,
					Extract = masterExtract.Extract.Report.ReportName,
					PayrollPayCheckId = vc
				}));
				_dbContext.SaveChanges();
			}
			
		}

		public MasterExtract SaveMasterExtract(MasterExtract masterExtract, List<int> payCheckIds, List<int> voidedCheckIds, List<Models.Journal> journalList)
		{
			
			var mappedJournals = _mapper.Map<List<Models.Journal>, List<Journal>>(journalList);
			
			const string selectExtractSql =
				@"SELECT MasterExtractId FROM PaxolArchive.dbo.MasterExtract WHERE MasterExtractId=@ExtractId";
			const string insertExtract = @"insert into MasterExtracts(StartDate, EndDate, ExtractName, IsFederal, DepositDate, Journals, LastModified, LastModifiedBy) values(@StartDate, @EndDate, @ExtractName, @IsFederal, @DepositDate, @Journals, @LastModified, @LastModifiedBy); select cast(scope_identity() as int)";
			const string insertPayCheckExtract =
				"insert into PayCheckExtract(PayrollPayCheckId, MasterExtractId, Extract, Type) values(@PayrollPayCheckId, @MasterExtractId, @Extract, @Type);";
			const string insertJournals = "insert into Journal( CompanyId, TransactionType, PaymentMethod, CheckNumber, PayrollPayCheckId, EntityType, PayeeId, PayeeName, Amount, Memo, IsDebit, IsVoid, MainAccountId, TransactionDate, LastModified, LastModifiedBy, JournalDetails, DocumentId, PEOASOCoCheck, OriginalDate) " +
			                              "select @CompanyId, @TransactionType, @PaymentMethod, " +
			                              "case when @TransactionType in (2,6) and exists(select 'x' from Journal where CompanyId=@CompanyId and TransactionType in (2,6)) then (select max(CheckNumber)+1 from Journal where CompanyId=@CompanyId and TransactionType in (2,6))" +
			                              " else @CheckNumber end, @PayrollPayCheckId, @EntityType, @PayeeId, @PayeeName, @Amount, @Memo, @IsDebit, @IsVoid, @MainAccountId, @TransactionDate, @LastModified, @LastModifiedBy, @JournalDetails, @DocumentId, @PEOASOCoCheck, @OriginalDate;select cast(scope_identity() as int)";

			using (var conn = GetConnection())
			{
				//OpenConnection();
				var journalIds = new List<int>();
				mappedJournals.ForEach(j => journalIds.Add(conn.Query<int>(insertJournals, j).Single()));

				masterExtract.Journals = journalIds;
				var mapped = _mapper.Map<Models.MasterExtract, Models.DataModel.MasterExtract>(masterExtract);

				mapped.Id = conn.Query<int>(insertExtract, mapped).Single();
				var pces = new List<PayCheckExtract>();
				var vces = new List<PayCheckExtract>();
				payCheckIds.Distinct().ToList().ForEach(pc => pces.Add(new PayCheckExtract
				{
					PayrollPayCheckId = pc,
					Extract = masterExtract.Extract.Report.ReportName,
					Type = 1,
					MasterExtractId = mapped.Id
				}));


				voidedCheckIds.Distinct().ToList().ForEach(vc => vces.Add(new PayCheckExtract
				{
					Type = 2,
					MasterExtractId = mapped.Id,
					Extract = masterExtract.Extract.Report.ReportName,
					PayrollPayCheckId = vc
				}));
				conn.Execute(insertPayCheckExtract, pces);
				conn.Execute(insertPayCheckExtract, vces);
				dynamic exists =
						conn.Query(selectExtractSql, new { ExtractId = mapped.Id }).SingleOrDefault();
				if (exists != null)
				{
					conn.Execute("delete from PaxolArchive.dbo.MasterExtract where MasterExtractId=@ExtractId", new { ExtractId = mapped.Id });
				}
				const string sql =
					@"INSERT INTO PaxolArchive.dbo.MasterExtract(MasterExtractId, Extract) VALUES (@ExtractId, @Extract)";
				conn.Execute(sql, new
				{
					ExtractId = mapped.Id,
					Extract = JsonConvert.SerializeObject(masterExtract.Extract)
				});
				
				return _mapper.Map<Models.DataModel.MasterExtract, Models.MasterExtract>(mapped);
			}
			
		}

		
	}
}

using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using Dapper;
using HrMaxx.Common.Repository.Files;
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

		public Models.Journal SaveJournal(Models.Journal journal, bool isPEOCheck = false, bool peoPayroll = false)
		{
			const string insertjournal = "insert into Journal(CompanyId,TransactionType,PaymentMethod,CheckNumber,PayrollPayCheckId,EntityType,PayeeId,PayeeName,Amount,Memo,IsDebit,IsVoid,MainAccountId,TransactionDate,LastModified,LastModifiedBy,JournalDetails,DocumentId,PEOASOCoCheck,OriginalDate,IsReIssued,OriginalCheckNumber,ReIssuedDate, PayrollId, CompanyIntId) values(@CompanyId,@TransactionType,@PaymentMethod,@CheckNumber,@PayrollPayCheckId,@EntityType,@PayeeId,@PayeeName,@Amount,@Memo,@IsDebit,@IsVoid,@MainAccountId,@TransactionDate,@LastModified,@LastModifiedBy,@JournalDetails,@DocumentId,@PEOASOCoCheck,@OriginalDate,@IsReIssued,@OriginalCheckNumber,@ReIssuedDate, @PayrollId, @CompanyIntId); select cast(scope_identity() as int)";
			var mapped = _mapper.Map<Models.Journal, Journal>(journal);
			using (var conn = GetConnection())
			{
				if (mapped.Id == 0)
				{
					if (mapped.CheckNumber > 0)
					{
						const string sql = "select @NewCheckNumber = dbo.GetCheckNumber(@CompanyIntId, @PayrollPayCheckId, @PEOASOCoCheck, @TransactionType, @CheckNumber, @IsPEOPayroll); if @NewCheckNumber<>@CheckNumber begin update PayrollPayCheck set CheckNumber=@NewCheckNumber where Id=@PayrollPayCheckId; if @PEOASOCoCheck=1 begin update Journal set CheckNumber=@NewCheckNumber where PayrollPaycheckId=@PayrollPayCheckId; end end select @NewCheckNumber as checknumber";
						//const string sql = "select dbo.GetCheckNumber(@CompanyIntId, @PayrollPayCheckId, @PEOASOCoCheck, @TransactionType, @CheckNumber, @IsPEOPayroll) as checknumber";
						dynamic result =
							conn.Query(sql, new { CheckNumber = mapped.CheckNumber, NewCheckNumber = mapped.CheckNumber, CompanyIntId = mapped.CompanyIntId, TransactionType=(int)mapped.TransactionType, CompanyId = mapped.CompanyId, PayrollPayCheckId = mapped.PayrollPayCheckId, PEOASOCoCheck = mapped.PEOASOCoCheck, IsPEOPayroll = peoPayroll }).FirstOrDefault();
						if (result.checknumber != null)
						{
							mapped.CheckNumber = result.checknumber;
						}
					}

					mapped.Id = conn.Query<int>(insertjournal, mapped).Single();

				}
				else
				{
					const string jsq =
					"select Id from Journal with(nolock) where Id=@Id";
					var dbj2 = conn.Query<int>(jsq, new { Id = mapped.Id }).ToList();

					if (dbj2.Any())
					{
						const string updatejournal =
							"update journal set Amount=@Amount, Memo=@Memo, TransactionDate=@TransactionDate, CheckNumber=@CheckNumber, IsVoid=@IsVoid, PayeeId=@PayeeId, PayeeName=@PayeeName, JournalDetails=@JournalDetails Where Id=@Id";
						conn.Execute(updatejournal, mapped);

					}
					else
					{
						mapped.Id = conn.Query<int>(insertjournal, mapped).Single();
					}
				}
			}
			return _mapper.Map<Models.DataModel.Journal, Models.Journal>(mapped);
		}
		
		public Models.Journal SaveCheckbookJournal(Models.Journal journal, bool isPEOCheck = false, bool peoPayroll = false)
		{
			const string insertjournal = "insert into CheckbookJournal(CompanyId,TransactionType,PaymentMethod,CheckNumber,PayrollPayCheckId,EntityType,PayeeId,PayeeName,Amount,Memo,IsDebit,IsVoid,MainAccountId,TransactionDate,LastModified,LastModifiedBy,JournalDetails,DocumentId,PEOASOCoCheck,OriginalDate,IsReIssued,OriginalCheckNumber,ReIssuedDate, CompanyIntId) values(@CompanyId,@TransactionType,@PaymentMethod,@CheckNumber,@PayrollPayCheckId,@EntityType,@PayeeId,@PayeeName,@Amount,@Memo,@IsDebit,@IsVoid,@MainAccountId,@TransactionDate,@LastModified,@LastModifiedBy,@JournalDetails,@DocumentId,@PEOASOCoCheck,@OriginalDate,@IsReIssued,@OriginalCheckNumber,@ReIssuedDate, @CompanyIntId); select cast(scope_identity() as int)";
			var mapped = _mapper.Map<Models.Journal, Journal>(journal);
			using (var conn = GetConnection())
			{
				if (mapped.Id == 0)
				{
					if (journal.TransactionType == TransactionType.RegularCheck ||
									 journal.TransactionType == TransactionType.DeductionPayment)
					{
						const string sql = "select @NewCheckNumber = dbo.GetCheckNumber(@CompanyIntId, @PayrollPayCheckId, @PEOASOCoCheck, @TransactionType, @CheckNumber, @IsPEOPayroll); select @NewCheckNumber as checknumber";
						dynamic result =
							conn.Query(sql, new { CheckNumber = mapped.CheckNumber, NewCheckNumber = mapped.CheckNumber, CompanyIntId = mapped.CompanyIntId, TransactionType = (int)mapped.TransactionType, CompanyId = mapped.CompanyId, PayrollPayCheckId = mapped.PayrollPayCheckId, PEOASOCoCheck = mapped.PEOASOCoCheck, IsPEOPayroll = false }).FirstOrDefault();
						if (result.checknumber != null)
						{
							mapped.CheckNumber = result.checknumber;
						}
					}
					mapped.Id = conn.Query<int>(insertjournal, mapped).Single();
				}
				else
				{
					const string updatejournal =
							"update checkbookjournal set Amount=@Amount, Memo=@Memo, TransactionDate=@TransactionDate, CheckNumber=@CheckNumber, IsVoid=@IsVoid, PayeeId=@PayeeId, PayeeName=@PayeeName, JournalDetails=@JournalDetails Where Id=@Id";
					var rowsUpdated = conn.Execute(updatejournal, mapped);
					if (rowsUpdated == 0)
					{
						mapped.Id = conn.Query<int>(insertjournal, mapped).Single();
					}
				}
			}
			return _mapper.Map<Models.DataModel.Journal, Models.Journal>(mapped);
		}


		
		
		public Models.Journal VoidJournal(Models.Journal journal, TransactionType transactionType, string name)
		{
			journal.IsVoid = true;
			journal.LastModified = DateTime.Now;
			journal.LastModifiedBy = name;
			using (var conn = GetConnection())
			{
				const string updatepayrolljournal = @"update Journal set IsVoid=1, LastModifiedBy=@LastModifiedBy, LastModified=getdate() Where Id=@Id";
				const string updatecheckbookjournal = @"update CheckbookJournal set IsVoid=1, LastModifiedBy=@LastModifiedBy, LastModified=getdate() Where Id=@Id";
				if (transactionType==TransactionType.PayCheck)
					conn.Execute(updatepayrolljournal, new { Id = journal.Id, LastModifiedBy = name });
				else
				{
					conn.Execute(updatecheckbookjournal, new { Id = journal.Id, LastModifiedBy = name });
				}
			}
			
			return journal;
		}

		public Models.Journal UnVoidJournal(Models.Journal journal, TransactionType transactionType, string name)
		{
			journal.IsVoid = false;
			journal.LastModified = DateTime.Now;
			journal.LastModifiedBy = name;
			using (var conn = GetConnection())
			{
				const string updatepayrolljournal = @"update Journal set IsVoid=0, LastModifiedBy=@LastModifiedBy, LastModified=getdate() Where Id=@Id";
				const string updatecheckbookjournal = @"update CheckbookJournal set IsVoid=0, LastModifiedBy=@LastModifiedBy, LastModified=getdate() Where Id=@Id";
				if (transactionType == TransactionType.PayCheck)
					conn.Execute(updatepayrolljournal, new { Id = journal.Id, LastModifiedBy = name });
				else
				{
					conn.Execute(updatecheckbookjournal, new { Id = journal.Id, LastModifiedBy = name });
				}
			}
			return journal;
			
		}

		
		
		public List<Models.Journal> GetJournalListForPositivePay(Guid? companyId, DateTime startDate, DateTime endDate)
		{
			var journals = _dbContext.Journals.AsQueryable();
			var journals1 = _dbContext.CheckbookJournals.AsQueryable();

			if (companyId.HasValue)
			{
				journals = journals.Where(j => j.CompanyId == companyId.Value);
				journals1 = journals1.Where(j => j.CompanyId == companyId.Value);
			}
				
			journals = journals.Where(j => (!j.OriginalDate.HasValue && j.TransactionDate >= startDate && j.TransactionDate <= endDate) || (j.OriginalDate.HasValue && j.OriginalDate >= startDate && j.OriginalDate <= endDate) || (j.ReIssuedDate.HasValue && j.IsReIssued && j.ReIssuedDate.Value >= startDate && j.ReIssuedDate.Value <= endDate));
			journals1 = journals1.Where(j => (!j.OriginalDate.HasValue && j.TransactionDate >= startDate && j.TransactionDate <= endDate) || (j.OriginalDate.HasValue && j.OriginalDate >= startDate && j.OriginalDate <= endDate) || (j.ReIssuedDate.HasValue && j.IsReIssued && j.ReIssuedDate.Value >= startDate && j.ReIssuedDate.Value <= endDate));
			
			var j2 = _mapper.Map<List<Models.DataModel.Journal>, List<Models.Journal>>(journals.ToList());
			var j1 = _mapper.Map<List<Models.DataModel.CheckbookJournal>, List<Models.Journal>>(journals1.ToList());
			j2.AddRange(j1);
			return j2.ToList();
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

		public void DeleteJournals(int extractId)
		{
			var me1 = _dbContext.MasterExtracts.First(m => m.Id == extractId);
			var journals = JsonConvert.DeserializeObject<List<int>>(me1.Journals);
			const string deletejournals =
				@"delete from CheckbookJournal where Id=@Id";
			const string deleteextract = @"delete from PayCheckExtract where MasterExtractId=@MasterExtractId;delete from CommissionExtract where MasterExtractId=@MasterExtractId;delete from MasterExtracts where Id=@MasterExtractId;";
			
			using (var conn = GetConnection())
			{
				journals.ForEach(j=>conn.Execute(deletejournals, new {Id=j}));
				conn.Execute(deleteextract, new {MasterExtractId = extractId});
				
			}
		}

		public decimal GetJournalBalance(int accountId)
		{
			var sql = "select dbo.GetJournalBalance(@AccountId) as balance";


			using (var conn = GetConnection())
			{
				dynamic result =
					conn.Query(sql, new { AccountId = accountId }).FirstOrDefault();
				if (result != null)
					return result.balance;



			}
			return 0;
			
		}

		public void DeletePayrollJournals(List<Models.Journal> toList)
		{
			const string sql = "delete from Journal where Id=@Id";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, toList);
			}
		}


		public MasterExtract SaveMasterExtract(MasterExtract masterExtract, List<int> payCheckIds, List<int> voidedCheckIds, List<Models.Journal> journalList)
		{
			
			var mappedJournals = _mapper.Map<List<Models.Journal>, List<Journal>>(journalList);
			
			const string insertExtract = @"insert into MasterExtracts(StartDate, EndDate, ExtractName, IsFederal, DepositDate, Journals, LastModified, LastModifiedBy) values(@StartDate, @EndDate, @ExtractName, @IsFederal, @DepositDate, @Journals, @LastModified, @LastModifiedBy); select cast(scope_identity() as int)";
			const string insertPayCheckExtract =
				"insert into PayCheckExtract(PayrollPayCheckId, MasterExtractId, Extract, Type) values(@PayrollPayCheckId, @MasterExtractId, @Extract, @Type);";
			const string insertJournals = "insert into CheckbookJournal( CompanyId, TransactionType, PaymentMethod, CheckNumber, PayrollPayCheckId, EntityType, PayeeId, PayeeName, Amount, Memo, IsDebit, IsVoid, MainAccountId, TransactionDate, LastModified, LastModifiedBy, JournalDetails, DocumentId, PEOASOCoCheck, OriginalDate, CompanyIntId) " +
			                              "select @CompanyId, @TransactionType, @PaymentMethod, " +
																		"case when @TransactionType in (2,6) and exists(select 'x' from dbo.CompanyJournalCheckbook where CompanyIntId=@CompanyIntId and TransactionType in (2,6) and CheckNumber=@CheckNumber) then (select max(CheckNumber)+1 from dbo.CompanyJournalCheckbook where CompanyIntId=@CompanyIntId and TransactionType in (2,6))" +
			                              " else @CheckNumber end, @PayrollPayCheckId, @EntityType, @PayeeId, @PayeeName, @Amount, @Memo, @IsDebit, @IsVoid, @MainAccountId, @TransactionDate, @LastModified, @LastModifiedBy, @JournalDetails, @DocumentId, @PEOASOCoCheck, @OriginalDate, @CompanyIntId;select cast(scope_identity() as int)";

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
				
				return _mapper.Map<Models.DataModel.MasterExtract, Models.MasterExtract>(mapped);
			}
			
		}

		
	}
}

using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Transactions;
using Dapper;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.Infrastructure.Transactions;

namespace HrMaxx.Common.Repository.Mementos
{
	public class MementoDataRepository : BaseDapperRepository, IMementoDataRepository
	{
		public MementoDataRepository(DbConnection connection)
			: base(connection)
		{
		}

		public void SaveMemento(MementoPersistenceDto memento, bool isSubVersion)
		{
			const string sql =
				@"INSERT INTO Common.Memento(memento, originatortype, version, mementoid, sourcetypeid, createdby) VALUES (@Memento, @OriginatorType, @Version, @MementoId, @SourceTypeId, @CreatedBy)";
			const string versionSql =
				@"SELECT MAX(version) as version FROM Common.Memento WHERE originatortype = @OriginatorType AND mementoid = @MementoId";

			using (TransactionScope txn = TransactionScopeHelper.Transaction())
			{
				dynamic currentVersion =
					Connection.Query(versionSql, new {memento.OriginatorType, memento.MementoId}).FirstOrDefault();
				var nextVersion = (decimal)1;
				if (currentVersion.version != null)
				{
					if (isSubVersion)
					{
						var nextBigVersion = currentVersion.version + 1;
						if ((currentVersion.version + (decimal)0.1) == nextBigVersion)
						{
							nextVersion = nextBigVersion + (decimal)0.1;
						}
						else
						{
							nextVersion = currentVersion.version + (decimal)0.1;
						}
					}
					else
					{
						nextVersion = currentVersion.version + (decimal)1;
					}
				}
				

				Connection.Execute(sql, new
				{
					memento.Memento,
					memento.OriginatorType,
					Version = nextVersion,
					memento.MementoId,
					memento.SourceTypeId,
					memento.CreatedBy
				});

				txn.Complete();
			}
		}

		public IEnumerable<MementoPersistenceDto> GetMementoData<T>(Guid mementoId)
		{
			const string sql =
				@"SELECT Id, Memento, OriginatorType, Version, DateCreated, SourceTypeId, CreatedBy FROM Common.Memento WHERE OriginatorType = @OriginatorType AND MementoId = @MementoId ORDER BY Version ASC";

			string originatorType = typeof (T).FullName;

			IEnumerable<MementoPersistenceDto> results = Connection.Query<MementoPersistenceDto>(sql,
				new {OriginatorType = originatorType, MementoId = mementoId});
			return results;
		}

		public void DeleteMementoData<T>(Guid mementoId)
		{
			const string sql = @"DELETE FROM Common.Memento WHERE MementoId = @MementoId";

			using (TransactionScope txn = TransactionScopeHelper.Transaction())
			{
				Connection.Execute(sql, new {MementoId = mementoId});
				txn.Complete();
			}
		}

		public MementoPersistenceDto GetMostRecentMemento<T>(Guid mementoId)
		{
			const string sql =
				@"SELECT TOP 1 Id, Memento, OriginatorType, Version, MementoId, CreatedBy, SourceTypeId FROM Common.Memento WHERE OriginatorType = @OriginatorType AND MementoId = @MementoId ORDER BY Version DESC";

			string originatorType = typeof (T).FullName;

			MementoPersistenceDto dto =
				Connection.Query<MementoPersistenceDto>(sql, new {OriginatorType = originatorType, MementoId = mementoId})
					.SingleOrDefault();

			return dto;
		}

		public IEnumerable<MementoPersistenceDto> GetMementoData<T>()
		{
			const string sql =
				@"SELECT Id, Memento, OriginatorType, Version, DateCreated, SourceTypeId, CreatedBy FROM Common.Memento WHERE OriginatorType = @OriginatorType ORDER BY Version ASC";

			string originatorType = typeof (T).FullName;

			IEnumerable<MementoPersistenceDto> results = Connection.Query<MementoPersistenceDto>(sql,
				new {OriginatorType = originatorType});
			return results;
		}

		public IEnumerable<MementoPersistenceDto> GetMementos<T>(int sourceTypeId, Guid sourceId)
		{
			const string sql =
				@"SELECT Id, Memento, OriginatorType, Version, DateCreated, SourceTypeId, CreatedBy FROM Common.Memento WHERE SourceTypeId = @SourceTypeId and MementoId=@SourceId ORDER BY Version DESC";

			string originatorType = typeof(T).FullName;

			IEnumerable<MementoPersistenceDto> results = Connection.Query<MementoPersistenceDto>(sql,
				new { SourceTypeId = sourceTypeId, SourceId=sourceId });
			return results;
		}
	}
}
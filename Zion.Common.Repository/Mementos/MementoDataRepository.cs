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

		public void SaveMemento(MementoPersistenceDto memento)
		{
			const string sql =
				@"INSERT INTO Common.Mementos(memento, originatortype, version, mementoid) VALUES (@Memento, @OriginatorType, @Version, @MementoId)";
			const string versionSql =
				@"SELECT MAX(version) as version FROM Common.Mementos WHERE originatortype = @OriginatorType AND mementoid = @MementoId";

			using (TransactionScope txn = TransactionScopeHelper.Transaction())
			{
				dynamic currentVersion =
					Connection.Query(versionSql, new {memento.OriginatorType, memento.MementoId}).FirstOrDefault();
				int nextVersion = currentVersion.version != null ? currentVersion.version + 1 : 1;

				Connection.Execute(sql, new
				{
					memento.Memento,
					memento.OriginatorType,
					Version = nextVersion,
					memento.MementoId
				});

				txn.Complete();
			}
		}

		public IEnumerable<MementoPersistenceDto> GetMementoData<T>(Guid mementoId)
		{
			const string sql =
				@"SELECT Id, Memento, OriginatorType, Version, DateCreated FROM Common.Mementos WHERE OriginatorType = @OriginatorType AND MementoId = @MementoId ORDER BY Version ASC";

			string originatorType = typeof (T).FullName;

			IEnumerable<MementoPersistenceDto> results = Connection.Query<MementoPersistenceDto>(sql,
				new {OriginatorType = originatorType, MementoId = mementoId});
			return results;
		}

		public void DeleteMementoData<T>(Guid mementoId)
		{
			const string sql = @"DELETE FROM Common.Mementos WHERE MementoId = @MementoId";

			using (TransactionScope txn = TransactionScopeHelper.Transaction())
			{
				Connection.Execute(sql, new {MementoId = mementoId});
				txn.Complete();
			}
		}

		public MementoPersistenceDto GetMostRecentMemento<T>(Guid mementoId)
		{
			const string sql =
				@"SELECT TOP 1 Id, Memento, OriginatorType, Version, MementoId FROM Common.Mementos WHERE OriginatorType = @OriginatorType AND MementoId = @MementoId ORDER BY Version DESC";

			string originatorType = typeof (T).FullName;

			MementoPersistenceDto dto =
				Connection.Query<MementoPersistenceDto>(sql, new {OriginatorType = originatorType, MementoId = mementoId})
					.SingleOrDefault();

			return dto;
		}

		public IEnumerable<MementoPersistenceDto> GetMementoData<T>()
		{
			const string sql =
				@"SELECT Id, Memento, OriginatorType, Version, DateCreated FROM Common.Mementos WHERE OriginatorType = @OriginatorType ORDER BY Version ASC";

			string originatorType = typeof (T).FullName;

			IEnumerable<MementoPersistenceDto> results = Connection.Query<MementoPersistenceDto>(sql,
				new {OriginatorType = originatorType});
			return results;
		}
	}
}
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
	public class StagingDataRepository : BaseDapperRepository, IStagingDataRepository
	{
		public StagingDataRepository(DbConnection connection)
			: base(connection)
		{
		}

		public void SaveMemento(StagingDataDto memento)
		{
			const string sql =
				@"INSERT INTO Common.StagingData(MementoId, OriginatorType, Memento) VALUES (@MementoId, @OriginatorType, @Memento)";

			using (TransactionScope txn = TransactionScopeHelper.Transaction())
			{
				Connection.Execute(sql, new
				{
					memento.MementoId,
					memento.OriginatorType,
					memento.Memento,
				});

				txn.Complete();
			}
		}

		public List<StagingDataDto> GetStagingData<T>(Guid mementoId)
		{
			const string sql =
				@"SELECT Id, MementoId, Memento, OriginatorType, DateCreated FROM Common.StagingData WHERE OriginatorType = @OriginatorType AND MementoId = @MementoId";

			string originatorType = typeof (T).FullName;

			List<StagingDataDto> dto =
				Connection.Query<StagingDataDto>(sql, new {OriginatorType = originatorType, MementoId = mementoId}).ToList();

			return dto;
		}

		public void DeleteStagingData<T>(Guid mementoId)
		{
			string originatorType = typeof (T).FullName;

			const string sql =
				@"DELETE FROM Common.StagingData WHERE MementoId = @MementoId AND OriginatorType = @OriginatorType";

			using (TransactionScope txn = TransactionScopeHelper.Transaction())
			{
				Connection.Execute(sql, new {MementoId = mementoId, OriginatorType = originatorType});
				txn.Complete();
			}
		}

		public StagingDataDto GetMostRecentMemento<T>(Guid mementoId)
		{
			const string sql =
				@"SELECT TOP 1 Id, Memento, OriginatorType, MementoId, DateCreated FROM Common.StagingData WHERE OriginatorType = @OriginatorType AND MementoId = @MementoId ORDER BY DateCreated DESC";

			string originatorType = typeof (T).FullName;

			StagingDataDto dto =
				Connection.Query<StagingDataDto>(sql, new {OriginatorType = originatorType, MementoId = mementoId})
					.SingleOrDefault();

			return dto;
		}
	}
}
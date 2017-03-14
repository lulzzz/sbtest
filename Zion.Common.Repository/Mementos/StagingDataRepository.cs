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

				OpenConnection();
				Connection.Execute(sql, new
				{
					memento.MementoId,
					memento.OriginatorType,
					memento.Memento,
				});
			Connection.Close();


		}

		public List<StagingDataDto> GetStagingData<T>(Guid mementoId)
		{
			
				const string sql =
					@"SELECT Id, MementoId, Memento, OriginatorType, DateCreated FROM Common.StagingData WHERE OriginatorType = @OriginatorType AND MementoId = @MementoId";

				string originatorType = typeof (T).FullName;
				OpenConnection();
				List<StagingDataDto> dto =
					Connection.Query<StagingDataDto>(sql, new { OriginatorType = originatorType, MementoId = mementoId }).ToList();
				Connection.Close();
				return dto;
			
		}

		public void DeleteStagingData<T>(Guid mementoId)
		{
			
				string originatorType = typeof (T).FullName;

				const string sql =
					@"DELETE FROM Common.StagingData WHERE MementoId = @MementoId AND OriginatorType = @OriginatorType";
				OpenConnection();

				Connection.Execute(sql, new { MementoId = mementoId, OriginatorType = originatorType });
				Connection.Close();
		}

		public StagingDataDto GetMostRecentMemento<T>(Guid mementoId)
		{
			
				const string sql =
					@"SELECT TOP 1 Id, Memento, OriginatorType, MementoId, DateCreated FROM Common.StagingData WHERE OriginatorType = @OriginatorType AND MementoId = @MementoId ORDER BY DateCreated DESC";

				string originatorType = typeof (T).FullName;
				OpenConnection();
				StagingDataDto dto =
					Connection.Query<StagingDataDto>(sql, new {OriginatorType = originatorType, MementoId = mementoId})
						.SingleOrDefault();
				Connection.Close();
				return dto;
			
		}
	}
}
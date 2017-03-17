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
			using (var conn = GetConnection())
			{
				const string sql =
					@"INSERT INTO Common.StagingData(MementoId, OriginatorType, Memento) VALUES (@MementoId, @OriginatorType, @Memento)";

				
				conn.Execute(sql, new
				{
					memento.MementoId,
					memento.OriginatorType,
					memento.Memento,
				});
				
			}

		}

		public List<StagingDataDto> GetStagingData<T>(Guid mementoId)
		{
			using (var conn = GetConnection())
			{
				const string sql =
					@"SELECT Id, MementoId, Memento, OriginatorType, DateCreated FROM Common.StagingData WHERE OriginatorType = @OriginatorType AND MementoId = @MementoId";

				string originatorType = typeof(T).FullName;
				
				List<StagingDataDto> dto =
					conn.Query<StagingDataDto>(sql, new { OriginatorType = originatorType, MementoId = mementoId }).ToList();
				
				return dto;
			}
				
			
		}

		public void DeleteStagingData<T>(Guid mementoId)
		{
			using (var conn = GetConnection())
			{
				string originatorType = typeof(T).FullName;

				const string sql =
					@"DELETE FROM Common.StagingData WHERE MementoId = @MementoId AND OriginatorType = @OriginatorType";
				

				conn.Execute(sql, new { MementoId = mementoId, OriginatorType = originatorType });
				
			}
				
		}

		public StagingDataDto GetMostRecentMemento<T>(Guid mementoId)
		{
			using (var conn = GetConnection())
			{
				const string sql =
									@"SELECT TOP 1 Id, Memento, OriginatorType, MementoId, DateCreated FROM Common.StagingData WHERE OriginatorType = @OriginatorType AND MementoId = @MementoId ORDER BY DateCreated DESC";

				string originatorType = typeof(T).FullName;
				
				StagingDataDto dto =
					conn.Query<StagingDataDto>(sql, new { OriginatorType = originatorType, MementoId = mementoId })
						.SingleOrDefault();
				
				return dto;
			}
				
			
		}
	}
}
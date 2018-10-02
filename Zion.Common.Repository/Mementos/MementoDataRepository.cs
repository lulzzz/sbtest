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

		public MementoPersistenceDto SaveMemento(MementoPersistenceDto memento, bool isSubVersion)
		{
			
				const string sql =
					@"INSERT INTO Common.Memento( originatortype, version, mementoid, sourcetypeid, createdby, comments, userid) VALUES ( @OriginatorType, @Version, @MementoId, @SourceTypeId, @CreatedBy, @Comments, @UserId); select cast(scope_identity() as int)";
				const string versionSql =
					@"SELECT MAX(version) as version FROM Common.Memento WHERE originatortype = @OriginatorType AND mementoid = @MementoId";

			using (var connection = GetConnection())
			{
				dynamic currentVersion =
					connection.Query(versionSql, new { memento.OriginatorType, memento.MementoId }).FirstOrDefault();
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
						nextVersion = Math.Floor(currentVersion.version) + (decimal)1;
					}
				}


				memento.Id = connection.Query<int>(sql, new
				{
					memento.Memento,
					memento.OriginatorType,
					Version = nextVersion,
					memento.MementoId,
					memento.SourceTypeId,
					memento.CreatedBy,
					memento.Comments,
					memento.UserId
				}).Single();
			}
			return memento;


		}

		public IEnumerable<MementoPersistenceDto> GetMementoData(Guid mementoId)
		{
			
				const string sql =
					@"SELECT Id, OriginatorType, Version, DateCreated, SourceTypeId, CreatedBy FROM Common.Memento WHERE MementoId = @MementoId ORDER BY Version ASC";
			using (var conn = GetConnection())
			{
				IEnumerable<MementoPersistenceDto> results = conn.Query<MementoPersistenceDto>(sql,
					new {  MementoId = mementoId });
				
				return results;
			}
				
			
		}

		public void DeleteMementoData<T>(Guid mementoId)
		{
			const string sql = @"DELETE FROM Common.Memento WHERE MementoId = @MementoId";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, new { MementoId = mementoId });
			}
				
		}

		public MementoPersistenceDto GetMostRecentMemento<T>(Guid mementoId)
		{

			using (var conn = GetConnection())
			{
				const string sql =
				@"SELECT TOP 1 Id, OriginatorType, Version, MementoId, CreatedBy, SourceTypeId, Comments, UserId FROM Common.Memento WHERE OriginatorType = @OriginatorType AND MementoId = @MementoId ORDER BY Version DESC";

				string originatorType = typeof(T).FullName;
				
				MementoPersistenceDto dto =
					conn.Query<MementoPersistenceDto>(sql, new { OriginatorType = originatorType, MementoId = mementoId })
						.SingleOrDefault();
				
				return dto;
			}
		}

		public IEnumerable<MementoPersistenceDto> GetMementoData<T>()
		{
			using (var conn = GetConnection())
			{
				const string sql =
					@"SELECT Id, OriginatorType, Version, DateCreated, SourceTypeId, CreatedBy, Comments, UserId FROM Common.Memento WHERE OriginatorType = @OriginatorType ORDER BY Version ASC";

				string originatorType = typeof(T).FullName;
				
				IEnumerable<MementoPersistenceDto> results = conn.Query<MementoPersistenceDto>(sql,
					new { OriginatorType = originatorType });
				
				return results;
			}
		}

		public IEnumerable<MementoPersistenceDto> GetMementos<T>(int sourceTypeId, Guid sourceId)
		{
			using (var conn = GetConnection())
			{
				const string sql =
									@"SELECT Id, OriginatorType, Version, DateCreated, SourceTypeId, CreatedBy, Comments, UserId, MementoId FROM Common.Memento WHERE SourceTypeId = @SourceTypeId and MementoId=@SourceId ORDER BY Version DESC";

				IEnumerable<MementoPersistenceDto> results = conn.Query<MementoPersistenceDto>(sql,
					new { SourceTypeId = sourceTypeId, SourceId = sourceId });
				
				return results;
			}
				
			
		}
	}
}
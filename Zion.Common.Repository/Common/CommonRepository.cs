using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using Dapper;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Mapping;
using HrMaxx.Infrastructure.Repository;
using HrMaxx.OnlinePayroll.Models;
using Magnum;
using Newtonsoft.Json;
using InsuranceGroup = HrMaxx.Common.Models.InsuranceGroupDto;
using News = HrMaxx.Common.Models.Dtos.News;

namespace HrMaxx.Common.Repository.Common
{
	public class CommonRepository : BaseDapperRepository, ICommonRepository
	{
		private readonly CommonEntities _dbContext;
		private readonly IMapper _mapper;
		private string _sqlCon;

		public CommonRepository(IMapper mapper, CommonEntities dbContext, string sqlCon, DbConnection connection)
			: base(connection)
		{
			_mapper = mapper;
			_dbContext = dbContext;
			_sqlCon = sqlCon;
		}

		public IList<T> GetEntityRelations<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId)
		{
			var result = new List<T>();
			//var relations = _dbContext.EntityRelations.Where(er => er.SourceEntityTypeId == (int) source
			//																											&& er.TargetEntityTypeId == (int) target
			//																											&& er.SourceEntityId == sourceId
			//																								).ToList();
			const string sql = "select * from EntityRelation where SourceEntityTypeId=@SourceEntityTypeId and TargetEntityTypeId=@TargetEntityTypeId and SourceEntityId=@SourceEntityId";
			var relations = Query<EntityRelation>(sql, new { SourceEntityTypeId =source, TargetEntityTypeId = target, SourceEntityId=sourceId});
			relations.ForEach(r => result.Add(JsonConvert.DeserializeObject<T>(r.TargetObject)));
			return result;
		}

		public T AddEntityRelation<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, T targetObject)
		{
			var dbEntityRelation = new Models.DataModel.EntityRelation{SourceEntityTypeId = (int) source, TargetEntityTypeId = (int) target, SourceEntityId = sourceId, TargetEntityId = (targetObject as BaseEntityDto).Id, TargetObject = JsonConvert.SerializeObject(targetObject)};
			_dbContext.EntityRelations.Add(dbEntityRelation);
			_dbContext.SaveChanges();
			return targetObject;
		}

		public T GetTargetEntity<T>(EntityTypeEnum target, Guid targetId)
		{
			//var entity =
			//	_dbContext.EntityRelations.FirstOrDefault(
			//		er => er.TargetEntityTypeId == (int) target && er.TargetEntityId == targetId);
			var entity = QueryObject<EntityRelation>("select top(1) * from EntityRelation where TargetEntityTypeId=@TargetEntityTypeId and TargetEntityId=@TargetEntityId", new { TargetEntityTypeId = (int)target, TargetEntityId = targetId });
			if (entity == null)
				return default(T);
			return JsonConvert.DeserializeObject<T>(entity.TargetObject);
		}

		public IList<T> GetAllTargets<T>(EntityTypeEnum target)
		{
			var result = new List<T>();
			//var targets =
			//	_dbContext.EntityRelations.Where(er => er.TargetEntityTypeId == (int) target)
			//		.ToList();
			var targets = Query<EntityRelation>("select * from EntityRelation where TargetEntityTypeId=@TargetEntityTypeId", new { TargetEntityTypeId = (int)target });
			targets.ForEach(r => result.Add(JsonConvert.DeserializeObject<T>(r.TargetObject)));
			return result;
		}

		public void DeleteEntityRelation(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, Guid targetId)
		{
			var relation = _dbContext.EntityRelations.FirstOrDefault(er=>er.SourceEntityTypeId==(int)source
																																		&& er.TargetEntityTypeId==(int)target
																																		&& er.SourceEntityId == sourceId
																																		&& er.TargetEntityId == targetId
																															);
			if (relation != null)
			{
				_dbContext.EntityRelations.Remove(relation);
				_dbContext.SaveChanges();
			}
		}

		public IList<Models.Dtos.Country> GetCountries()
		{
			const string sql = "select * from Country";
			//var countries = _dbContext.Countries.ToList();
			var countries = Query<Models.DataModel.Country>(sql);
			return countries.Select(c => JsonConvert.DeserializeObject<Models.Dtos.Country>(c.Data)).ToList();
		}
		public IList<Models.Dtos.Country> SaveCountries(Models.Dtos.Country countries)
		{
			var country = _dbContext.Countries.First(c=>c.CountryId==countries.CountryId);
			country.Data = JsonConvert.SerializeObject(countries);
			_dbContext.SaveChanges();
			return GetCountries();
		}

		public T SaveEntityRelation<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, T targetObject)
		{
			var targetId = (targetObject as BaseEntityDto).Id;
			var dbEntity = _dbContext.EntityRelations.FirstOrDefault(er => er.SourceEntityTypeId == (int) source
																																		&& er.TargetEntityTypeId == (int) target
																																		&& er.SourceEntityId == sourceId
																																		&& er.TargetEntityId == targetId
																															);
			if (dbEntity == null)
			{
				return AddEntityRelation<T>(source, target, sourceId, targetObject);
			}
			dbEntity.TargetObject = JsonConvert.SerializeObject(targetObject);
			_dbContext.SaveChanges();
			return targetObject;
		}

		public void SaveTargetList<T>(EntityTypeEnum sourceTypeId, EntityTypeEnum targetTypeId, Guid sourceId, T list)
		{
			var dbEntity = _dbContext.EntityRelations.FirstOrDefault(er => er.SourceEntityTypeId == (int)sourceTypeId
																																		&& er.TargetEntityTypeId == (int)targetTypeId
																																		&& er.SourceEntityId == sourceId
																															);
			if (dbEntity == null)
			{
				var dbEntityRelation = new Models.DataModel.EntityRelation { SourceEntityTypeId = (int)sourceTypeId, TargetEntityTypeId = (int)targetTypeId, SourceEntityId = sourceId, TargetEntityId = CombGuid.Generate(), TargetObject = JsonConvert.SerializeObject(list) };
				_dbContext.EntityRelations.Add(dbEntityRelation);
			}
			else
			{
				dbEntity.TargetObject = JsonConvert.SerializeObject(list);
			}
			
			_dbContext.SaveChanges();
			
		}

		public IList<T> GetEntityRelationList<T>(object source, object target, Guid sourceId)
		{
			//var relation = _dbContext.EntityRelations.FirstOrDefault(er => er.SourceEntityTypeId == (int)source);
			var relation = QueryObject<EntityRelation>("select top(1) * from EntityRelation where SourceEntityTypeId=@SourceEntityTypeId and SourceEntityId=@SourceEntityId and TargetEntityTypeId=@TargetEntityTypeId", new { TargetEntityTypeId = (int)target, SourceEntityId = sourceId, SourceEntityTypeId=source });
			return relation == null ? new List<T>() : JsonConvert.DeserializeObject<List<T>>(relation.TargetObject);

		}

		public List<News> GetNewsListforUser(int? audienceScope, Guid? audienceId)
		{
			const string sql = "select * from News";
			var news = Query<Models.DataModel.News>(sql);
			news = news.Where(n => (audienceScope.HasValue && n.AudienceScope <= audienceScope) || !audienceScope.HasValue).ToList();
			
			if (audienceScope.HasValue && audienceId.HasValue)
			{
				news =
					news.Where(n => n.AudienceScope<audienceScope.Value || JsonConvert.DeserializeObject<List<IdValuePair>>(n.Audience).Any(g => g.Key.Equals(audienceId.Value))).ToList();
			}
			return _mapper.Map<List<Models.DataModel.News>, List<News>>(news);
		}

		public void SaveNewsfeedItem(News news)
		{
			var mappedNewsItem = _mapper.Map<News, Models.DataModel.News>(news);
			var dbNews = _dbContext.News.FirstOrDefault(n => n.Id == news.Id);
			if(dbNews==null)
				_dbContext.News.Add(mappedNewsItem);
			else
			{
				dbNews.Title = mappedNewsItem.Title;
				dbNews.NewsContent = mappedNewsItem.NewsContent;
				dbNews.Audience = mappedNewsItem.Audience;
				dbNews.AudienceScope = mappedNewsItem.AudienceScope;
				dbNews.LastModified = mappedNewsItem.LastModified;
				dbNews.LastModifiedBy = mappedNewsItem.LastModifiedBy;
				dbNews.IsActive = mappedNewsItem.IsActive;
			}
			_dbContext.SaveChanges();
		}

		public List<News> GetUserNewsfeed(Guid host, Guid company, string userId)
		{
			var returnList = new List<Models.DataModel.News>();
			var news = Query<Models.DataModel.News>("select * from News where IsActive=1 and AudienceScope is not null");
			news = news.Where(n =>
				(n.AudienceScope.Value == (int) RoleTypeEnum.Host &&
				 JsonConvert.DeserializeObject<List<IdValuePair>>(n.Audience).Any(g => g.Key.Equals(host)))
				||
				(n.AudienceScope.Value == (int) RoleTypeEnum.Company &&
				 JsonConvert.DeserializeObject<List<IdValuePair>>(n.Audience).Any(g => g.Key.Equals(company)))
				).ToList();
			return _mapper.Map<List<Models.DataModel.News>, List<News>>(news);
		}

		public List<InsuranceGroupDto> GetInsuranceGroups()
		{
			using (var conn = GetConnection())
			{
				var groups = conn.Query<Models.DataModel.InsuranceGroup>("select * from InsuranceGroup").ToList();
				return _mapper.Map<List<Models.DataModel.InsuranceGroup>, List<Models.InsuranceGroupDto>>(groups);	
			}
			
		}

		public InsuranceGroup SaveInsuranceGroup(InsuranceGroupDto insuranceGroup)
		{
			var mapped = _mapper.Map<Models.InsuranceGroupDto, Models.DataModel.InsuranceGroup>(insuranceGroup);
			if (mapped.Id == 0)
			{
				_dbContext.InsuranceGroups.Add(mapped);
				_dbContext.SaveChanges();
			}
			else
			{
				var db = _dbContext.InsuranceGroups.FirstOrDefault(i => i.Id == insuranceGroup.Id);
				if (db != null)
				{
					db.GroupName = mapped.GroupName;
					db.GroupNo = mapped.GroupNo;
					_dbContext.SaveChanges();
				}
			}
			return _mapper.Map<Models.DataModel.InsuranceGroup, Models.InsuranceGroupDto>(mapped);
		}

		public void UpdateDBStats()
		{
			const string sql = "exec sp_updatestats;";
			
			using (var con = new SqlConnection(_sqlCon))
			{
				using (var cmd = new SqlCommand(sql))
				{
					cmd.CommandTimeout = 0;
					cmd.CommandType = CommandType.Text;
					cmd.Connection = con;
					con.Open();
					cmd.ExecuteNonQuery();
					con.Close();
				}
			}
		}

		public Document AddDocument(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId,
            DocumentDto targetObject)
		{
			const string sql = "insert into Document (SourceEntityTypeId, SourceEntityId, TargetEntityId, Type, CompanyDocumentSubType, TargetObject, Uploaded, UploadedBy) " +
												 "values (@SourceEntityTypeId, @SourceEntityId, @TargetEntityId, @Type, @CompanyDocumentSubType, @TargetObject, @Uploaded, @UploadedBy); select cast(scope_identity() as int) as Id;";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, new
				{
					SourceEntityTypeId = (int) source,
					SourceEntityId = sourceId,
					TargetEntityId = targetObject.Id,
					Type = targetObject.Type.Id,
					CompanyDocumentSubType =
						targetObject.CompanyDocumentSubType == null ? default(int?) : targetObject.CompanyDocumentSubType.Id,
						TargetObject = JsonConvert.SerializeObject(targetObject), Uploaded = DateTime.Now, UploadedBy = targetObject.UserName
				});
                return GetDocument(targetObject.Id);
            }
		}

		public Document GetDocument(Guid documentId)
		{
			const string sql = "select * from Document where TargetEntityId=@Id";
			using (var conn = GetConnection())
			{
				return conn.Query<Document>(sql, new {Id = documentId}).First();
			}
		}

		public void DeleteDocument(Guid entityId, Guid documentId)
		{
			const string sql = "delete from Document where SourceEntityId=@Source and TargetEntityId=@Id";
			using (var conn = GetConnection())
			{
				conn.Execute(sql, new {Source = entityId, Id = documentId});
			}
		}

		public IList<Document> GetDocuments(EntityTypeEnum entityType, Guid entityId)
		{
			const string sql = "select * from Document where SourceEntityTypeId=@SourceType and SourceEntityId=@Id";
			using (var conn = GetConnection())
			{
                return conn.Query<Document>(sql, new { Id = entityId, SourceType=entityType.GetDbId() }).ToList();
                
            }
		}

		public void AddEmployeeDocument(Guid? companyId, Guid entityId, DocumentDto document)
		{
			const string sql = "insert into EmployeeDocument(CompanyDocumentSubType, EmployeeId, CompanyId, DocumentId, DateUploaded, UploadedBy) values(@CompanyDocumentSubType, @EmployeeId, @CompanyId, @DocumentId, @DateUploaded, @UploadedBy)";
			using (var conn = GetConnection())
			{
				conn.Execute(sql,
					new
					{
						CompanyDocumentSubType = document.CompanyDocumentSubType.Id,
						EmployeeId = entityId,
						CompanyId = companyId,
						DocumentId = document.Id,
						DateUploaded = document.LastModified,
						UploadedBy = document.UserName
					});
			}
		}

		public void ExecuteQuery<T>(string sql, object param)
		{
			using (var conn = GetConnection())
			{
				conn.Execute(sql, param);
			}
		}

        public void DeleteEmployeeDocument(Guid employeeId, Guid documentId)
        {
            const string sql = "delete from EmployeeDocument where EmployeeId=@EmployeeId and DocumentId=@DocumentId;";
            using (var conn = GetConnection())
            {
                conn.Execute(sql,
                    new
                    {
                        EmployeeId = employeeId,
                        DocumentId = documentId
                    });
            }
        }
    }
}
﻿using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Mapping;
using Magnum;
using Newtonsoft.Json;
using News = HrMaxx.Common.Models.Dtos.News;

namespace HrMaxx.Common.Repository.Common
{
	public class CommonRepository : ICommonRepository
	{
		private readonly CommonEntities _dbContext;
		private readonly IMapper _mapper;

		public CommonRepository(IMapper mapper, CommonEntities dbContext)
		{
			_mapper = mapper;
			_dbContext = dbContext;
		}

		public IList<T> GetEntityRelations<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId)
		{
			var result = new List<T>();
			var relations = _dbContext.EntityRelations.Where(er => er.SourceEntityTypeId == (int) source
																														&& er.TargetEntityTypeId == (int) target
																														&& er.SourceEntityId == sourceId
																											).ToList();
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
			var entity =
				_dbContext.EntityRelations.FirstOrDefault(
					er => er.TargetEntityTypeId == (int) target && er.TargetEntityId == targetId);
			if (entity == null)
				return default(T);
			return JsonConvert.DeserializeObject<T>(entity.TargetObject);
		}

		public IList<T> GetAllTargets<T>(EntityTypeEnum target)
		{
			var result = new List<T>();
			var targets =
				_dbContext.EntityRelations.Where(er => er.TargetEntityTypeId == (int) target)
					.ToList();
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
			var countries = _dbContext.Countries.ToList();
			return countries.Select(c => JsonConvert.DeserializeObject<Models.Dtos.Country>(c.Data)).ToList();
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
			var relation = _dbContext.EntityRelations.FirstOrDefault(er => er.SourceEntityTypeId == (int) source
																														&& er.TargetEntityTypeId == (int) target
																														&& er.SourceEntityId == sourceId
																											);
			return relation == null ? new List<T>() : JsonConvert.DeserializeObject<List<T>>(relation.TargetObject);

		}

		public List<News> GetNewsListforUser(int? audienceScope, Guid? audienceId)
		{
			var news = _dbContext.News.Where(n => (audienceScope.HasValue && n.AudienceScope <= audienceScope) || !audienceScope.HasValue).ToList();
			if (audienceScope.HasValue && audienceId.HasValue)
			{
				news =
					news.Where(n => n.AudienceScope<audienceScope.Value || JsonConvert.DeserializeObject<List<IdValuePair>>(n.Audience).Any(g => g.Key.Equals(audienceId.Value)))
						.ToList();
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
			}
			_dbContext.SaveChanges();
		}

		public List<News> GetUserNewsfeed(Guid host, Guid company, string userId)
		{
			var returnList = new List<Models.DataModel.News>();
			var news = _dbContext.News.Where(n=>n.AudienceScope.HasValue).ToList();
			news = news.Where(n =>
				(n.AudienceScope.Value == (int) RoleTypeEnum.Host &&
				 JsonConvert.DeserializeObject<List<IdValuePair>>(n.Audience).Any(g => g.Key.Equals(host)))
				||
				(n.AudienceScope.Value == (int) RoleTypeEnum.Company &&
				 JsonConvert.DeserializeObject<List<IdValuePair>>(n.Audience).Any(g => g.Key.Equals(company)))
				).ToList();
			return _mapper.Map<List<Models.DataModel.News>, List<News>>(news);
		}
	}
}
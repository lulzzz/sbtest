using System;
using System.Collections.Generic;
using System.Linq;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.DataModel;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Infrastructure.Mapping;
using Magnum;
using Newtonsoft.Json;

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
				_dbContext.EntityRelations.First(
					er => er.TargetEntityTypeId == (int) target && er.TargetEntityId == targetId);

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
	}
}
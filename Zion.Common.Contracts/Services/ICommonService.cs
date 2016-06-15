using System;
using System.Collections.Generic;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Contracts.Services
{
	public interface ICommonService
	{
		IList<T> GetRelatedEntities<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId);
		T AddEntityRelation<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, T targetObject);
		T SaveEntityRelation<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, T targetObject);
		T GetTargetEntity<T>(EntityTypeEnum target, Guid targetId);
		IList<T> GetAllTargets<T>(EntityTypeEnum target);
		void DeleteEntityRelation(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, Guid targetId);

		IList<Country> GetCountries();
		T AddToList<T>(EntityTypeEnum sourceTypeId, EntityTypeEnum comment, Guid sourceId, T target);
		IList<T> GetRelatedEntityList<T>(EntityTypeEnum sourceTypeId, EntityTypeEnum targetTypeId, Guid sourceId);
	}
}
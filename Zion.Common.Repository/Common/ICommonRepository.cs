using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Repository.Common
{
	public interface ICommonRepository
	{
		IList<T> GetEntityRelations<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId);
		T AddEntityRelation<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, T targetObject);
		T GetTargetEntity<T>(EntityTypeEnum target, Guid targetId);
		IList<T> GetAllTargets<T>(EntityTypeEnum target);
		void DeleteEntityRelation(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, Guid targetId);
		IList<Country> GetCountries();
		T SaveEntityRelation<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, T targetObject);
		void SaveTargetList<T>(EntityTypeEnum sourceTypeId, EntityTypeEnum targetTypeId, Guid sourceId, T list);
		IList<T> GetEntityRelationList<T>(object source, object target, Guid sourceId);
	}
}
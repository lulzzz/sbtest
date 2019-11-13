using System;
using System.Collections.Generic;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.OnlinePayroll.Models;

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
		List<News> GetNewsListforUser(int? audienceScope, Guid? audienceId);
		void SaveNewsfeedItem(News news);
		List<News> GetUserNewsfeed(Guid host, Guid company, string userId);


		List<InsuranceGroupDto> GetInsuranceGroups();
		InsuranceGroupDto SaveInsuranceGroup(InsuranceGroupDto insuranceGroup);
		void UpdateDBStats();
		void AddDocument(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, DocumentDto targetObject);
		Document GetDocument(Guid documentId);
		void DeleteDocument(Guid entityId, Guid documentId);
		IList<Document> GetDocuments(EntityTypeEnum entityType, Guid entityId);
		void AddEmployeeDocument(Guid? companyId, Guid entityId, DocumentDto document);
		void ExecuteQuery<T>(string sql, object param);
	}
}
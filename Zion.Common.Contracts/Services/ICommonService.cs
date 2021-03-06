﻿using System;
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
		IList<Country> SaveCountries(Country countries);
		T AddToList<T>(EntityTypeEnum sourceTypeId, EntityTypeEnum comment, Guid sourceId, T target);
		IList<T> GetRelatedEntityList<T>(EntityTypeEnum sourceTypeId, EntityTypeEnum targetTypeId, Guid sourceId);
		T FirstRelatedEntity<T>(EntityTypeEnum sourceTypeId, EntityTypeEnum targetTypeId, Guid sourceId);

		List<News> GetNewsforUser(int? audienceScope, Guid? audienceId);
		void SaveNewsItem(News news);

		List<InsuranceGroupDto> GetInsuranceGroups();
		InsuranceGroupDto SaveInsuranceGroup(InsuranceGroupDto insuranceGroup);
		List<News> GetUserNewsfeed(Guid host, Guid company, string id, string userId);
		Document AddDocument(EntityTypeEnum entityTypeId, EntityTypeEnum document, Guid entityId,
            DocumentDto documentDto);
		Document GetDocument(Guid documentId);
		void DeleteDocument(Guid entityId, Guid documentId);
		IList<Document> GetDocuments(EntityTypeEnum entityType, Guid entityId);
		void AddEmployeeDocument(Guid? companyId, Guid entityId, DocumentDto document);
		void ExecuteQuery<T>(string sql, object param);
        void DeleteEmployeeDocument(Guid employeeId, Guid documentId);
        
    }
}
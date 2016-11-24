using System;
using System.Collections.Generic;
using System.Linq;
using AutoMapper;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Common;
using HrMaxx.Infrastructure.Attributes;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Helpers;
using HrMaxx.Infrastructure.Services;
using HrMaxx.OnlinePayroll.Models;
using Magnum;

namespace HrMaxx.Common.Services.Common
{
	public class CommonService : BaseService, ICommonService
	{
		private readonly ICommonRepository _commonRepository;
		public IBus Bus { get; set; }
		
		public CommonService(ICommonRepository commonRepository)
		{
			_commonRepository = commonRepository;
			
		}
		
		public IList<T> GetRelatedEntities<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId)
		{
			try
			{
				return _commonRepository.GetEntityRelations<T>(source, target, sourceId);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, string.Format(" all related entityes {0}, {1}, {2}", source, target, sourceId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}

		}

		public T AddEntityRelation<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, T targetObject)
		{
			try
			{
				return _commonRepository.AddEntityRelation<T>(source, target, sourceId, targetObject);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToSaveX, string.Format(" add related entityes {0}, {1}, {2}", source, target, sourceId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public T SaveEntityRelation<T>(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, T targetObject)
		{
			try
			{
				if ((targetObject as BaseEntityDto).Id == Guid.Empty)
					(targetObject as BaseEntityDto).Id = CombGuid.Generate();
				
				return _commonRepository.SaveEntityRelation<T>(source, target, sourceId, targetObject);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToSaveX, string.Format(" save related entityes {0}, {1}, {2}", source, target, sourceId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		public T GetTargetEntity<T>(EntityTypeEnum target, Guid targetId)
		{
			try
			{
				return _commonRepository.GetTargetEntity<T>(target, targetId);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, string.Format(" target entity {0}, {1}", target, targetId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public IList<T> GetAllTargets<T>(EntityTypeEnum target)
		{
			try
			{
				return _commonRepository.GetAllTargets<T>(target);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, string.Format(" all target entities {0}", target));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void DeleteEntityRelation(EntityTypeEnum source, EntityTypeEnum target, Guid sourceId, Guid targetId)
		{
			try
			{
				_commonRepository.DeleteEntityRelation(source, target, sourceId, targetId);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToSaveX, string.Format(" delete relation {0}, {1}, {2},{3}", source, target, sourceId, targetId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public IList<Country> GetCountries()
		{
			try
			{
				return _commonRepository.GetCountries();
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, " get country list");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public T AddToList<T>(EntityTypeEnum sourceTypeId, EntityTypeEnum targetTypeId, Guid sourceId, T target)
		{
			try
			{
				var list = _commonRepository.GetEntityRelationList<T>(sourceTypeId, targetTypeId, sourceId);
				list.Add(target);
				_commonRepository.SaveTargetList<IList<T>>(sourceTypeId, targetTypeId, sourceId, list);
				return target;
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToSaveX, " add item to list");
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		public IList<T> GetRelatedEntityList<T>(EntityTypeEnum sourceTypeId, EntityTypeEnum targetTypeId, Guid sourceId)
		{
			try
			{
				return _commonRepository.GetEntityRelationList<T>(sourceTypeId, targetTypeId, sourceId);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, string.Format(" all related entity as list for {0}, {1}, {2}", sourceTypeId, targetTypeId, sourceId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public T FirstRelatedEntity<T>(EntityTypeEnum sourceTypeId, EntityTypeEnum targetTypeId, Guid sourceId)
		{
			try
			{
				var entity = GetRelatedEntities<T>(sourceTypeId, targetTypeId, sourceId).FirstOrDefault();
				if (entity == null)
				{
					var temp = System.Activator.CreateInstance<T>();
					return temp;
				}
				return entity;

			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, string.Format(" first related entity for {0}, {1}, {2}", sourceTypeId, targetTypeId, sourceId));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
			
		}

		public List<News> GetNewsforUser(int? audienceScope, Guid? audienceId)
		{
			try
			{
				if (audienceScope.HasValue && audienceScope.Value == (int) RoleTypeEnum.Master)
					audienceScope = null;
				return _commonRepository.GetNewsListforUser(audienceScope, audienceId);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, string.Format(" newsfeed"));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public void SaveNewsItem(News news)
		{
			try
			{
				_commonRepository.SaveNewsfeedItem(news);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToSaveX, string.Format(" newsfeed item"));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<InsuranceGroupDto> GetInsuranceGroups()
		{
			try
			{
				return _commonRepository.GetInsuranceGroups();
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToRetrieveX, string.Format(" insurance groups"));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public InsuranceGroupDto SaveInsuranceGroup(InsuranceGroupDto insuranceGroup)
		{
			try
			{
				return _commonRepository.SaveInsuranceGroup(insuranceGroup);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToSaveX, string.Format(" insurance groups"));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}

		public List<News> GetUserNewsfeed(Guid host, Guid company, string userId, string role)
		{
			try
			{
				if (!string.IsNullOrWhiteSpace(role) &&
				    ((RoleTypeEnum.Master == HrMaaxxSecurity.GetEnumFromDbName<RoleTypeEnum>(role)) ||
				     (RoleTypeEnum.CorpStaff == HrMaaxxSecurity.GetEnumFromDbName<RoleTypeEnum>(role))))
					return _commonRepository.GetNewsListforUser(null, null).Where(n=>n.IsActive).ToList();
				
				return _commonRepository.GetUserNewsfeed(host, company, userId);
			}
			catch (Exception e)
			{
				var message = string.Format(CommonStringResources.ERROR_FailedToSaveX, string.Format(" newsfeed list for users"));
				Log.Error(message, e);
				throw new HrMaxxApplicationException(message, e);
			}
		}
	}
}
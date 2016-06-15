using System;
using System.Collections.Generic;
using AutoMapper;
using HrMaxx.Bus.Contracts;
using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Repository.Common;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
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
				if (target == EntityTypeEnum.Contact)
				{
					Bus.Publish<ContactEvent>(new ContactEvent
					{
						Contact = (targetObject as Contact),
						SourceId = sourceId,
						UserId = (targetObject as Contact).UserId,
						Source = (targetObject as Contact).UserName,
						SourceTypeId = source,
						TimeStamp = DateTime.Now
						
					});
				}
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
	}
}
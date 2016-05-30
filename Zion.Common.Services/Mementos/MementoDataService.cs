using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Mementos;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Tracing;
using HrMaxx.Infrastructure.Transactions;

namespace HrMaxx.Common.Services.Mementos
{
	public class MementoDataService : BaseService, IMementoDataService
	{
		private readonly IMementoDataRepository _repository;

		public MementoDataService(IMementoDataRepository repository)
		{
			_repository = repository;
		}

		public void AddMementoData<T>(Memento<T> memento)
		{
			var dto = new MementoPersistenceDto
			{
				OriginatorType = memento.OriginatorTypeName,
				Memento = memento.State,
				MementoId = memento.Id
			};

			try
			{
				Guid messageCorrelationId = HrMaxxTrace.StartPerfTrace(PerfTraceType.WriteRepositoryCall, GetType(), "{0} ({1})",
					"AddMementoData", dto.OriginatorType);

				using (TransactionScope txn = TransactionScopeHelper.Transaction())
				{
					_repository.SaveMemento(dto);

					txn.Complete();
				}

				HrMaxxTrace.EndPerfTrace(messageCorrelationId);
			}
			catch (Exception e)
			{
				Log.Error("MementoDataService.AddMementoData failed", e);
				throw new HrMaxxApplicationException(CommonStringResources.ERROR_CouldNotSaveMemento);
			}
		}

		public Memento<T> GetMostRecentMementoData<T>(Guid mementoId)
		{
			try
			{
				Guid messageCorrelationId = HrMaxxTrace.StartPerfTrace(PerfTraceType.ReadRepositoryCall, GetType(), "{0}<{1}>({2})",
					"GetMostRecentMementoData", typeof (T).FullName, "GetMostRecentMementoData", mementoId.ToString());
				MementoPersistenceDto memento = _repository.GetMostRecentMemento<T>(mementoId);
				HrMaxxTrace.EndPerfTrace(messageCorrelationId);

				return Memento<T>.Create(mementoId, memento.Memento);
			}
			catch (Exception e)
			{
				Log.Error("MementoDataService.GetMostRecentMemento failed", e);
				throw new HrMaxxApplicationException(CommonStringResources.ERROR_CouldNotRetrieveStagingData);
			}
		}

		public List<Memento<T>> GetMementoData<T>(Guid mementoId)
		{
			try
			{
				Guid messageCorrelationId = HrMaxxTrace.StartPerfTrace(PerfTraceType.ReadRepositoryCall, GetType(), "{0}<{1}>({2})",
					"GetMementoData", typeof (T).FullName, "GetMementoData", mementoId.ToString());
				List<MementoPersistenceDto> memento = _repository.GetMementoData<T>(mementoId).ToList();
				HrMaxxTrace.EndPerfTrace(messageCorrelationId);

				if ((memento == null) || memento.Count == 0)
					return null;

				var mementos = new List<Memento<T>>();
				memento.ForEach(m => mementos.Add(Memento<T>.Create(mementoId, m.Version, m.DateCreated, m.Memento)));
				return mementos;
			}
			catch (Exception e)
			{
				Log.Error("MementoDataService.GetMementoData failed", e);
				throw new HrMaxxApplicationException(CommonStringResources.ERROR_CouldNotRetrieveStagingData);
			}
		}

		public List<Memento<T>> GetMementoData<T>()
		{
			try
			{
				Guid messageCorrelationId = HrMaxxTrace.StartPerfTrace(PerfTraceType.ReadRepositoryCall, GetType(), "{0}<{1}>",
					"GetMementoData", typeof (T).FullName, "GetMementoData");
				List<MementoPersistenceDto> memento = _repository.GetMementoData<T>().ToList();
				HrMaxxTrace.EndPerfTrace(messageCorrelationId);

				if ((memento == null) || memento.Count == 0)
					return null;

				var mementos = new List<Memento<T>>();
				memento.ForEach(m => mementos.Add(Memento<T>.Create(m.MementoId, m.Version, m.DateCreated, m.Memento)));
				return mementos;
			}
			catch (Exception e)
			{
				Log.Error("MementoDataService.GetMementoData failed", e);
				throw new HrMaxxApplicationException(CommonStringResources.ERROR_CouldNotRetrieveStagingData);
			}
		}

		public void DeleteMementoData<T>(Guid mementoId)
		{
			try
			{
				Guid messageCorrelationId = HrMaxxTrace.StartPerfTrace(PerfTraceType.ReadRepositoryCall, GetType(), "{0} ({1})",
					"Delete Mementos", mementoId.ToString());

				using (TransactionScope txn = TransactionScopeHelper.Transaction())
				{
					_repository.DeleteMementoData<T>(mementoId);

					txn.Complete();
				}

				HrMaxxTrace.EndPerfTrace(messageCorrelationId);
			}
			catch (Exception e)
			{
				Log.Error("MementoDataService.DeleteMementos failed", e);
				throw new HrMaxxApplicationException(CommonStringResources.ERROR_CouldNotDeleteMementos);
			}
		}
	}
}
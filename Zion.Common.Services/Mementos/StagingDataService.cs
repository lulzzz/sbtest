using System;
using System.Collections.Generic;
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
	public class StagingDataService : BaseService, IStagingDataService
	{
		private readonly IStagingDataRepository _repository;

		public StagingDataService(IStagingDataRepository repository)
		{
			_repository = repository;
		}

		public void AddStagingData<T>(Memento<T> memento)
		{
			var dto = new StagingDataDto
			{
				OriginatorType = memento.OriginatorTypeName,
				Memento = memento.State,
				MementoId = memento.MementoId
			};

			try
			{
				Guid messageCorrelationId = HrMaxxTrace.StartPerfTrace(PerfTraceType.WriteRepositoryCall, GetType(), "{0} ({1})",
					"AddStagingData", dto.OriginatorType);

				using (TransactionScope txn = TransactionScopeHelper.Transaction())
				{
					_repository.SaveMemento(dto);

					txn.Complete();
				}

				HrMaxxTrace.EndPerfTrace(messageCorrelationId);
			}
			catch (Exception e)
			{
				Log.Error("StagingDataService.AddStagingData failed", e);
				throw new HrMaxxApplicationException(CommonStringResources.ERROR_CouldNotSaveMemento);
			}
		}


		public Memento<T> GetMostRecentStagingData<T>(Guid mementoId)
		{
			try
			{
				Guid messageCorrelationId = HrMaxxTrace.StartPerfTrace(PerfTraceType.ReadRepositoryCall, GetType(), "{0}<{1}>({2})",
					"GetMostRecentStagingData", typeof (T).FullName, "GetMostRecentStagingData", mementoId.ToString());
				StagingDataDto memento = _repository.GetMostRecentMemento<T>(mementoId);
				HrMaxxTrace.EndPerfTrace(messageCorrelationId);

				return Memento<T>.Create(mementoId, memento.Memento);
			}
			catch (Exception e)
			{
				Log.Error("StagingDataService.GetMostRecentMemento failed", e);
				throw new HrMaxxApplicationException(CommonStringResources.ERROR_CouldNotRetrieveStagingData);
			}
		}

		public List<Memento<T>> GetStagingData<T>(Guid mementoId)
		{
			try
			{
				Guid messageCorrelationId = HrMaxxTrace.StartPerfTrace(PerfTraceType.ReadRepositoryCall, GetType(), "{0}<{1}>({2})",
					"GetStagingData", typeof (T).FullName, "GetStagingData", mementoId.ToString());
				List<StagingDataDto> memento = _repository.GetStagingData<T>(mementoId);
				HrMaxxTrace.EndPerfTrace(messageCorrelationId);

				if ((memento == null) || memento.Count == 0)
					return null;

				var mementos = new List<Memento<T>>();
				memento.ForEach(m => mementos.Add(Memento<T>.Create(mementoId, m.Memento)));
				return mementos;
			}
			catch (Exception e)
			{
				Log.Error("StagingDataService.GetStagingData failed", e);
				throw new HrMaxxApplicationException(CommonStringResources.ERROR_CouldNotRetrieveStagingData);
			}
		}

		public void DeleteStagingData<T>(Guid mementoId)
		{
			try
			{
				Guid messageCorrelationId = HrMaxxTrace.StartPerfTrace(PerfTraceType.ReadRepositoryCall, GetType(), "{0} ({1})",
					"Delete Mementos", mementoId.ToString());

				using (TransactionScope txn = TransactionScopeHelper.Transaction())
				{
					_repository.DeleteStagingData<T>(mementoId);

					txn.Complete();
				}

				HrMaxxTrace.EndPerfTrace(messageCorrelationId);
			}
			catch (Exception e)
			{
				Log.Error("StagingDataService.DeleteMementos failed", e);
				throw new HrMaxxApplicationException(CommonStringResources.ERROR_CouldNotDeleteMementos);
			}
		}
	}
}
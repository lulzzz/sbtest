using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using HrMaxx.Common.Contracts.Resources;
using HrMaxx.Common.Contracts.Services;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;
using HrMaxx.Common.Repository.Mementos;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Services;
using HrMaxx.Infrastructure.Tracing;
using HrMaxx.Infrastructure.Transactions;
using HrMaxx.OnlinePayroll.Models;

namespace HrMaxx.Common.Services.Mementos
{
	public class MementoDataService : BaseService, IMementoDataService
	{
		private readonly IMementoDataRepository _repository;

		public MementoDataService(IMementoDataRepository repository)
		{
			_repository = repository;
		}

		public void AddMementoData<T>(Memento<T> memento, bool isSubVersion = false)
		{
			var dto = new MementoPersistenceDto
			{
				OriginatorType = memento.OriginatorTypeName,
				Memento = memento.State,
				MementoId = memento.MementoId,
				SourceTypeId = (int)memento.SourceTypeId,
				CreatedBy = memento.CreatedBy,
				Comments = memento.Comments,
				UserId = memento.UserId
			};

			try
			{
				
					_repository.SaveMemento(dto, isSubVersion);

				
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
				
				MementoPersistenceDto memento = _repository.GetMostRecentMemento<T>(mementoId);
				

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
				
				List<MementoPersistenceDto> memento = _repository.GetMementoData<T>(mementoId).ToList();
				

				if ((memento == null) || memento.Count == 0)
					return null;

				var mementos = new List<Memento<T>>();
				memento.ForEach(m =>
				{
					var mem = Memento<T>.Create(mementoId, m.Version, m.DateCreated, m.Memento, m.CreatedBy,
						(EntityTypeEnum) m.SourceTypeId);
					mem.Object = mem.Deserialize();
					mementos.Add(mem);
				});
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
				
				List<MementoPersistenceDto> memento = _repository.GetMementoData<T>().ToList();
				

				if ((memento == null) || memento.Count == 0)
					return null;

				var mementos = new List<Memento<T>>();
				memento.ForEach(m => mementos.Add(Memento<T>.Create(m.MementoId, m.Version, m.DateCreated, m.Memento, m.CreatedBy, (EntityTypeEnum)m.SourceTypeId)));
				return mementos;
			}
			catch (Exception e)
			{
				Log.Error("MementoDataService.GetMementoData failed", e);
				throw new HrMaxxApplicationException(CommonStringResources.ERROR_CouldNotRetrieveStagingData);
			}
		}

		public List<object> GetMementos(EntityTypeEnum sourceTypeId, Guid sourceId)
		{
			try
			{
				var mems = new List<MementoPersistenceDto>();
				var result = new List<object>();
				if(sourceTypeId==EntityTypeEnum.Company)
				{
					mems = _repository.GetMementos<Company>((int)sourceTypeId, sourceId).ToList();
					var ms = new List<Memento<Company>>();
					mems.ForEach(m => ms.Add(Memento<Company>.Create(m.MementoId, m.Version, m.DateCreated, m.Memento, m.CreatedBy, (EntityTypeEnum)m.SourceTypeId, m.Comments, m.UserId)));
					ms.ForEach(m => result.Add(new { Version = m.Version, DateCreated = m.DateCreated, Object = m.Object, CreatedBy = m.CreatedBy, Comments = m.Comments }));
				}
				else if (sourceTypeId == EntityTypeEnum.Employee)
				{
					mems = _repository.GetMementos<Employee>((int)sourceTypeId, sourceId).ToList();
					var ms = new List<Memento<Employee>>();
					mems.ForEach(m => ms.Add(Memento<Employee>.Create(m.MementoId, m.Version, m.DateCreated, m.Memento, m.CreatedBy, (EntityTypeEnum)m.SourceTypeId, m.Comments, m.UserId)));
					ms.ForEach(m => result.Add(new { Version = m.Version, DateCreated = m.DateCreated, Object = m.Object, CreatedBy = m.CreatedBy, Comments = m.Comments }));
				}
				else if (sourceTypeId == EntityTypeEnum.Invoice)
				{
					mems = _repository.GetMementos<PayrollInvoice>((int)sourceTypeId, sourceId).ToList();
					var ms = new List<Memento<PayrollInvoice>>();
					mems.ForEach(m => ms.Add(Memento<PayrollInvoice>.Create(m.MementoId, m.Version, m.DateCreated, m.Memento, m.CreatedBy, (EntityTypeEnum)m.SourceTypeId, m.Comments, m.UserId)));
					ms.ForEach(m => result.Add(new { Version = m.Version, DateCreated = m.DateCreated, Object = m.Object, CreatedBy = m.CreatedBy, Comments = m.Comments }));
				}
				else if (sourceTypeId == EntityTypeEnum.RegularCheck || sourceTypeId == EntityTypeEnum.Deposit || sourceTypeId == EntityTypeEnum.InvoiceDeposit || sourceTypeId == EntityTypeEnum.Adjustment || sourceTypeId == EntityTypeEnum.TaxPayment)
				{
					mems = _repository.GetMementos<Journal>((int)sourceTypeId, sourceId).ToList();
					var ms = new List<Memento<Journal>>();
					mems.ForEach(m => ms.Add(Memento<Journal>.Create(m.MementoId, m.Version, m.DateCreated, m.Memento, m.CreatedBy, (EntityTypeEnum)m.SourceTypeId, m.Comments, m.UserId)));
					ms.ForEach(m => result.Add(new { Version = m.Version, DateCreated = m.DateCreated, Object = m.Object, CreatedBy = m.CreatedBy, Comments = m.Comments }));
				}
				else if (sourceTypeId == EntityTypeEnum.PayCheck)
				{
					mems = _repository.GetMementos<PayCheck>((int)sourceTypeId, sourceId).ToList();
					var ms = new List<Memento<PayCheck>>();
					mems.ForEach(m => ms.Add(Memento<PayCheck>.Create(m.MementoId, m.Version, m.DateCreated, m.Memento, m.CreatedBy, (EntityTypeEnum)m.SourceTypeId, m.Comments, m.UserId)));
					ms.ForEach(m => result.Add(new { Version = m.Version, DateCreated = m.DateCreated, Object = m.Object, CreatedBy = m.CreatedBy, Comments = m.Comments }));
				}

				return result;
			}
			catch (Exception)
			{
				
				throw;
			}
		}

		public void DeleteMementoData<T>(Guid mementoId)
		{
			try
			{
				
					_repository.DeleteMementoData<T>(mementoId);

			}
			catch (Exception e)
			{
				Log.Error("MementoDataService.DeleteMementos failed", e);
				throw new HrMaxxApplicationException(CommonStringResources.ERROR_CouldNotDeleteMementos);
			}
		}
	}
}
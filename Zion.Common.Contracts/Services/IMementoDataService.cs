using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Enum;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IMementoDataService
	{
		void AddMementoData<T>(Memento<T> memento, bool isSubVersion = false);
		List<Memento<T>> GetMementoData<T>(Guid mementoId);
		void DeleteMementoData<T>(Guid mementoId);
		Memento<T> GetMostRecentMementoData<T>(Guid mementoId);
		List<Memento<T>> GetMementoData<T>();
		List<object> GetMementos(EntityTypeEnum sourceTypeId, Guid sourceId);
		
	}
}
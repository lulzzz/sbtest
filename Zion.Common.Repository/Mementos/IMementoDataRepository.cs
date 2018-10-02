using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.Common.Repository.Mementos
{
	public interface IMementoDataRepository
	{
		MementoPersistenceDto SaveMemento(MementoPersistenceDto memento, bool isSubVersion);
		IEnumerable<MementoPersistenceDto> GetMementoData(Guid mementoId);
		void DeleteMementoData<T>(Guid mementoId);
		MementoPersistenceDto GetMostRecentMemento<T>(Guid mementoId);
		IEnumerable<MementoPersistenceDto> GetMementoData<T>();
		IEnumerable<MementoPersistenceDto> GetMementos<T>(int sourceTypeId, Guid sourceId);
	}
}
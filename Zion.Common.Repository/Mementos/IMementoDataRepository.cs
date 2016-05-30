using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.Common.Repository.Mementos
{
	public interface IMementoDataRepository
	{
		void SaveMemento(MementoPersistenceDto memento);
		IEnumerable<MementoPersistenceDto> GetMementoData<T>(Guid mementoId);
		void DeleteMementoData<T>(Guid mementoId);
		MementoPersistenceDto GetMostRecentMemento<T>(Guid mementoId);
		IEnumerable<MementoPersistenceDto> GetMementoData<T>();
	}
}
using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.Common.Contracts.Services
{
	public interface IStagingDataService
	{
		void AddStagingData<T>(Memento<T> memento);
		List<Memento<T>> GetStagingData<T>(Guid mementoId);
		void DeleteStagingData<T>(Guid mementoId);
		Memento<T> GetMostRecentStagingData<T>(Guid mementoId);
	}
}
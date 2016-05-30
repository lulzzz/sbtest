using System;
using System.Collections.Generic;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.Common.Repository.Mementos
{
	public interface IStagingDataRepository
	{
		void SaveMemento(StagingDataDto memento);
		List<StagingDataDto> GetStagingData<T>(Guid mementoId);
		void DeleteStagingData<T>(Guid mementoId);
		StagingDataDto GetMostRecentMemento<T>(Guid mementoId);
	}
}
using System;

namespace HrMaxx.Common.Models.Mementos
{
	public interface IOriginator<T>
	{
		Guid MementoId { get; }
		void ApplyMemento(Memento<T> memento);
	}
}
using System;

namespace HrMaxx.Common.Models.Mementos
{
	public class MementoPersistenceDto
	{
		public Guid Id { get; set; }
		public Guid MementoId { get; set; }
		public string OriginatorType { get; set; }
		public string Memento { get; set; }
		public int Version { get; set; }
		public DateTime DateCreated { get; set; }
	}
}
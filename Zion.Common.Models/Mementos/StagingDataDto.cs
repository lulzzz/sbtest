using System;

namespace HrMaxx.Common.Models.Mementos
{
	public class StagingDataDto
	{
		public Guid Id { get; set; }
		public Guid MementoId { get; set; }
		public string OriginatorType { get; set; }
		public string Memento { get; set; }
		public DateTime DateCreated { get; set; }
	}
}
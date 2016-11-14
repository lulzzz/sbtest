using System;

namespace HrMaxx.Common.Models.Mementos
{
	public class MementoPersistenceDto
	{
		public int Id { get; set; }
		public Guid MementoId { get; set; }
		public string OriginatorType { get; set; }
		public int SourceTypeId { get; set; }
		public string Memento { get; set; }
		public decimal Version { get; set; }
		public DateTime DateCreated { get; set; }
		public string CreatedBy { get; set; }
	}
}
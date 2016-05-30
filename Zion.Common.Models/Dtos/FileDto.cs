using System;

namespace HrMaxx.Common.Models.Dtos
{
	public class FileDto
	{
		public Guid DocumentId { get; set; }
		public string Filename { get; set; }
		public string DocumentExtension { get; set; }
		public byte[] Data { get; set; }
	}
}
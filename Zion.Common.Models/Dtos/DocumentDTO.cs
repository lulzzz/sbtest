using System;

namespace HrMaxx.Common.Models.Dtos
{
	public class DocumentDto
	{
		public Guid DocumentID { get; set; }
		public string DocumentName { get; set; }
		public string DocumentExtension { get; set; }
		public string DocumentPath { get; set; }

		public string Filename
		{
			get { return DocumentName + "." + DocumentExtension; }
		}
	}
}
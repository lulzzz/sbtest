using System;
using System.Linq;

namespace HrMaxx.Common.Models.Dtos
{
	public class DocumentDto : BaseEntityDto
	{
		public string DocumentName { get; set; }
		public string DocumentExtension { get; set; }
		public string MimeType { get; set; }
		public string DocumentPath { get; set; }

		public string Filename
		{
			get { return DocumentName + "." + DocumentExtension; }
		}
		
		public bool IsImage
		{
			get { return (new string[] {"jpg", "jpeg", "png", "gif", "tif", "tiff", "bmp"}).Contains(DocumentExtension.ToLower()); }
		}
	}
}
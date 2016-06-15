using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HrMaxx.Common.Models
{
	public class EntityDocumentAttachment
	{
		public Guid EntityId { get; set; }
		public int EntityTypeId { get; set; }
		public string OriginalFileName { get; set; }
		public string SourceFileName { get; set; }
		public string FileExtension { get; set; }
		public string MimeType { get; set; }
	}
}

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Enum;

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
		public DocumentType DocumentType { get; set; }
		public string UserName { get; set; }
		public DateTime LastModified { get; set; }
	}
}

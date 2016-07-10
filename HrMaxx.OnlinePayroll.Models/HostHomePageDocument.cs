using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Dtos;
using HrMaxx.Common.Models.Mementos;

namespace HrMaxx.OnlinePayroll.Models
{
	public class HostHomePageDocument
	{
		public Guid StagingId { get; set; }
		public Guid HostId { get; set; }
		public bool ImageType { get; set; }
		public string OriginalFileName { get; set; }
		public string SourceFileName { get; set; }
		public string FileExtension { get; set; }
		public string MimeType { get; set; }
	}

	public class HostHomePageStagingDocument : IOriginator<HostHomePageStagingDocument>
	{
		public DocumentDto Document { get; set; }
		public Guid StagingId { get; set; }
		public Guid HostId { get; set; }
		public bool ImageType { get; set; }
		
		public void ApplyMemento(Memento<HostHomePageStagingDocument> memento)
		{
			var attachment = memento.Deserialize();

			Document = attachment.Document;
			StagingId = attachment.StagingId;
			HostId = attachment.HostId;
			ImageType = attachment.ImageType;
		}

		public Guid MementoId
		{
			get
			{
				return StagingId;
			}
		}
	}
}

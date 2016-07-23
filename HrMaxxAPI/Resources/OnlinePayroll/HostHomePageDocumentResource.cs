using System;
using System.IO;
using Newtonsoft.Json;

namespace HrMaxxAPI.Resources.OnlinePayroll
{
	public class HostHomePageDocumentResource
	{
		[JsonProperty("stagingId")]
		public Guid StagingId { get; set; }
		[JsonProperty("hostId")]
		public Guid HostId { get; set; }
		[JsonProperty("type")]
		public bool ImageType { get; set; }
		[JsonProperty("mimeType")]
		public string MimeType { get; set; }
		
		[JsonIgnore]
		public string FileName { get; set; }
		[JsonIgnore]
		public FileInfo file { get; set; }
	}
}
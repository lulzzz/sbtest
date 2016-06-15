using System;
using System.IO;
using HrMaxx.Common.Models.Enum;
using Newtonsoft.Json;

namespace HrMaxxAPI.Resources.Common
{
	public class EntityDocumentResource
	{
		[JsonProperty("entityId")]
		public Guid EntityId { get; set; }
		[JsonProperty("entityTypeId")]
		public EntityTypeEnum EntityTypeId { get; set; }
		[JsonProperty("mimeType")]
		public string MimeType { get; set; }
		
		[JsonIgnore]
		public string FileName { get; set; }
		[JsonIgnore]
		public FileInfo file { get; set; }
	}
}
using System.IO;
using Newtonsoft.Json;

namespace HrMaxx.API.Resources.Common
{
	public abstract class FileAttachmentResource : BaseRestResource
	{
		[JsonIgnore]
		public string FileName { get; set; }

		[JsonIgnore]
		public FileInfo file { get; set; }
	}
}
using System.IO;
using Newtonsoft.Json;

namespace HrMaxxAPI.Resources.Common
{
	public abstract class FileAttachmentResource : BaseRestResource
	{
		[JsonIgnore]
		public string FileName { get; set; }

		[JsonIgnore]
		public FileInfo file { get; set; }
	}
}
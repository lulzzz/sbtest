using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HrMaxx.Common.Models.Enum;

namespace HrMaxx.Common.Models
{
	public class PDFModel
	{
		public string Template { get; set; }
		public EntityTypeEnum TargetType { get; set; }
		public object TargetId { get; set; }
		public List<KeyValuePair<string, string>> NormalFontFields { get; set; }
		public List<KeyValuePair<string, string>> BoldFontFields { get; set; }
		public Guid DocumentId { get; set; }
		public string Name { get; set; }
		public PDFSignature Signature { get; set; }
	}

	public class PDFSignature
	{
		public string Path { get; set; }
		public float X { get; set; }
		public float Y { get; set; }
		public float ScaleX { get; set; }
		public float ScaleY { get; set; }
	}

	
}

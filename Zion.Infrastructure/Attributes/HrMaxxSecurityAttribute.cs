using System;

namespace HrMaxx.Infrastructure.Attributes
{
	[AttributeUsage(AttributeTargets.Field)]
	public class HrMaxxSecurityAttribute : Attribute
	{
		public int DbId { get; set; }
		public string DbName { get; set; }
		public string HrMaxxId { get; set; }
	}
}
using System;

namespace HrMaxx.Infrastructure.Attributes
{
	[AttributeUsage(AttributeTargets.Field)]
	public class HrMaxxSecurityAttribute : Attribute
	{
		public int UAMId { get; set; }
		public string UAMName { get; set; }
		public string HrMaxxId { get; set; }
	}
}
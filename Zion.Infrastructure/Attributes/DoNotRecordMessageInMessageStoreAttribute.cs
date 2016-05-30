using System;

namespace HrMaxx.Infrastructure.Attributes
{
	[AttributeUsage(AttributeTargets.Class | AttributeTargets.Interface, AllowMultiple = false)]
	public class DoNotRecordMessageInMessageStoreAttribute : Attribute
	{
		public string Reason { get; set; }
	}
}
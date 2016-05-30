using System;

namespace HrMaxx.Infrastructure.Attributes
{
	/// <summary>
	///   Identifies a message as being targetted for the memory bus
	/// </summary>
	[AttributeUsage(AttributeTargets.Class | AttributeTargets.Interface, AllowMultiple = false, Inherited = true)]
	public class MemoryBusMessageAttribute : Attribute
	{
	}
}
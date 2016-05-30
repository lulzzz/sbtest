using System;

namespace HrMaxx.Infrastructure.Attributes
{
	/// <summary>
	///   Identifies a message as being targetted for the service bus
	/// </summary>
	[AttributeUsage(AttributeTargets.Interface | AttributeTargets.Class, AllowMultiple = false, Inherited = true)]
	public class ServiceBusMessageAttribute : Attribute
	{
	}
}
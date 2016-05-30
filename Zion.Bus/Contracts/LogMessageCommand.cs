using System;
using HrMaxx.Infrastructure.Attributes;
using HrMaxx.Infrastructure.Enums;

namespace HrMaxx.Bus.Contracts
{
	[DoNotRecordMessageInMessageStore(Reason = "Log messages are logged, we dont need them in the message store.")]
	[ServiceBusMessage]
	public class LogMessageCommand : Command
	{
		public LogSeverityEnum Severity { get; set; }
		public string SerializedRelatedBusMessageType { get; set; }
		public string SerializedRelatedBusMessage { get; set; }
		public string Message { get; set; }
		public Exception Exception { get; set; }
	}
}
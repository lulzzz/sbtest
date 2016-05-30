using System;
using HrMaxx.Infrastructure.Enums;
using MassTransit;

namespace HrMaxx.Bus.Contracts
{
	public interface IBus
	{
		TResponse Request<TRequest, TResponse>(TRequest message)
			where TRequest : BaseServiceBusRequest
			where TResponse : BaseServiceBusResponse;

		TResponse Request<TRequest, TResponse>(TRequest message,
			int? messageTimeoutInSeconds = null,
			Action<Fault<TRequest>> faultHandler = null,
			Action<TRequest> timeoutHandler = null)
			where TRequest : BaseServiceBusRequest
			where TResponse : BaseServiceBusResponse;

		void Send<TMessage>(TMessage command) where TMessage : Command;

		void Publish<TMessage>(TMessage @event) where TMessage : Event;

		void LogMessage(string logMessage, LogSeverityEnum severity);

		void LogBusMessage(object busMessage, string logMessage = null, LogSeverityEnum severity = LogSeverityEnum.Debug);

		void LogException(string message, Exception exception, object relatedMessage = null);
	}
}
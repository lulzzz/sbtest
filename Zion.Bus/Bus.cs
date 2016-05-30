using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading;
using HrMaxx.Bus.Contracts;
using HrMaxx.Bus.Exceptions;
using HrMaxx.Bus.Infrastructure;
using HrMaxx.Infrastructure.Attributes;
using HrMaxx.Infrastructure.Enums;
using HrMaxx.Infrastructure.Exceptions;
using HrMaxx.Infrastructure.Tracing;
using MassTransit;

namespace HrMaxx.Bus
{
	public class Bus : IBus
	{
		private readonly int _requesTimeout;

		public Bus()
		{
			string timeout = ConfigurationManager.AppSettings["DefaultServiceBusRequesTimeoutInSeconds"];
			_requesTimeout = timeout == null ? Constants.THIRTY_SECONDS : int.Parse(timeout);
		}

		public IServiceBus ServiceBus { get; set; }
		public IInMemoryBus MemoryBus { get; set; }

		public TResponse Request<TRequest, TResponse>(TRequest message)
			where TRequest : BaseServiceBusRequest
			where TResponse : BaseServiceBusResponse
		{
			return Request<TRequest, TResponse>(message, Constants.THIRTY_SECONDS, InternalFaultHandler, InternalTimeoutHandler);
		}

		public TResponse Request<TRequest, TResponse>(TRequest message,
			int? messageTimeoutInSeconds = null,
			Action<Fault<TRequest>> faultHandler = null,
			Action<TRequest> timeoutHandler = null)
			where TRequest : BaseServiceBusRequest
			where TResponse : BaseServiceBusResponse
		{
			message.Validate();

			TResponse response = null;

			//CheckSecurity(message);
			RecordMessage(message);

			ServiceBus.PublishRequest(message,
				configurator =>
				{
					configurator.Handle<TResponse>(result => { response = result; });

					configurator.HandleFault(fault =>
					{
						if (faultHandler == null) InternalFaultHandler(fault);
						else faultHandler(fault);
					});

					configurator.HandleTimeout(
						TimeSpan.FromSeconds(messageTimeoutInSeconds ?? _requesTimeout), request =>
						{
							if (timeoutHandler == null)
							{
								InternalTimeoutHandler
									(request);
							}
							else timeoutHandler(request);
						});
				});


			if (response != null)
			{
				RecordMessage(response);

				if (response.HasFaults())
				{
					throw new HrMaxxApplicationException(string.Empty, response.Faults);
				}
			}

			return response;
		}

		public void Send<TMessage>(TMessage command) where TMessage : Command
		{
			command.Validate();

			CheckForBusTarget(command);
			//CheckSecurity(command);
			RecordMessage(command);
			SetMessageIdentity(command);

			bool isMemoryBusMessage = IsMemoryBusMessage(command);
			bool isServiceBusMessage = IsServiceBusMessage(command);

			Guid messageCorrelationId = HrMaxxTrace.StartPerfTrace(PerfTraceType.SendBusMessage, GetType(), "{0} ({1})",
				command.GetType().FullName,
				isMemoryBusMessage ? "Memory Bus" : "Service Bus");

			if (isMemoryBusMessage) MemoryBus.Send(command);
			if (isServiceBusMessage) ServiceBus.Publish(command);

			HrMaxxTrace.EndPerfTrace(messageCorrelationId);
		}

		public void Publish<TMessage>(TMessage @event) where TMessage : Event
		{
			CheckForBusTarget(@event);
			RecordMessage(@event);

			bool isMemoryBusMessage = IsMemoryBusMessage(@event);
			bool isServiceBusMessage = IsServiceBusMessage(@event);

			Guid messageCorrelationId = HrMaxxTrace.StartPerfTrace(PerfTraceType.SendBusMessage, GetType(), "{0} ({1})",
				@event.GetType().FullName,
				isMemoryBusMessage ? "Memory Bus" : "Service Bus");

			if (isMemoryBusMessage) MemoryBus.Publish(@event);
			if (isServiceBusMessage) ServiceBus.Publish(@event);

			HrMaxxTrace.EndPerfTrace(messageCorrelationId);
		}

		public void LogMessage(string logMessage, LogSeverityEnum severity)
		{
			Send(GetLogMessageCommand(logMessage, null, severity));
		}

		public void LogBusMessage(object busMessage, string message = null, LogSeverityEnum severity = LogSeverityEnum.Debug)
		{
			Send(GetLogMessageCommand(message, busMessage, severity));
		}

		public void LogException(string message, Exception exception, object relatedBusMessage = null)
		{
			Send(GetLogMessageCommand(message, relatedBusMessage, LogSeverityEnum.Error, exception));
		}

		private void SetMessageIdentity(Command command)
		{
			var auditableCommand = command as IAuditable;
			if (auditableCommand == null) return;

			auditableCommand.MessageDate = DateTime.Now;

			if (Thread.CurrentPrincipal != null)
				auditableCommand.IdentityOfProtagonist = Thread.CurrentPrincipal.Identity.Name;
		}

		private void CheckForBusTarget(IMessage message)
		{
			List<object> attributes = message.GetType().GetCustomAttributes(true).ToList();
			bool foundBusTarget =
				attributes.Any(
					a => a.GetType() == typeof (ServiceBusMessageAttribute) || a.GetType() == typeof (MemoryBusMessageAttribute));

			if (!foundBusTarget) throw new NoBusTargettedException(message);
		}

		private void RecordMessage(object message)
		{
			if (IsToBeExcluded(message)) return;

			var decoratedMessage = new SaveDomainMessageCommand(message);
			ServiceBus.Publish(decoratedMessage);
		}

		private bool IsToBeExcluded(object message)
		{
			List<object> attributes = message.GetType().GetCustomAttributes(false).ToList();
			attributes.ForEach(a =>
			{
				var doNotRecordMessageInMessageStoreAttribute = a as DoNotRecordMessageInMessageStoreAttribute;
				if (doNotRecordMessageInMessageStoreAttribute != null)
				{
					HrMaxxTrace.TraceInformation("Message not recorded to message store: {0}. Reason: {1}",
						message.GetType(), doNotRecordMessageInMessageStoreAttribute.Reason);
				}
			});

			return attributes.Any(a => a is DoNotRecordMessageInMessageStoreAttribute);
		}

		/// <summary>
		///   Handles timeouts, but !!beware!! timouts are not thrown on the calling thread so they get swallowed when rethrown
		///   here. If you want to do something special, handle your these yourself
		/// </summary>
		private void InternalTimeoutHandler<TRequest>(TRequest request) where TRequest : IMessage
		{
			/*
			 * Do something internally when timeouts occurr... we don't want to log here because we will be assuming in 
			 * that case that when someone passes in a handler, that they will do the logging. Better to enforce that 
			 * the caller will ALWAYS handle the exception appropriately... we are not building a framework packed with assumptions!
			 */
			HrMaxxTrace.TraceError("A timeout occurred for request {0}", request);

			throw new BusTimedOutException(request);
		}

		private void InternalFaultHandler<TRequest>(Fault<TRequest> fault) where TRequest : class
		{
			/*
			 * Do something internally when timeouts occurr... we don't want to log here because we will be assuming in 
			 * that case that when someone passes in a handler, that they will do the logging. Better to enforce that 
			 * the caller will ALWAYS handle the exception appropriately... we are not building a framework packed with assumptions!
			 */
			fault.Messages.ForEach(m => HrMaxxTrace.TraceError("Message of type {0} faulted: {1}", typeof (TRequest), m));

			throw new BusFaultedException<TRequest>(fault);
		}

		private bool IsMemoryBusMessage(IMessage message)
		{
			return message.GetType()
				.GetCustomAttributes(true)
				.Any(a => a is MemoryBusMessageAttribute);
		}

		private bool IsServiceBusMessage(IMessage message)
		{
			return message.GetType()
				.GetCustomAttributes(true)
				.Any(a => a is ServiceBusMessageAttribute);
		}

		private static LogMessageCommand GetLogMessageCommand(string message, object relatedBusMessage,
			LogSeverityEnum severity, Exception exception = null)
		{
			return relatedBusMessage != null
				? new LogMessageCommand
				{
					Message = message,
					Severity = severity,
					Exception = exception,
					SerializedRelatedBusMessageType = relatedBusMessage.GetType().ToString(),
					SerializedRelatedBusMessage = relatedBusMessage.ToString()
				}
				: new LogMessageCommand
				{
					Message = message,
					Severity = severity,
					Exception = exception
				};
		}
	}
}
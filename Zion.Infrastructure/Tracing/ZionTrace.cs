using System;
using System.Collections.Concurrent;
using System.Diagnostics;
using System.Linq;

namespace HrMaxx.Infrastructure.Tracing
{
	public class HrMaxxTrace
	{
		private static readonly TraceSource Log = new TraceSource("ZGlobalTrace");
		private static readonly TraceSource PerfLog = new TraceSource("ZPerfTrace");

		private static readonly ConcurrentDictionary<Guid, TraceMessage> Messages =
			new ConcurrentDictionary<Guid, TraceMessage>();

		public static void PerfTrace(Action todo, PerfTraceType traceType, Type source, string format,
			params object[] message)
		{
			Guid correlationId = StartPerfTrace(traceType, source, format, message);
			todo();
			EndPerfTrace(correlationId);
		}

		public static void LogRequest(PerfTraceType traceType, Type source, string format,
			params object[] message)
		{
			Log.TraceEvent(TraceEventType.Verbose, 0,
				/* trace type|source|message */
				"{0}|{1}|{2}|{3}|{4}",
				message.Any() ? message.Aggregate(string.Empty, (current, m) => current + m + ", ") : string.Empty,
				traceType, source.FullName, format, DateTime.Now.TimeOfDay);
		}

		public static Guid StartPerfTrace(PerfTraceType traceType, Type source, string format, params object[] message)
		{
			Guid correlationId = Guid.NewGuid();
			Messages.AddOrUpdate(correlationId,
				new TraceMessage(traceType, source, DateTime.Now, correlationId, format, message),
				(g, tm) =>
				{
					if (Messages.ContainsKey(g)) Messages[g] = tm;
					return tm;
				});
			return correlationId;
		}

		public static void EndPerfTrace(Guid correlationId)
		{
			TraceMessage startMessage;
			Messages.TryRemove(correlationId, out startMessage);
			if (startMessage == null) return;
			DateTime now = DateTime.Now;

			PerfLog.TraceEvent(TraceEventType.Verbose, 0,
				/* start date|end date|trace type|source|message|elapsed */
				"|{0}|{1}|{2}|{3}|{4}|{5}",
				startMessage.DateTime.ToString("dd/MM/yy HH:mm:ss:ffff"), now.ToString("dd/MM/yy HH:mm:ss:ffff"),
				startMessage.PerfTraceType, startMessage.Source.FullName, startMessage.Message,
				(now - startMessage.DateTime).TotalMilliseconds);
		}

		public static void TraceEvent(TraceEventType level, string format, params object[] message)
		{
			Log.TraceEvent(level, 0, format, message);
		}

		public static void TraceInformation(string format, params object[] message)
		{
			Log.TraceInformation(format, message);
		}

		public static void TraceError(string format, params object[] error)
		{
			TraceEvent(TraceEventType.Error, format, error);
		}

		public static void TraceException(params object[] data)
		{
			Log.TraceData(TraceEventType.Error, 0, data);
		}

		public static void AddListener(TraceListener traceListener)
		{
			Log.Listeners.Add(traceListener);
		}

		internal class TraceMessage
		{
			public TraceMessage(PerfTraceType traceType, Type source, DateTime dateTime, Guid correlationId, string format,
				params object[] message)
			{
				Message = String.Format(format, message);

				DateTime = dateTime;
				CorrelationId = correlationId;
				PerfTraceType = traceType;
				Source = source;
			}

			public DateTime DateTime { get; set; }
			public Guid CorrelationId { get; set; }
			public string Message { get; set; }
			public PerfTraceType PerfTraceType { get; set; }
			public Type Source { get; set; }
		}
	}
}
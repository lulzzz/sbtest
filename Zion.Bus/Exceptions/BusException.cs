using System;
using HrMaxx.Bus.Contracts;

namespace HrMaxx.Bus.Exceptions
{
	public class BusException : ApplicationException
	{
		public BusException()
		{
		}

		public BusException(string message)
			: base(message)
		{
		}

		public BusException(IMessage message)
		{
			BusMessage = message;
		}

		public BusException(string message, IMessage busMessage)
			: base(message)
		{
			BusMessage = busMessage;
		}

		public IMessage BusMessage { get; set; }
	}
}
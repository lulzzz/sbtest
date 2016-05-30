using System;
using HrMaxx.Bus.Contracts;

namespace HrMaxx.Bus.Exceptions
{
	public class NoBusTargettedException : InvalidOperationException
	{
		private readonly IMessage _message;

		public NoBusTargettedException(IMessage message)
		{
			_message = message;
		}

		public override string Message
		{
			get { return string.Format("No Bus Targetted {0}", _message.GetType()); }
		}
	}
}
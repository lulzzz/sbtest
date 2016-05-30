using HrMaxx.Bus.Contracts;

namespace HrMaxx.Bus.Exceptions
{
	public class BusTimedOutException : BusException
	{
		public BusTimedOutException(IMessage message) : base(message)
		{
		}
	}
}
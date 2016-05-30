using MassTransit;

namespace HrMaxx.Bus.Exceptions
{
	public class BusFaultedException<T> : BusException where T : class
	{
		public BusFaultedException()
		{
		}

		public BusFaultedException(Fault<T> fault)
		{
			Fault = fault;
		}

		public Fault<T> Fault { get; set; }
	}
}
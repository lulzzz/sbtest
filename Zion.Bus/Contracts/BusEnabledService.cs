namespace HrMaxx.Bus.Contracts
{
	public abstract class BusEnabledService
	{
		public IBus Bus { get; set; }
	}
}
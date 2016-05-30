namespace HrMaxx.Bus.Contracts
{
	public interface IEventPublisher
	{
		void Publish<T>(T @event) where T : Event;
	}
}
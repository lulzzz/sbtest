namespace HrMaxx.Bus.Contracts
{
	public interface IHandle<in T> : IMessageHandler where T : IMessage
	{
		void Handle(T message);
	}

	public interface IMessageHandler
	{
	}
}
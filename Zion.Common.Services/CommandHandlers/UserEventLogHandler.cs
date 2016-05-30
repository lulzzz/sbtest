using HrMaxx.Common.Contracts.Messages.Events;
using HrMaxx.Infrastructure.Services;
using MassTransit;

namespace HrMaxx.Common.Services.CommandHandlers
{
	public class UserEventLogHandler : BaseService, Consumes<UserEventLogEntry>.All
	{
		public void Consume(UserEventLogEntry eventLogEntry)
		{
		}
	}
}
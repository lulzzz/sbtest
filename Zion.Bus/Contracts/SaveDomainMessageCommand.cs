using System;
using System.Threading;

namespace HrMaxx.Bus.Contracts
{
	public class SaveDomainMessageCommand : Command
	{
		public SaveDomainMessageCommand(object message)
		{
			Message = message.ToString();
			MessageType = message.GetType().ToString();
			Who = Thread.CurrentPrincipal.Identity.Name;
			When = DateTime.Now;
			IsCommand = message is Command;
		}

		public string Message { get; set; }
		public string Who { get; set; }
		public DateTime When { get; set; }
		public string MessageType { get; set; }
		public bool IsCommand { get; set; }
	}
}
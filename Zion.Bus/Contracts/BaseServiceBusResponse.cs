using System.Collections.Generic;
using HrMaxx.Infrastructure.ReadServices;

namespace HrMaxx.Bus.Contracts
{
	public class BaseServiceBusResponse : BaseServiceResponse, IMessage
	{
		public BaseServiceBusResponse()
		{
			Faults = new List<string>();
		}

		public List<string> Faults { get; set; }

		public bool HasFaults()
		{
			return Faults.Count > 0;
		}
	}
}